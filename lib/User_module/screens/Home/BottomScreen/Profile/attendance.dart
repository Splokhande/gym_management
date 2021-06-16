
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paldes/Hive/boxes.dart';
import 'package:paldes/User_module/riverpod/attendance.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/User_module/riverpod/page.dart';
import 'package:paldes/User_module/screens/Home/tabBarScreen/attendance.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/calendar.dart';
import 'package:paldes/modal/Attendance.dart';
import 'package:paldes/utils/colors.dart';
import 'package:paldes/utils/text.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAttendanceScreen extends HookWidget {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);
    final attend = useProvider(attendanceProvider);

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 0.05.sh,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PText(
                    text: auth.userDetails.name,
                    color: Theme.of(context).primaryColor,

                  ),
                  if(auth.userDetails.uid != null)
                  SizedBox(
                    width: 0.5.sw,
                    child: PText(
                      text:"ID "+ auth.userDetails.uid.substring(0,15),color: Theme.of(context).primaryColor,
                    ),
                  ),

                ],
              ),
              Image.asset("assets/gymui/edit profile.png")

            ],
          ),
          SizedBox(height: 0.05.sh,),
          Container(
            width: 0.505.sw,
            height: 0.05.sh,
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 0.25.sw,
                  height: 0.05.sh,
                  color:Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PText(
                        color: Theme.of(context).backgroundColor,
                        text: "From",
                        fontSize: 13.sp,
                      ),
                      PText(
                        color: Theme.of(context).backgroundColor,
                        text: attend.getFromDate(),
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 0.25.sw,
                  height: 0.05.sh,
                  color:Theme.of(context).backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PText(
                        color: Theme.of(context).primaryColor,
                        text: "From",
                        fontSize: 13.sp,
                      ),
                      PText(
                        color: Theme.of(context).primaryColor,
                        text: attend.getToDate(),
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                height: 0.1.sh,
                width: 1.sw,
                child: Calender()),
          ),

          SizedBox(height: 0.05.sh,),
              if(attend.attendance.checkIn != null)
                  ListTile(
                title: Text("Check In Time: ${attend.getFromattedDate(attend.attendance.checkIn)}"),
              ),
        ]
    );
  }
}

