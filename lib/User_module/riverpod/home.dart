

import 'dart:io';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/Hive/boxes.dart';
import 'package:paldes/modal/Attendance.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';
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


  model.Attendance attendance = model.Attendance();
  List<model.Attendance> myAttendance = [];

  ProviderReference ref;
  String branchId= "";
  String branchName= "";
  GymBranch selectedBranch = GymBranch();
  List<GymBranch> branchList = [];
  String scanBarcode = 'Unknown';
  Map<DateTime, List<model.Attendance>> gymAttendance={};
  List<DateTime> dateList = [];
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


  punchAttendance()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    attendance = model.Attendance()
      ..dateTime = DateTime.now()
      ..timestamp = DateTime.now().millisecondsSinceEpoch
      ..branchId = "70133aG5XJxyP1LSWmIp"
      ..branchName = "Ashok Nagar"
      ..uid = sp.getString('uid')
      ..userName = sp.getString('name')
      ..punchedBy = sp.getString('');

    final box = Boxes.getAttendance();
    box.add(attendance);

  }

  getAttendanceList(){
   final attendance = Hive.box('attendance');
   for(int i=0;i<attendance.length;i++){
     model.Attendance attend = attendance.get(i) as model.Attendance;
     dateList.add(attend.dateTime);
     gymAttendance[attend.dateTime].add(attend);
   }
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
  Future<void> scanQR(context) async {

    String barcodeScanRes;
    barcodeScanRes = "{\"area\":\"Ashok Nagar\",\"id\":\"70133aG5XJxyP1LSWmIp\"}";
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.QR);
    //   print(barcodeScanRes);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    //   showToast(barcodeScanRes,context: context,position: StyledToastPosition.bottom);
    //
    // }
    //
    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.


    scanBarcode = barcodeScanRes;

  }





}