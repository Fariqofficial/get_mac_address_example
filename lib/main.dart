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
  List<NetworkInfo> _networkInfo = [];
  bool _loading = true;

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
      setState(() {
        _networkInfo = WindowsSystemInfo.network;
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
          : _networkInfo.isEmpty
              ? const Text("No Network Found")
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _networkInfo.map((adapter) {
                      final macAddress = adapter.mac;
                      flutter.debugPrint("MAC Address is : $macAddress");
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          title: Text('Adapter: ${adapter.ifaceName}'),
                          subtitle: Text(
                            'MAC Address: $macAddress',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
