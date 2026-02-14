import 'package:flutter_test/flutter_test.dart';
import 'package:no_tapjack/no_tapjack.dart';
import 'package:no_tapjack/no_tapjack_method_channel.dart';
import 'package:no_tapjack/no_tapjack_platform_interface.dart';
import 'package:no_tapjack/tapjack_snapshot.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNoTapjackPlatform
    with MockPlatformInterfaceMixin
    implements NoTapjackPlatform {
  @override
  Stream<TapjackSnapshot> get tapjackStream => const Stream.empty();

  @override
  Future<void> startListening() {
    return Future.value();
  }

  @override
  Future<void> stopListening() {
    return Future.value();
  }

  @override
  Future<bool> enableFilterTouches() {
    return Future.value(true);
  }

  @override
  Future<bool> disableFilterTouches() {
    return Future.value(true);
  }
}

void main() {
  final NoTapjackPlatform initialPlatform = NoTapjackPlatform.instance;
  MockNoTapjackPlatform fakePlatform = MockNoTapjackPlatform();

  setUp(() {
    NoTapjackPlatform.instance = fakePlatform;
  });

  tearDown(() {
    NoTapjackPlatform.instance = initialPlatform;
  });

  test('\$MethodChannelNoTapjack is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNoTapjack>());
  });

  test('NoTapjack instance is a singleton', () {
    final instance1 = NoTapjack.instance;
    final instance2 = NoTapjack.instance;
    expect(instance1, equals(instance2));
  });

  test('tapjackStream', () {
    expect(NoTapjack.instance.tapjackStream,
        isInstanceOf<Stream<TapjackSnapshot>>());
  });

  test('startListening', () async {
    expect(NoTapjack.instance.startListening(), completes);
  });

  test('stopListening', () async {
    expect(NoTapjack.instance.stopListening(), completes);
  });

  test('enableFilterTouches', () async {
    final result = await NoTapjack.instance.enableFilterTouches();
    expect(result, true);
  });

  test('disableFilterTouches', () async {
    final result = await NoTapjack.instance.disableFilterTouches();
    expect(result, true);
  });

  test('NoTapjack equality operator', () {
    final instance1 = NoTapjack.instance;
    final instance2 = NoTapjack.instance;

    expect(instance1 == instance2, true, reason: 'Instances should be equal');
  });

  test('NoTapjack hashCode consistency', () {
    final instance1 = NoTapjack.instance;
    final instance2 = NoTapjack.instance;

    expect(instance1.hashCode, instance2.hashCode);
  });
}
