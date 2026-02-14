import 'package:no_tapjack/tapjack_snapshot.dart';

import 'no_tapjack_platform_interface.dart';

/// Main entry point for the no_tapjack plugin.
///
/// Use [instance] to obtain a singleton and call [startListening] to begin
/// monitoring for overlay attacks.
class NoTapjack implements NoTapjackPlatform {
  final _instancePlatform = NoTapjackPlatform.instance;
  NoTapjack._();

  /// Returns a [NoTapjack] instance bound to the current platform.
  static NoTapjack get instance => NoTapjack._();

  @override
  Stream<TapjackSnapshot> get tapjackStream {
    return _instancePlatform.tapjackStream;
  }

  @override
  Future<void> startListening() {
    return _instancePlatform.startListening();
  }

  @override
  Future<void> stopListening() {
    return _instancePlatform.stopListening();
  }

  @override
  Future<bool> enableFilterTouches() {
    return _instancePlatform.enableFilterTouches();
  }

  @override
  Future<bool> disableFilterTouches() {
    return _instancePlatform.disableFilterTouches();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NoTapjack &&
            runtimeType == other.runtimeType &&
            _instancePlatform == other._instancePlatform;
  }

  @override
  int get hashCode => _instancePlatform.hashCode;
}
