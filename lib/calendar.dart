import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paldes/utils/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'User_module/riverpod/attendance.dart';
import 'User_module/riverpod/auth.dart';
import 'modal/Attendance.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Calender extends HookWidget {


  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);
    final attend = useProvider(attendanceProvider);
    return   Padding(
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar<Attendance>(
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
        calendarFormat: attend.calendarFormat,
        onFormatChanged: (format){
          attend.formatChange(format);
        },
        rowHeight: 0.05.sh,
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontSize: 14.sp
          )
        ),
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
          selectedBuilder: (context, day,date) =>
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),

                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),


                  ),
                  width: MediaQuery.of(context).size.width*0.45,
                  height:  MediaQuery.of(context).size.width*0.12,
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: TextStyle().copyWith(
                        color: attend.dateExist(day)
                            ?
                        ATTENDANCE_COLOR
                            :
                        Theme.of(context).primaryColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),

        ),
      ),
    );
  }
}
