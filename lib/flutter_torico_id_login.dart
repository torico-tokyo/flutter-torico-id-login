
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterToricoIdLogin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_torico_id_login');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
