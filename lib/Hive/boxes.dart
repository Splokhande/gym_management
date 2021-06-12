

import 'package:hive/hive.dart';
import 'package:paldes/modal/Attendance.dart';

class Boxes {
  static Box<Attendance> getAttendance()=>
      Hive.box<Attendance>('attendance');
}