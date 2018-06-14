import 'dart:async';

import 'package:flutter/services.dart';

class GirliesChannels {
  static const MethodChannel _channel =
      const MethodChannel('maugost.com/paystack_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get facebookLogin async {
    final String token = await _channel.invokeMethod('facebookLogin');
    return token;
  }

  static Future<String> get facebookLogout async {
    final String version = await _channel.invokeMethod('facebookLogout');
    return version;
  }

  static Future<dynamic> connectToPaystack(Map<String, dynamic> args) async {
    final String version = await _channel.invokeMethod('payWithPaystack', args);
    return version;
  }
}
