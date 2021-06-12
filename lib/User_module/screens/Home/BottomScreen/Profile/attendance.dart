
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
    final pages = useProvider(appPages);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                        text: pages.getFromDate(),
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
                        text: pages.getToDate(),
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.05.sh,),
          TableCalendar<Attendance>(
            focusedDay: DateTime.now(),
            firstDay:  DateFormat.yMMMMd().parse(auth.userDetails.doj)
                .difference(DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day))
                < Duration(days: 90)?  DateFormat.yMMMMd().parse(auth.userDetails.doj) : DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day),
            lastDay: DateTime.now(),
            calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(

                )
            ),
            onDaySelected: (DateTime date, DateTime date2){
              attend.onDaySelected(date);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),

                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: attend.dateExist(day)
                        ?
                    ATTENDANCE_COLOR
                        :
                    Theme.of(context).primaryColor,
                  ),
                  width: MediaQuery.of(context).size.width*0.45,
                  height:  MediaQuery.of(context).size.width*0.12,
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: TextStyle().copyWith(
                        color: attend.dateExist(day)
                            ?
                        TEXT_COLOR
                            :
                        Theme.of(context).backgroundColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),

            ),
          ),

            ListTile(
                  title: Text("Check In${ attend.attendance.checkIn}"),
                  subtitle: Text("CheckOut ${ attend.attendance.checkOut}"),
                ),
          // ListView.builder(
          //   itemCount: attend.myAttendance.length,
          //   itemBuilder: (BuildContext context, int i) {
          //     return ListTile(
          //       title: Text("Check In${ attend.myAttendance[i].checkIn}"),
          //       subtitle: Text("CheckOut ${ attend.myAttendance[i].checkOut}"),
          //     );
          //   },
          //
          //
          // )
        ]
    );
  }
}

