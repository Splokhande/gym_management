

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paldes/Widgets/text.dart';

class GymBranch{

  String branchId;
  String branchName;

  GymBranch({this.branchId, this.branchName});

  factory GymBranch.fromMap(data){
    return GymBranch(
      branchId: data["id"],
      branchName: data["area"]
    );
  }

}

var attendanceProvider = ChangeNotifierProvider<AttendanceProvider>((ref)=>AttendanceProvider(ref));

class AttendanceProvider extends ChangeNotifier{

  ProviderReference ref;
  String branchId= "";
  String branchName= "";
  GymBranch selectedBranch = GymBranch();
  List<GymBranch> branchList = [];
  String scanBarcode = 'Unknown';
  AttendanceProvider(ref){
    getBranch();
  }

  getBranch()async{
    QuerySnapshot doc =  await FirebaseFirestore.instance.collection("branches").get();
    for(int i=0; i<doc.docs.length; i++){
      branchList.add(GymBranch.fromMap(doc.docs[i].data()));
    }
    notifyListeners();
  }



  Future<bool> canReadStorage() async {
    if(Platform.isIOS) return true;
    var status = await Permission.storage.status;
        // .checkPermissionStatus(PermissionGroup.storage);
    if (status.isDenied) {
      var future = await Permission.storage.request();

        if (future != PermissionStatus.granted) {
          return false;

      }
    } else {
      return true;
    }
    return true;
  }

  Future<bool> canOpenCamera() async {
    var status = await Permission.camera.status;
    // .checkPermissionStatus(PermissionGroup.storage);
    if (status.isDenied) {
      var future = await Permission.camera.request();

      if (future != PermissionStatus.granted) {
        return false;

      }
    } else {
      return true;
    }
    return true;
  }

  List<DropdownMenuItem> branchItems(){
    List<DropdownMenuItem> list = [];

    for(int i=0; i<branchList.length;i++){
      list.add(DropdownMenuItem(
        child: PText(
            isWhite: false,
          text: branchList[i].branchName,
          isMd: true,
        ),
        value:i ,
      ));
    }


  }

  onBranchSelected(i){
    selectedBranch = branchList[i];
    notifyListeners();

  }
  /// flutter_barcode_scanner
  // Future<void> scanQR() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //
  //   scanBarcode = barcodeScanRes;
  // }
  scanQR(){}


}