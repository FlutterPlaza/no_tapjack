import 'package:flutter_test/flutter_test.dart';
import 'package:no_tapjack/no_tapjack_method_channel.dart';
import 'package:no_tapjack/no_tapjack_platform_interface.dart';
import 'package:no_tapjack/tapjack_snapshot.dart';

class BaseNoTapjackPlatform extends NoTapjackPlatform {}

class MockNoTapjackPlatform extends NoTapjackPlatform {
  @override
  Stream<TapjackSnapshot> get tapjackStream => const Stream.empty();

  @override
  Future<void> startListening() async {
    return;
  }

  @override
  Future<void> stopListening() async {
    return;
  }

  @override
  Future<bool> enableFilterTouches() async {
    return true;
  }

  @override
  Future<bool> disableFilterTouches() async {
    return true;
  }
}

void main() {
  final platform = MockNoTapjackPlatform();

  group('NoTapjackPlatform', () {
    test('default instance should be MethodChannelNoTapjack', () {
      expect(
          NoTapjackPlatform.instance, isInstanceOf<MethodChannelNoTapjack>());
    });

    test('tapjackStream should not throw UnimplementedError when accessed', () {
      expect(() => platform.tapjackStream, isNot(throwsUnimplementedError));
    });

    test('startListening should not throw UnimplementedError when called',
        () async {
      expect(platform.startListening(), completes);
    });

    test('stopListening should not throw UnimplementedError when called',
        () async {
      expect(platform.stopListening(), completes);
    });

    test('enableFilterTouches should not throw UnimplementedError when called',
        () async {
      expect(platform.enableFilterTouches(), completes);
    });

    test('disableFilterTouches should not throw UnimplementedError when called',
        () async {
      expect(platform.disableFilterTouches(), completes);
    });

    test('base NoTapjackPlatform.tapjackStream throws UnimplementedError', () {
      final basePlatform = BaseNoTapjackPlatform();
      expect(() => basePlatform.tapjackStream, throwsUnimplementedError);
    });

    test('base NoTapjackPlatform.startListening() throws UnimplementedError',
        () {
      final basePlatform = BaseNoTapjackPlatform();
      expect(() => basePlatform.startListening(), throwsUnimplementedError);
    });

    test('base NoTapjackPlatform.stopListening() throws UnimplementedError',
        () {
      final basePlatform = BaseNoTapjackPlatform();
      expect(() => basePlatform.stopListening(), throwsUnimplementedError);
    });

    test(
        'base NoTapjackPlatform.enableFilterTouches() throws UnimplementedError',
        () {
      final basePlatform = BaseNoTapjackPlatform();
      expect(
          () => basePlatform.enableFilterTouches(), throwsUnimplementedError);
    });

    test(
        'base NoTapjackPlatform.disableFilterTouches() throws UnimplementedError',
        () {
      final basePlatform = BaseNoTapjackPlatform();
      expect(
          () => basePlatform.disableFilterTouches(), throwsUnimplementedError);
    });
  });
}
