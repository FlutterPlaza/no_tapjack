import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:no_tapjack/constants.dart';
import 'package:no_tapjack/tapjack_snapshot.dart';
import 'package:no_tapjack/no_tapjack_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelNoTapjack platform;

  setUp(() {
    platform = MethodChannelNoTapjack();
  });

  group('MethodChannelNoTapjack', () {
    const MethodChannel channel = MethodChannel(tapjackMethodChannel);

    test('startListening', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == startListeningConst) {
          return null;
        }
        return null;
      });

      await platform.startListening();
      expect(true, true);
    });

    test('stopListening', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == stopListeningConst) {
          return null;
        }
        return null;
      });

      await platform.stopListening();
      expect(true, true);
    });

    test('enableFilterTouches', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == enableFilterTouchesConst) {
          return true;
        }
        return null;
      });

      final result = await platform.enableFilterTouches();
      expect(result, true);
    });

    test('disableFilterTouches', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == disableFilterTouchesConst) {
          return true;
        }
        return null;
      });

      final result = await platform.disableFilterTouches();
      expect(result, true);
    });
  });

  group('TapjackSnapshot', () {
    test('fromMap', () {
      final map = {
        'is_overlay_detected': true,
        'is_partial_overlay': true,
        'is_touch_filter_enabled': true,
      };
      final snapshot = TapjackSnapshot.fromMap(map);
      expect(snapshot.isOverlayDetected, true);
      expect(snapshot.isPartialOverlay, true);
      expect(snapshot.isTouchFilterEnabled, true);
    });

    test('fromMap with defaults', () {
      final snapshot = TapjackSnapshot.fromMap({});
      expect(snapshot.isOverlayDetected, false);
      expect(snapshot.isPartialOverlay, false);
      expect(snapshot.isTouchFilterEnabled, false);
    });

    test('fromMap with null values uses defaults', () {
      final map = <String, dynamic>{
        'is_overlay_detected': null,
        'is_partial_overlay': null,
        'is_touch_filter_enabled': null,
      };
      final snapshot = TapjackSnapshot.fromMap(map);
      expect(snapshot.isOverlayDetected, false);
      expect(snapshot.isPartialOverlay, false);
      expect(snapshot.isTouchFilterEnabled, false);
    });

    test('toMap', () {
      final snapshot = TapjackSnapshot(
        isOverlayDetected: true,
        isPartialOverlay: true,
        isTouchFilterEnabled: true,
      );
      final map = snapshot.toMap();
      expect(map['is_overlay_detected'], true);
      expect(map['is_partial_overlay'], true);
      expect(map['is_touch_filter_enabled'], true);
    });

    test('equality operator', () {
      final snapshot1 = TapjackSnapshot(
        isOverlayDetected: true,
        isPartialOverlay: false,
        isTouchFilterEnabled: true,
      );
      final snapshot2 = TapjackSnapshot(
        isOverlayDetected: true,
        isPartialOverlay: false,
        isTouchFilterEnabled: true,
      );
      final snapshot3 = TapjackSnapshot(
        isOverlayDetected: false,
        isPartialOverlay: true,
        isTouchFilterEnabled: false,
      );
      final snapshot4 = TapjackSnapshot(
        isOverlayDetected: true,
        isPartialOverlay: false,
        isTouchFilterEnabled: false,
      );

      expect(snapshot1 == snapshot2, true);
      expect(snapshot1 == snapshot3, false);
      expect(snapshot1 == snapshot4, false);
    });

    test('hashCode', () {
      final snapshot1 = TapjackSnapshot(
        isOverlayDetected: true,
        isPartialOverlay: false,
        isTouchFilterEnabled: true,
      );
      final snapshot2 = TapjackSnapshot(
        isOverlayDetected: true,
        isPartialOverlay: false,
        isTouchFilterEnabled: true,
      );
      final snapshot3 = TapjackSnapshot(
        isOverlayDetected: false,
        isPartialOverlay: true,
        isTouchFilterEnabled: false,
      );

      expect(snapshot1.hashCode, snapshot2.hashCode);
      expect(snapshot1.hashCode, isNot(snapshot3.hashCode));
    });

    test('toString', () {
      final snapshot = TapjackSnapshot(
        isOverlayDetected: true,
        isPartialOverlay: false,
        isTouchFilterEnabled: true,
      );
      final string = snapshot.toString();
      expect(string,
          'TapjackSnapshot(\nisOverlayDetected: true, \nisPartialOverlay: false, \nisTouchFilterEnabled: true\n)');
    });
  });
}
