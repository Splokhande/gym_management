import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paldes/Hive/boxes.dart';
import 'package:paldes/User_module/riverpod/attendance.dart';
import 'package:paldes/User_module/riverpod/home.dart';
import 'package:paldes/modal/Attendance.dart';


class QRScanner extends HookWidget {


  @override
  Widget build(BuildContext context) {
    var getBranch = useProvider(attendanceProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MyAttendanceCalender()));

        },
        child:  Icon(Icons.list,color: Theme.of(context).backgroundColor,),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  getBranch.punchAttendance(),
              child: Text('Start QR scan')
          ),
        ],
      ),

    );
  }
}


class MyAttendanceCalender extends StatelessWidget {
  const MyAttendanceCalender({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body
          : ValueListenableBuilder<Box<Attendance>>(
          valueListenable: Boxes.getAttendance().listenable(), builder: (context,box,_){
          final attendance = box.values.toList().cast<Attendance>();
          return ListView.builder(
            itemCount: attendance.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: Text("Check In${attendance[i].checkIn}"),
                subtitle: Text("CheckOut ${attendance[i].checkOut}"),
              );
            },


          );
      }),
    );
  }
}
