import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:no_tapjack/constants.dart';
import 'package:no_tapjack/tapjack_snapshot.dart';

import 'no_tapjack_platform_interface.dart';

/// Android/iOS implementation of [NoTapjackPlatform] using platform channels.
class MethodChannelNoTapjack extends NoTapjackPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(tapjackMethodChannel);
  @visibleForTesting
  final eventChannel = const EventChannel(tapjackEventChannel);

  @override
  Stream<TapjackSnapshot> get tapjackStream {
    return eventChannel.receiveBroadcastStream().map((event) =>
        TapjackSnapshot.fromMap(jsonDecode(event) as Map<String, dynamic>));
  }

  @override
  Future<void> startListening() {
    return methodChannel.invokeMethod<void>(startListeningConst);
  }

  @override
  Future<void> stopListening() {
    return methodChannel.invokeMethod<void>(stopListeningConst);
  }

  @override
  Future<bool> enableFilterTouches() async {
    final result =
        await methodChannel.invokeMethod<bool>(enableFilterTouchesConst);
    return result ?? false;
  }

  @override
  Future<bool> disableFilterTouches() async {
    final result =
        await methodChannel.invokeMethod<bool>(disableFilterTouchesConst);
    return result ?? false;
  }
}
