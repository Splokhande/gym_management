

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

