package com.flutterplaza.no_tapjack

import android.app.Activity
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.MotionEvent
import android.view.View
import android.view.Window
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

const val START_LISTENING_CONST = "startListening"
const val STOP_LISTENING_CONST = "stopListening"
const val ENABLE_FILTER_TOUCHES_CONST = "enableFilterTouches"
const val DISABLE_FILTER_TOUCHES_CONST = "disableFilterTouches"
const val TAPJACK_METHOD_CHANNEL = "com.flutterplaza.no_tapjack_methods"
const val TAPJACK_EVENT_CHANNEL = "com.flutterplaza.no_tapjack_streams"

class NoTapjackPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    EventChannel.StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private val handler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var lastEventJson: String = ""
    private var hasPendingEvent: Boolean = false
    private var isListening: Boolean = false

    private var activity: Activity? = null
    private var originalWindowCallback: Window.Callback? = null
    private var isTouchFilterEnabled: Boolean = false
    private var isOverlayDetected: Boolean = false
    private var isPartialOverlay: Boolean = false
    private var overlayDetectedTimestamp: Long = 0

    // Reset overlay detection after 2 seconds of no obscured touches
    private val overlayResetDelayMs: Long = 2000

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, TAPJACK_METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, TAPJACK_EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        stopDetection()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        removeWindowCallback()
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        if (isListening) {
            installWindowCallback()
        }
    }

    override fun onDetachedFromActivity() {
        removeWindowCallback()
        activity = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            START_LISTENING_CONST -> {
                startDetection()
                result.success("Listening started")
            }
            STOP_LISTENING_CONST -> {
                stopDetection()
                result.success("Listening stopped")
            }
            ENABLE_FILTER_TOUCHES_CONST -> {
                enableFilterTouches()
                result.success(true)
            }
            DISABLE_FILTER_TOUCHES_CONST -> {
                disableFilterTouches()
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        handler.postDelayed(streamRunnable, 1000)
    }

    override fun onCancel(arguments: Any?) {
        handler.removeCallbacks(streamRunnable)
        eventSink = null
    }

    private fun startDetection() {
        if (isListening) return
        isListening = true
        installWindowCallback()
        updateState()
    }

    private fun stopDetection() {
        if (!isListening) return
        isListening = false
        removeWindowCallback()
        handler.removeCallbacks(overlayResetRunnable)
        isOverlayDetected = false
        isPartialOverlay = false
    }

    private fun enableFilterTouches() {
        isTouchFilterEnabled = true
        val act = activity ?: return
        act.window.decorView.filterTouchesWhenObscured = true
        updateState()
    }

    private fun disableFilterTouches() {
        isTouchFilterEnabled = false
        val act = activity ?: return
        act.window.decorView.filterTouchesWhenObscured = false
        updateState()
    }

    private fun installWindowCallback() {
        val act = activity ?: return
        val window = act.window

        // Avoid wrapping our own callback
        if (window.callback is TapjackWindowCallback) return

        originalWindowCallback = window.callback
        window.callback = TapjackWindowCallback(
            original = window.callback,
            onOverlayDetected = { full, partial ->
                val changed = isOverlayDetected != (full || partial) ||
                        isPartialOverlay != partial
                isOverlayDetected = full || partial
                isPartialOverlay = partial
                overlayDetectedTimestamp = System.currentTimeMillis()

                // Schedule a reset if no further obscured touches happen
                handler.removeCallbacks(overlayResetRunnable)
                handler.postDelayed(overlayResetRunnable, overlayResetDelayMs)

                if (changed) {
                    updateState()
                }
            }
        )
    }

    private fun removeWindowCallback() {
        val act = activity ?: return
        val window = act.window
        if (window.callback is TapjackWindowCallback) {
            window.callback = originalWindowCallback
            originalWindowCallback = null
        }
    }

    private val overlayResetRunnable = Runnable {
        val elapsed = System.currentTimeMillis() - overlayDetectedTimestamp
        if (elapsed >= overlayResetDelayMs && isOverlayDetected) {
            isOverlayDetected = false
            isPartialOverlay = false
            updateState()
        }
    }

    private fun updateState() {
        val json = JSONObject(
            mapOf(
                "is_overlay_detected" to isOverlayDetected,
                "is_partial_overlay" to isPartialOverlay,
                "is_touch_filter_enabled" to isTouchFilterEnabled
            )
        ).toString()

        if (lastEventJson != json) {
            lastEventJson = json
            hasPendingEvent = true
        }
    }

    private val streamRunnable = object : Runnable {
        override fun run() {
            if (hasPendingEvent) {
                eventSink?.success(lastEventJson)
                hasPendingEvent = false
            }
            handler.postDelayed(this, 1000)
        }
    }

    /**
     * Custom Window.Callback that intercepts touch events to detect overlay attacks.
     * Checks MotionEvent flags for FLAG_WINDOW_IS_OBSCURED (API 9+) and
     * FLAG_WINDOW_IS_PARTIALLY_OBSCURED (API 29+).
     */
    private class TapjackWindowCallback(
        private val original: Window.Callback?,
        private val onOverlayDetected: (full: Boolean, partial: Boolean) -> Unit
    ) : Window.Callback by (original ?: throw IllegalStateException("Original callback required")) {

        override fun dispatchTouchEvent(event: MotionEvent?): Boolean {
            if (event != null) {
                val isObscured = event.flags and MotionEvent.FLAG_WINDOW_IS_OBSCURED != 0
                val isPartiallyObscured = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    event.flags and MotionEvent.FLAG_WINDOW_IS_PARTIALLY_OBSCURED != 0
                } else {
                    false
                }

                if (isObscured || isPartiallyObscured) {
                    onOverlayDetected(isObscured, isPartiallyObscured)
                }
            }
            return original?.dispatchTouchEvent(event) ?: false
        }
    }
}
