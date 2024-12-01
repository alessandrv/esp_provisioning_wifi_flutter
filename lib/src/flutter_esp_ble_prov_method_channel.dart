// lib/src/flutter_esp_ble_prov_method_channel.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/wifi_network.dart';
import 'flutter_esp_ble_prov_platform_interface.dart';

class MethodChannelFlutterEspBleProv extends FlutterEspBleProvPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_esp_ble_prov');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<List<String>> scanBleDevices(String prefix) async {
    final args = {'prefix': prefix};
    final raw =
        await methodChannel.invokeMethod<List<Object?>>('scanBleDevices', args);
    final List<String> devices = [];
    if (raw != null) {
      devices.addAll(raw.cast<String>());
    }
    return devices;
  }

  @override
  Future<List<WifiNetwork>> scanWifiNetworks(
      String deviceName, String proofOfPossession) async {
    final args = {
      'deviceName': deviceName,
      'proofOfPossession': proofOfPossession,
    };
    final raw = await methodChannel.invokeMethod<List<dynamic>>(
        'scanWifiNetworks', args);

    if (raw == null) {
      return [];
    }

    return raw.map((dynamic wifi) {
      if (wifi is Map) {
        return WifiNetwork.fromMap(wifi);
      } else {
        throw FormatException('Invalid Wi-Fi network format');
      }
    }).toList();
  }

  @override
  Future<bool?> provisionWifi(String deviceName, String proofOfPossession,
      String ssid, String passphrase) async {
    final args = {
      'deviceName': deviceName,
      'proofOfPossession': proofOfPossession,
      'ssid': ssid,
      'passphrase': passphrase
    };
    return await methodChannel.invokeMethod<bool?>('provisionWifi', args);
  }
}
