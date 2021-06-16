import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
part 'User.g.dart';

@HiveType(typeId: 0)
class UserDetails extends HiveObject{

  @HiveField(0)
  String uid;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phoneNo;

  @HiveField(3)
  String admissionBranchId;

  @HiveField(4)
  String admissionBranch;

  @HiveField(5)
  String dob;

  @HiveField(6)
  String dobStamp;

  @HiveField(7)
  String gender;

  @HiveField(8)
  String weight;

  @HiveField(9)
  String height;

  @HiveField(10)
  String doj; // date of joining

  @HiveField(11)
  String profilePhoto;

  @HiveField(12)
  String gymProgram;

  @HiveField(13)
  String status;

  UserDetails({
    this.name,
    this.uid,
    this.phoneNo,
    this.admissionBranch,
    this.admissionBranchId,
    this.dob,
    this.gender,
    this.dobStamp,
    this.weight,
    this.height,
    this.doj,
    this.gymProgram,
    this.profilePhoto,
    this.status
   });

  toSharedPreferences(UserDetails user) async {
    print(user);
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("name", user.name);
    sp.setString("uid", user.uid);
    sp.setString("phoneNo", user.phoneNo);
    sp.setString("admissionBranch", user.admissionBranch);
    sp.setString("admissionBranchId", user.admissionBranchId);
    sp.setString("dob", user.dob);
    sp.setString("dobStamp", user.dobStamp);
    sp.setString("gender", user.gender);
    sp.setString("weight", user.weight);
    sp.setString("height", user.height);
    sp.setString("doj", user.doj);
    sp.setString("profilePhoto", user.profilePhoto);
    sp.setString("gymProgram", user.gymProgram ?? "");
    sp.setString("status", user.status);
  }

  fromSharedPrefernces() async {
    UserDetails user = UserDetails();
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.containsKey("name")) {
      user = UserDetails(
        name: sp.getString("name"),
        uid: sp.getString("uid"),
        admissionBranch: sp.getString("admissionBranch"),
        admissionBranchId: sp.getString("admissionBranchId"),
        dob: sp.getString("dob"),
        dobStamp: sp.getString("dobStamp"),
        doj: sp.getString("doj"),
        gender: sp.getString("gender"),
        height: sp.getString("height"),
        phoneNo: sp.getString("phoneNo"),
        profilePhoto: sp.getString("profilePhoto"),
        weight: sp.getString("weight"),
        gymProgram: sp.getString("gymProgram"),
        status: sp.getString("status")
      );
    }else{
      user = UserDetails(
        name: "",
        admissionBranch: "",
        dob: "",
        dobStamp: "",
        doj: "",
        gender:"",
        height:"",
        phoneNo:"",
        profilePhoto:"",
        weight:"",
        uid: "",
        gymProgram: "",
        admissionBranchId: "",
        status: ""
      );
    }
    return user;
  }

  UserDetails fromMap(DocumentSnapshot data) {
     UserDetails user = UserDetails();

       user = UserDetails(
          name: data["name"] ?? "",
          admissionBranch: data["admissionBranch"] ?? "",
          dob: data["dob"] ?? "",
          dobStamp: data["dobStamp"] ?? "",
          doj: data["doj"] ?? "",
          gender: data["gender"] ?? "",
          height: data["height"] ?? "",
          phoneNo: data["phone"] ?? "",
          profilePhoto: data["profilePhoto"] ?? "",
          weight: data["weight"] ?? "",
          uid: data["uid"] ?? "",
          status: data["status"] ,
          admissionBranchId: data["admissionBranchId"] ?? "",
          gymProgram: data["gymProgram"] ?? "");

    return user;
  }

  toMap(UserDetails details){
    return {
      "name":details.name ?? "",
      "uid":details.uid?? "",
      "phone":details.phoneNo?? "",
      "dob":details.dob?? "",
      "dobStamp":details.dobStamp?? "",
      "doj":details.doj?? "",
      "gender":details.gender?? "",
      "height":details.height?? "",
      "weight":details.weight?? "",
      "profilePhoto":details.profilePhoto?? "",
      "admissionBranch":details.admissionBranch?? "",
      "admissionBranchId":details.admissionBranchId?? "",
      "gymProgram":details.gymProgram?? "",
      "status":details.status?? true,
    };
  }

}
