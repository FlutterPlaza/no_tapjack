import 'package:no_tapjack/tapjack_snapshot.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'no_tapjack_method_channel.dart';

/// Platform interface for the no_tapjack plugin.
///
/// Platform-specific implementations should extend this class and override
/// all methods. See [MethodChannelNoTapjack] for the default Android/iOS
/// implementation.
abstract class NoTapjackPlatform extends PlatformInterface {
  /// Constructs a [NoTapjackPlatform].
  NoTapjackPlatform() : super(token: _token);

  static final Object _token = Object();

  static NoTapjackPlatform _instance = MethodChannelNoTapjack();

  /// The current platform-specific instance.
  static NoTapjackPlatform get instance => _instance;

  /// Sets the platform-specific instance. Called by platform implementations.
  static set instance(NoTapjackPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Stream of [TapjackSnapshot] events reflecting overlay state changes.
  Stream<TapjackSnapshot> get tapjackStream {
    throw UnimplementedError('tapjackStream has not been implemented.');
  }

  /// Starts monitoring for overlay attacks.
  Future<void> startListening() {
    throw UnimplementedError('startListening has not been implemented.');
  }

  /// Stops monitoring for overlay attacks.
  Future<void> stopListening() {
    throw UnimplementedError('stopListening has not been implemented.');
  }

  /// Enables `filterTouchesWhenObscured` so Android discards touches
  /// while the window is obscured.
  Future<bool> enableFilterTouches() {
    throw UnimplementedError('enableFilterTouches has not been implemented.');
  }

  /// Disables `filterTouchesWhenObscured`, re-allowing touches while
  /// the window is obscured.
  Future<bool> disableFilterTouches() {
    throw UnimplementedError('disableFilterTouches has not been implemented.');
  }
}
