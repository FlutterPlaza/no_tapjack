import 'dart:async';

import 'no_tapjack_platform_interface.dart';
import 'tapjack_snapshot.dart';

/// Safe no-op implementation of [NoTapjackPlatform] for platforms where
/// tapjacking is not a real threat (web, macOS, Windows, Linux).
///
/// Always reports no overlay detected. All methods are safe no-ops.
class NoTapjackSafeNoop extends NoTapjackPlatform {
  /// Registers this class as the platform instance.
  ///
  /// Called automatically by the Flutter framework for web and desktop
  /// platforms via `pubspec.yaml` plugin registration.
  static void registerWith([dynamic registrar]) {
    NoTapjackPlatform.instance = NoTapjackSafeNoop();
  }

  final _controller = StreamController<TapjackSnapshot>.broadcast();

  @override
  Stream<TapjackSnapshot> get tapjackStream => _controller.stream;

  @override
  Future<void> startListening() async {
    _controller.add(TapjackSnapshot(isOverlayDetected: false));
  }

  @override
  Future<void> stopListening() async {}

  @override
  Future<bool> enableFilterTouches() async => true;

  @override
  Future<bool> disableFilterTouches() async => true;
}
