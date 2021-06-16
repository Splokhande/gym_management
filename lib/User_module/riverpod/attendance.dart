

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:paldes/API/firebaseApi.dart';
import 'package:paldes/Hive/boxes.dart';
import 'package:paldes/User_module/riverpod/home.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/modal/Attendance.dart' as model;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'auth.dart';

var attendanceProvider = ChangeNotifierProvider<AttendanceProvider>((ref)=>AttendanceProvider(ref));

class AttendanceProvider extends ChangeNotifier{


  model.Attendance attendance = model.Attendance();
  List<model.Attendance> myAttendance = [];
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  ProviderReference ref;
  String branchId= "";
  String branchName= "";
  GymBranch selectedBranch = GymBranch();
  List<GymBranch> branchList = [];
  String scanBarcode = 'Unknown';
  Map<DateTime, List<model.Attendance>> gymAttendance={};
  List<DateTime> dateList = [];
  Box<model.Attendance> box;
  DateTime selectedDate = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;



  AttendanceProvider(this.ref){
    getBranch();
    getAttendanceList(DateTime.now());
  }

  String getFromattedDate(date){
    return  DateFormat("HH:mm").format(date);
  }

  bool dateExist(day){
    return myAttendance.where((element) =>
    DateFormat("dd MM yyyy").format(element.checkIn) ==
        DateFormat("dd MM yyyy").format(day)).length >0;
  }

  getBranch()async{
    QuerySnapshot doc =  await FirebaseFirestore.instance.collection("branches").get();
    for(int i=0; i<doc.docs.length; i++){
      branchList.add(GymBranch.fromMap(doc.docs[i].data()));
    }
    notifyListeners();
  }

  onDaySelected(date){
    myAttendance.clear();
    box = Boxes.getAttendance();
    myAttendance = box.values.toList().cast<model.Attendance>();
    // myAttendance = Boxes.getAttendance() as List<model.Attendance>;
    selectedDate = DateFormat.yMMMMd().parse(DateFormat.yMMMMd().format(date));
    // print(selectedDate);
    for(int i=0; i<myAttendance.length;i++){
      // print(DateFormat.yMMMMd().parse(DateFormat.yMMMMd().format(myAttendance[i].checkIn)));
      if(DateFormat.yMMMMd().parse(DateFormat.yMMMMd().format(myAttendance[i].checkIn)) == selectedDate)
      attendance = myAttendance[i];
    }
   notifyListeners();
  }


  String getToDate(){
    DateTime date = DateTime.now();
    DateFormat format = DateFormat('dd MMMM yyyy');
    return (format.format(date)).toString();
  }

  String getFromDate(){
    DateFormat format = DateFormat('dd MMMM yyyy');
    var auth = ref.watch(authProvider);
    int duration =  DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day)
        .difference(DateFormat.yMMMMd().parse(auth.userDetails.doj)).inDays       ;
    // print(duration);
    // print(  DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day)
    //     .difference(DateFormat.yMMMMd().parse(auth.userDetails.doj)).inDays
    //     < 90 );
    DateTime date =   DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day)
        .difference(DateFormat.yMMMMd().parse(auth.userDetails.doj)).inDays < 90?  DateFormat.yMMMMd().parse(auth.userDetails.doj) : DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day);


    // DateTime date = DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day);

    return (format.format(date)).toString();
  }

  punchAttendance()async{
   await getAttendanceList(DateTime.now());
    if(myAttendance.where(
            (element) => DateFormat.yMMMd().format(element.checkIn)
                == DateFormat.yMMMd().format(DateTime.now())).length >0 )
      print("Already marked");
else{
      String id = firebase.collection("Attendance")
          .doc().id;
      SharedPreferences sp = await SharedPreferences.getInstance();
      attendance = model.Attendance()
        ..checkIn = DateTime.now()
        ..timestamp = DateTime.now().millisecondsSinceEpoch
        ..branchId = "70133aG5XJxyP1LSWmIp"
        ..branchName = "Ashok Nagar"
        ..uid = sp.getString('uid')
        ..userName = sp.getString('name')
      // ..checkOut = sp.getString('')
        ..punchedBy = sp.getString('');
      var data = {
        "checkIn" : DateTime.now(),
        "timestamp" : DateTime.now().millisecondsSinceEpoch,
        "branchId" : "70133aG5XJxyP1LSWmIp",
        "branchName" : "Ashok Nagar",
        "uid" : sp.getString('uid'),
        "userName" : sp.getString('name'),
        "punchedBy" : sp.getString('')
      };
      box = Boxes.getAttendance();
      box.add(attendance);
      FirebaseDb api = FirebaseDb();
      await api.markAttendance(data, id);
      print("Attendance MArked");
    }

  }

  getAttendanceList(date){
    box = Boxes.getAttendance();
    final attendance = box.values.toList().cast<model.Attendance>();
    // final attendance = Hive.box('attendance');
    for(int i=0;i<attendance.length;i++){

      model.Attendance attend = attendance[i];
      if( DateFormat.yMMMMd().format(attend.checkIn) ==  DateFormat.yMMMMd().format(DateTime.now())) {
        dateList.add(attend.checkIn);
        // gymAttendance[attend.dateTime].add(attend);
        myAttendance.add(attend);
      }
    }
    return myAttendance;
  }

  clearAttendance()async{
    await box.delete('attendance');
    print(box.length);
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
  Future<void> scanQR(context) async {

    String barcodeScanRes;
    barcodeScanRes = "{\"area\":\"Ashok Nagar\",\"id\":\"70133aG5XJxyP1LSWmIp\"}";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      showToast(barcodeScanRes,context: context,position: StyledToastPosition.bottom);

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.


    scanBarcode = barcodeScanRes;

  }

  populateAttendance(id)async{
    Box<model.Attendance>  box = Boxes.getAttendance();
    int date = DateTime(DateTime.now().year,DateTime.now().month -3, DateTime.now().day).millisecondsSinceEpoch;
      if(box.length==0){
        QuerySnapshot query = await FirebaseFirestore.instance.collection("Attendance")
                                  .where("uid",isEqualTo: id)
                                  .where("timestamp", isGreaterThan: date)
                                  .get();
        for(int i=0; i<query.docs.length; i++){
          attendance = model.Attendance.fromMap(query.docs[i]);
          box.add(attendance);
        }

      }

  }

   formatChange(format) {
    calendarFormat = format;
    notifyListeners();
   }



}