import 'package:no_tapjack/tapjack_snapshot.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'no_tapjack_method_channel.dart';

abstract class NoTapjackPlatform extends PlatformInterface {
  NoTapjackPlatform() : super(token: _token);

  static final Object _token = Object();

  static NoTapjackPlatform _instance = MethodChannelNoTapjack();

  static NoTapjackPlatform get instance => _instance;

  static set instance(NoTapjackPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<TapjackSnapshot> get tapjackStream {
    throw UnimplementedError('tapjackStream has not been implemented.');
  }

  Future<void> startListening() {
    throw UnimplementedError('startListening has not been implemented.');
  }

  Future<void> stopListening() {
    throw UnimplementedError('stopListening has not been implemented.');
  }

  Future<bool> enableFilterTouches() {
    throw UnimplementedError('enableFilterTouches has not been implemented.');
  }

  Future<bool> disableFilterTouches() {
    throw UnimplementedError('disableFilterTouches has not been implemented.');
  }
}
