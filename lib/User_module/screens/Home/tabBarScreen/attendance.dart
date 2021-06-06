import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paldes/User_module/riverpod/home.dart';


class QRScanner extends HookWidget {


  @override
  Widget build(BuildContext context) {
    var getBranch = useProvider(attendanceProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  getBranch.scanQR(),
              child: Text('Start QR scan')),
        ],
      ),

    );
  }
}
