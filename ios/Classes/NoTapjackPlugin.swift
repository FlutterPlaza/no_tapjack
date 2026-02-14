import Flutter
import UIKit

public class NoTapjackPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private static var methodChannel: FlutterMethodChannel? = nil
    private static var eventChannel: FlutterEventChannel? = nil
    private var eventSink: FlutterEventSink? = nil
    private var lastEventJson: String = ""
    private var hasPendingEvent: Bool = false
    private var isListening: Bool = false

    private static let methodChannelName = "com.flutterplaza.no_tapjack_methods"
    private static let eventChannelName = "com.flutterplaza.no_tapjack_streams"

    public static func register(with registrar: FlutterPluginRegistrar) {
        methodChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: registrar.messenger())
        eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: registrar.messenger())

        let instance = NoTapjackPlugin()

        registrar.addMethodCallDelegate(instance, channel: methodChannel!)
        eventChannel?.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startListening":
            startDetection()
            result("Listening started")
        case "stopListening":
            stopDetection()
            result("Listening stopped")
        case "enableFilterTouches":
            // iOS does not support overlay attacks — no-op, always safe
            result(true)
        case "disableFilterTouches":
            // iOS does not support overlay attacks — no-op
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startDetection() {
        guard !isListening else { return }
        isListening = true
        updateState()
    }

    private func stopDetection() {
        guard isListening else { return }
        isListening = false
    }

    private func updateState() {
        // iOS does not allow third-party apps to draw overlays,
        // so tapjacking is not possible. Always report safe state.
        let map: [String: Any] = [
            "is_overlay_detected": false,
            "is_partial_overlay": false,
            "is_touch_filter_enabled": false
        ]
        let jsonString = convertMapToJsonString(map)

        if lastEventJson != jsonString {
            lastEventJson = jsonString
            hasPendingEvent = true
        }
    }

    private func convertMapToJsonString(_ map: [String: Any]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: map, options: []) {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return ""
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tapjackStream()
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    private func tapjackStream() {
        if hasPendingEvent {
            eventSink?(lastEventJson)
            hasPendingEvent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tapjackStream()
        }
    }
}
