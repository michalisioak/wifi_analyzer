import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

class GetData extends StatelessWidget {
  const GetData({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: WiFiScan.instance.canGetScannedResults(askPermissions: true),
        builder: (context, snapshot) {
          final error = snapshot.error;
          if (error != null) {
            return Text(error.toString());
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data != CanGetScannedResults.yes) {
            return const Text("Persmissions denied or Device not supported");
          }

          return child;
        });
  }
}
