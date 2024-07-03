import 'package:flutter/material.dart';
import 'package:windows_system_info/windows_system_info.dart';
import 'package:flutter/material.dart' as flutter;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Get MAC Address Example",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GetMACAddressExample(),
    );
  }
}

class GetMACAddressExample extends StatefulWidget {
  const GetMACAddressExample({super.key});

  @override
  State<GetMACAddressExample> createState() => _GetMACAddressExampleState();
}

class _GetMACAddressExampleState extends State<GetMACAddressExample> {
  List<String> _selectedMacAdress = [];
  bool _loading = true;
  // List<NetworkInfo> _networkInfo = [];

  @override
  void initState() {
    super.initState();
    _getNetworkInfo();
  }

  Future<void> _getNetworkInfo() async {
    await WindowsSystemInfo.initWindowsInfo(
      requiredValues: [WindowsSystemInfoFeat.network],
    );
    if (await WindowsSystemInfo.isInitilized) {
      final macAddress = WindowsSystemInfo.network
          .where((e) =>
              e.ifaceName.contains('Ethernet') &&
              e.mac.isNotEmpty &&
              e.type != 'virtual')
          .map((e) => e.mac)
          .toList();
      flutter.debugPrint("Data: $macAddress");

      setState(() {
        _selectedMacAdress = macAddress;
        // _networkInfo = WindowsSystemInfo.network;
        // flutter.debugPrint("Network Data : $_networkInfo");
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MAC Address Example"),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _selectedMacAdress.isEmpty
              ? const Text("No Network Found")
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _selectedMacAdress.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'MAC Address: $e',
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w700),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
