

import 'package:hive/hive.dart';
import 'package:paldes/modal/Attendance.dart';

class Boxes {
  static Box<Attendance> getAttendance()=>
      Hive.box<Attendance>('attendance');
  static Future<int> clearAttendance() async =>await
      Hive.box('attendance').clear();
  static Future closeAttendance() async =>await
      Hive.box('attendance').close();
}