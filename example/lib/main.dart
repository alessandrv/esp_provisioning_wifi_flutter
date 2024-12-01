// lib/main.dart

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_esp_ble_prov/flutter_esp_ble_prov.dart';
import 'package:flutter_esp_ble_prov/models/wifi_network.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterEspBleProvPlugin = FlutterEspBleProv();

  final defaultPadding = 12.0;
  final defaultDevicePrefix = 'PROV';

  List<String> devices = [];
  List<WifiNetwork> networks = []; // Change to List<WifiNetwork>

  String selectedDeviceName = '';
  String selectedSsid = '';
  String feedbackMessage = '';

  final prefixController = TextEditingController(text: 'PROV_');
  final proofOfPossessionController = TextEditingController(text: 'abcd1234');
  final passphraseController = TextEditingController();

  Future<void> scanBleDevices() async {
    final prefix = prefixController.text;
    try {
      final scannedDevices = await _flutterEspBleProvPlugin.scanBleDevices(prefix);
      setState(() {
        devices = scannedDevices;
      });
      pushFeedback('Success: scanned BLE devices');
    } catch (e) {
      pushFeedback('Error scanning BLE devices: $e');
    }
  }

  Future<void> scanWifiNetworks() async {
    if (selectedDeviceName.isEmpty) {
      pushFeedback('Please select a device first.');
      return;
    }

    final proofOfPossession = proofOfPossessionController.text;
    try {
      final scannedNetworks = await _flutterEspBleProvPlugin.scanWifiNetworks(
          selectedDeviceName, proofOfPossession);
      setState(() {
        networks = scannedNetworks;
      });
      pushFeedback('Success: scanned WiFi on $selectedDeviceName');
    } catch (e) {
      pushFeedback('Error scanning WiFi networks: $e');
    }
  }

  Future<void> provisionWifi() async {
    if (selectedDeviceName.isEmpty || selectedSsid.isEmpty) {
      pushFeedback('Please select a device and a WiFi network first.');
      return;
    }

    final proofOfPossession = proofOfPossessionController.text;
    final passphrase = passphraseController.text;

    if (passphrase.isEmpty) {
      pushFeedback('Please enter a passphrase.');
      return;
    }

    try {
      final success = await _flutterEspBleProvPlugin.provisionWifi(
          selectedDeviceName, proofOfPossession, selectedSsid, passphrase);
      if (success == true) {
        pushFeedback(
            'Success: provisioned WiFi $selectedSsid on $selectedDeviceName');
      } else {
        pushFeedback('Failed to provision WiFi $selectedSsid on $selectedDeviceName');
      }
    } catch (e) {
      pushFeedback('Error provisioning WiFi: $e');
    }
  }

  void pushFeedback(String msg) {
    setState(() {
      feedbackMessage = '$feedbackMessage\n$msg';
    });
  }

  @override
  void dispose() {
    prefixController.dispose();
    proofOfPossessionController.dispose();
    passphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP BLE Provisioning Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ESP BLE Provisioning Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bluetooth),
              onPressed: scanBleDevices,
              tooltip: 'Scan BLE Devices',
            ),
          ],
        ),
        bottomSheet: SafeArea(
          child: Container(
            width: double.infinity,
            color: Colors.black87,
            padding: EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
              child: Text(
                feedbackMessage,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green.shade600),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Device Prefix Input
                Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Device Prefix'),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: prefixController,
                          decoration: const InputDecoration(
                              hintText: 'Enter device prefix'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: defaultPadding),

                // BLE Devices List
                const Text(
                  'BLE Devices',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  height: 150, // Adjust as needed
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: devices.isEmpty
                      ? const Center(child: Text('No devices found.'))
                      : ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                devices[index],
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedDeviceName = devices[index];
                                  pushFeedback('Selected device: $selectedDeviceName');
                                });
                                scanWifiNetworks();
                              },
                              selected: devices[index] == selectedDeviceName,
                            );
                          },
                        ),
                ),
                SizedBox(height: defaultPadding),

                // Proof of Possession Input
                Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Proof of Possession'),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: proofOfPossessionController,
                          decoration: const InputDecoration(
                              hintText: 'Enter proof of possession string'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: defaultPadding),

                // WiFi Networks List
                const Text(
                  'WiFi Networks',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  height: 150, // Adjust as needed
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: networks.isEmpty
                      ? const Center(child: Text('No Wi-Fi networks found.'))
                      : ListView.builder(
                          itemCount: networks.length,
                          itemBuilder: (context, index) {
                            final network = networks[index];
                            return ListTile(
                              title: Text(
                                network.ssid,
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('RSSI: ${network.rssi} dBm'),
                              onTap: () {
                                setState(() {
                                  selectedSsid = network.ssid;
                                  pushFeedback('Selected SSID: $selectedSsid');
                                });
                                provisionWifi();
                              },
                              selected: network.ssid == selectedSsid,
                            );
                          },
                        ),
                ),
                SizedBox(height: defaultPadding),

                // WiFi Passphrase Input
                Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('WiFi Passphrase'),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: passphraseController,
                          decoration: const InputDecoration(
                              hintText: 'Enter passphrase'),
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: defaultPadding),

                // Provision Button
                ElevatedButton(
                  onPressed: provisionWifi,
                  child: const Text('Provision WiFi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
