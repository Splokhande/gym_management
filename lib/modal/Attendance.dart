import 'package:hive/hive.dart';
part 'Attendance.g.dart';

@HiveType(typeId: 1)
class Attendance extends HiveObject {

  @HiveField(0)
  DateTime checkIn;

  @HiveField(1)
  int timestamp;
  String branchId;

  @HiveField(2)
  String branchName;
  String uid;

  @HiveField(3)
  String userName;

  @HiveField(4)
  String punchedBy;

  @HiveField(5)
  DateTime checkOut;

}