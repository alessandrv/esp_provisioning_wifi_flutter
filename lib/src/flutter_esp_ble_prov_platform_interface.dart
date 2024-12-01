// lib/src/flutter_esp_ble_prov_platform_interface.dart

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_esp_ble_prov_method_channel.dart';
import '../models/wifi_network.dart';

abstract class FlutterEspBleProvPlatform extends PlatformInterface {
  FlutterEspBleProvPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEspBleProvPlatform _instance = MethodChannelFlutterEspBleProv();

  static FlutterEspBleProvPlatform get instance => _instance;

  static set instance(FlutterEspBleProvPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<String>> scanBleDevices(String prefix) {
    throw UnimplementedError('scanBleDevices has not been implemented.');
  }

  // Update the return type to Future<List<WifiNetwork>>
  Future<List<WifiNetwork>> scanWifiNetworks(
      String deviceName, String proofOfPossession) {
    throw UnimplementedError('scanWifiNetworks has not been implemented.');
  }

  Future<bool?> provisionWifi(String deviceName, String proofOfPossession,
      String ssid, String passphrase) {
    throw UnimplementedError('provisionWifi has not been implemented');
  }
}
