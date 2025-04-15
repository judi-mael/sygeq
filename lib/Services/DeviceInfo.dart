import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String> getPhoneInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
      return "Androïd - ${info.manufacturer} - ${info.model}";
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
      return "IOS - ${info.name} - ${info.model}";
    } else {
      throw UnimplementedError();
    }
  }
}
