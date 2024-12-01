class WifiNetwork {
  final String ssid;
  final int rssi;

  WifiNetwork({required this.ssid, required this.rssi});

  factory WifiNetwork.fromMap(Map<dynamic, dynamic> map) {
    return WifiNetwork(
      ssid: map['ssid'] as String,
      rssi: map['rssi'] as int,
    );
  }
}