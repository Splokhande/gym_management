import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:paldes/API/firebaseApi.dart';
import 'package:paldes/Hive/boxes.dart';
import 'package:paldes/User_module/riverpod/attendance.dart';
import 'package:paldes/Widgets/dialog.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/modal/Attendance.dart';
import 'package:paldes/modal/User.dart';
import 'package:paldes/utils/text.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));

class AuthProvider extends ChangeNotifier {
  UserCredential user;
  ProviderReference ref;
  int currentScreen = 0;
  File image;
  final picker = ImagePicker();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  TextEditingController pin5 = TextEditingController();
  TextEditingController pin6 = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController userWeight = TextEditingController(text: "");
  TextEditingController userName = TextEditingController(text: "");
  String weightType = "Kg";
  String heightType = "cm";
  TextEditingController userHeight = TextEditingController(text: "");
  UserDetails userDetails = UserDetails();
  PhoneAuthCredential credential;
  String status = "";
  String verId = "";
  FirebaseDb api = FirebaseDb();
  CustomWidget widget = CustomWidget() ;

  bool showOtp = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  // int time = 59;
  var oneSec = const Duration(seconds: 1);
  DateFormat format = DateFormat.yMMMMd();

  AuthProvider(this.ref);

  resetValue(){
    phoneNumber.clear();
    otp.clear();
    pin1.clear();
    pin2.clear();
    pin3.clear();
    pin4.clear();
    pin5.clear();
    pin6.clear();
    userWeight.clear();
    userHeight.clear();
    showOtp = false;
    verId = "";
    currentScreen =0;
  }

   onKeyboardTap(val) {
     if(val.length<6)
     otp.text = otp.text + val;
     if(otp.text.length ==1 && pin1.text == "")
     pin1.text = otp.text[0];
     if(otp.text.length ==2 &&  pin2.text == "")
     pin2.text = otp.text[1];
     if(otp.text.length ==3  &&  pin3.text == "")
     pin3.text = otp.text[2];
     if(otp.text.length ==4 &&  pin4.text == "")
     pin4.text = otp.text[3];
     if(otp.text.length == 5 &&  pin5.text == "")
     pin5.text = otp.text[4];
     if(otp.text.length == 6 &&  pin6.text == "")
     pin6.text = otp.text[5];
     notifyListeners();
   }

   onKeyboardbackPressed() {
     otp.text = otp.text.substring(0, otp.text.length-1);
     if(otp.text.length ==0 && pin1.text != "")
       pin1.text = "";
     if(otp.text.length ==1 &&  pin2.text != "")
       pin2.text = "";
     if(otp.text.length ==2  &&  pin3.text != "")
       pin3.text = "";
     if(otp.text.length ==3 &&  pin4.text != "")
       pin4.text = "";
     if(otp.text.length == 4 &&  pin5.text != "")
       pin5.text = "";
     if(otp.text.length == 5 &&  pin6.text != "")
       pin6.text = "";
     notifyListeners();
   }

   populateUserDetails ()async{
     userDetails = await userDetails.fromSharedPrefernces();
  return userDetails;
   }

  // showTimer() {
  //   Timer.periodic(oneSec, (Timer timer) {
  //     if (time == 0) {
  //       timer.cancel();
  //     } else {
  //       --time;
  //       notifyListeners();
  //     }
  //   });
  // }

  List<String> regScreenTitle = [
    "Date of Birth",
    "Your Gender",
    "Your Weight",
    "Your Height",
    "Date Of Joining",
    "Profile photo"
  ];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    notifyListeners();
  }

  getPoundsFromKG(){
    userWeight.text = (double.parse(userWeight.text) * 2.20462).roundToDouble().toString();
  }

  getKGFromPounds(){
    userWeight.text = (double.parse(userWeight.text) / 2.20462).roundToDouble().toString();
  }

  getCMFromFeet(){
    userHeight.text = (double.parse(userHeight.text) * 30.48).roundToDouble().toString();
  }

  getFeetFromCM(){
    userHeight.text = (double.parse(userHeight.text) / 30.48).roundToDouble().toString();
  }

  setGender(String val){
    userDetails.gender = val;
    notifyListeners();
  }

  setWeight(weightType){
      if(weightType == "Kg")
        {
          if(userWeight.text !=""){
            getKGFromPounds();
          }
          weightType = "kg";
          userDetails.weight = "${userWeight.text} $weightType";
        }
      else{

      }
    notifyListeners();
  }

  setHeight(weightType){
      if(weightType == "Kg")
        {
          if(userWeight.text !=""){
            getKGFromPounds();
          }
          weightType = "kg";
          userDetails.weight = "${userWeight.text} $weightType";
        }
      else{

      }
    notifyListeners();
  }

  screen(context) {

    // if(currentScreen == -1){
    //   Navigator.pushNamedAndRemoveUntil(context, '/selectBranch', (route) => false);
    // }
  print("currentScreen $currentScreen");
    switch (currentScreen) {
      case 0:
        return CupertinoTheme(
          data: CupertinoThemeData(
            primaryColor: Theme.of(context).backgroundColor,
          ),
          child: CupertinoDatePicker(
            // backgroundColor: Theme.of(context).primaryColor,
            maximumDate: DateTime(
              DateTime.now().year - 15,
            ),
            minimumDate: DateTime(
              DateTime.now().year - 60,
            ),

            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime(
              DateTime.now().year - 25,
            ),
            onDateTimeChanged: (date) {
              userDetails.dob = formatDate(date);
              userDetails.dobStamp = toTimeStamp(date).toString();
              print(userDetails.dobStamp);
              print(fromTimeStamp(userDetails.dobStamp));
              notifyListeners();
            },
          ),
        );
        break;

      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
                onTap: () {
                  userDetails.gender = "Male";
                  notifyListeners();
                },
                child: PText(
                  text: "Male",
                  color: Theme.of(context).backgroundColor,
                  fontWeight: userDetails.gender == "Male"
                      ? FontWeight.bold
                      : FontWeight.normal,
                )),
            SizedBox(
              width: 15,
            ),
            Container(
              color: Theme.of(context).backgroundColor,
              height: 0.05.sh,
              width: 3,
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
                onTap: () {
                  userDetails.gender = "Female";
                  notifyListeners();
                },
                child: PText(
                  text: "Female",
                  color: Theme.of(context).backgroundColor,
                  fontWeight: userDetails.gender == "Female"
                      ? FontWeight.bold
                      : FontWeight.normal,
                )),
          ],
        );
        break;

      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () {
                      if(userWeight.text !=""){
                        getKGFromPounds();
                      }
                      weightType = "kg";
                      userDetails.weight = "${userWeight.text} $weightType";
                      notifyListeners();
                    },
                    child: PText(
                      text: "Kilograms",
                      color: Theme.of(context).backgroundColor,
                      fontWeight: weightType == "kg"
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
                SizedBox(
                  width: 15,
                ),
                Container(
                  color: Theme.of(context).backgroundColor,
                  height: 0.05.sh,
                  width: 3,
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      if(userWeight.text !=""){
                        getPoundsFromKG();
                      }
                      weightType = "lbs";
                      userDetails.weight = "${userWeight.text} $weightType";

                      notifyListeners();
                    },
                    child: PText(
                      text: "Pounds",
                      color: Theme.of(context).backgroundColor,
                      fontWeight: weightType == "lbs"
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 0.2.sw,
                    child: TextFormField(
                      controller: userWeight,
                      onChanged: (value){
                        userDetails.weight = "$value $weightType";
                        print(userDetails.weight);
                        notifyListeners();
                      },
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor
                      ),
                      cursorColor: Theme.of(context).backgroundColor,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: "$weightType",
                        suffixStyle: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 12.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: -5),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor),
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor),
                        ),
                        enabledBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor),
                        ),
                        errorBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red
                          ),
                        ),
                      ),
                    ),
                  ),

                ])
          ],
        );
        break;

      case 3:
        return  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () {
                      heightType = "cm";
                      if(userHeight.text != ""){
                        getCMFromFeet();
                      }
                      userDetails.height = "${userHeight.text} $heightType";
                      notifyListeners();
                    },
                    child: PText(
                      text: "Centimeters",
                      color: Theme.of(context).backgroundColor,
                      fontWeight: heightType == "cm"
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
                SizedBox(
                  width: 15,
                ),
                Container(
                  color: Theme.of(context).backgroundColor,
                  height: 0.05.sh,
                  width: 3,
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      heightType = "ft";
                      if(userHeight.text != ""){
                          getFeetFromCM();
                      }
                      userDetails.height = "${userHeight.text} $heightType";
                      notifyListeners();
                    },
                    child: PText(
                      text: "Feet",
                      color: Theme.of(context).backgroundColor,
                      fontWeight: heightType == "ft"
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 0.2.sw,
                    child: TextFormField(
                      controller: userHeight,
                      onChanged: (value){
                        userDetails.height = "$value $heightType";
                        print(userDetails.height);
                        notifyListeners();
                        notifyListeners();
                      },
                      cursorColor: Theme.of(context).backgroundColor,
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: "$heightType",
                        suffixStyle: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 12.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: -5),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor),
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor),
                        ),
                        enabledBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor),
                        ),
                        errorBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red
                          ),
                        ),
                      ),
                    ),
                  ),

                ])
          ],
        );

        break;

      case 4:
        return CupertinoTheme(
          data: CupertinoThemeData(
            primaryColor: Theme.of(context).backgroundColor,
          ),
          child: CupertinoDatePicker(
            // backgroundColor: Theme.of(context).primaryColor,
            maximumDate: DateTime.now(),
            minimumDate: DateTime(
              DateTime.now().year - 40,
            ),

            mode: CupertinoDatePickerMode.date,
            initialDateTime :  DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-1, ),
            onDateTimeChanged: (date) {
              userDetails.doj = formatDate(date);
              notifyListeners();
            },
          ),
        );
        break;

      case 5:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(image != null)
              Expanded(
                child: Container(
                  width: 0.5.sw,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Theme.of(context).backgroundColor),
                    image: DecorationImage(
                      image: new FileImage(image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            if(image == null)
            GestureDetector(
              onTap: ()=>getImage(),
              child:
              Container(
                width: 0.4.sw,
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).backgroundColor)
                ),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Add your \nProfile Photo",
                      style: TextStyle(
                          fontFamily: 'Futura Bk BT',
                          color: Theme.of(context).backgroundColor,
                          fontSize: mediumText

                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 0.04.sh,
                    ),

                    Icon(Icons.add,size: 0.08.sh,color: Theme.of(context).backgroundColor,)
                  ],
                ),
              ),
            ),
            SizedBox(
              height:0.05.sh,
            ),
            SizedBox(
              width: 0.8.sw,
              child: TextFormField(
                controller: userName,
                onChanged: (value){
                  userDetails.name = value;
                  notifyListeners();
                },
                style: TextStyle(
                    color: Theme.of(context).backgroundColor
                ),
                cursorColor: Theme.of(context).backgroundColor,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Full name",
                  hintStyle: TextStyle(
                    color: Theme.of(context).backgroundColor,
                    fontSize: normalText,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: -5),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).backgroundColor),
                  ),
                  focusedBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).backgroundColor),
                  ),
                  enabledBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).backgroundColor),
                  ),
                  errorBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
        break;

      // default:
      //   return SelectBranch();
      //   break;
    }
  }

  authentication(context)async{

    if (user.additionalUserInfo.isNewUser) {
      Navigator.pushNamedAndRemoveUntil(context, '/selectBranch', (route) => false);
    }
    else
    {
      DocumentSnapshot doc = await api.login(auth.currentUser.uid);
      print(doc.get("name"));
      userDetails = await userDetails.fromMap(doc);
      userDetails.toSharedPreferences(userDetails);
      userDetails = await userDetails.fromSharedPrefernces();
      print(userDetails);
      if( userDetails.name == "")
      {

        // userDetails = await userDetails.fromMap(await api.login(user.user.uid));
        Navigator.pushNamedAndRemoveUntil(context, '/selectBranch', (route) => false);
      }else{
        await ref.watch(attendanceProvider).populateAttendance(auth.currentUser.uid);

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }

    }
  }

  nextScreen() {
    currentScreen++;
    notifyListeners();
  }

  previousScreen() {
    currentScreen--;
    notifyListeners();
  }

  formatDate(DateTime date) {
    return format.format(date);
  }

  parseDate(String date) {
    return format.parse(date);
  }

  toTimeStamp(date) {
    return (Timestamp.fromDate(date).millisecondsSinceEpoch);
  }

  fromTimeStamp(String timestamp) {
    return formatDate(Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp)).toDate());
  }

  updatePin() {
    otp.text =
        pin1.text + pin2.text + pin3.text + pin4.text + pin5.text + pin6.text;
    notifyListeners();
  }

  showOtpScreen() {
    showOtp = true;
    // showTimer();
    notifyListeners();
  }

  hideOtpScreen() {
    showOtp = false;
    notifyListeners();
  }

   verificationCompleted (AuthCredential authCredential,context) {
      if(authCredential != null)
      auth.signInWithCredential(authCredential).then((value) {
        user = value;

        if (value.user != null) {
          // setState(() {
          status = 'Authentication successful';
          authentication(context);
          // });
          // onAuthenticationSuccessful();

        } else {
          // setState(() {
          status = 'Invalid code/invalid authentication';
          // });
        }
      }).catchError((error) {
        // setState(() {
        print('Something has gone wrong, please try later');
        print(error.code);

        showToast(error.message,context: context,position: StyledToastPosition.bottom);
        // });
      });

  }

  verificationFailed(FirebaseAuthException authException) {
    // setState(() {
    status = '${authException.message}';

    print("Error message: " + status);
    if (authException.message.contains('not authorized'))
      status = 'Something has gone wrong, please try later';
    else if (authException.message.contains('Network'))
      status = 'Please check your internet connection and try again';
    else
      status = 'Something has gone wrong, please try later';
  }

  codeSent(String verificationId, [int forceResendingToken]) async {
    verId = verificationId;
    // setState(() {
    print('Code sent to ${phoneNumber.text}');
    status = "\nEnter the code " + otp.text;
    notifyListeners();
    // });
  }

  autoRetrieve(String verificationId)   {
    // this.actualCode = verificationId;
    // setState(() {
    status = "\nAuto retrieval time out";
    // });
  }
  phoneVerify({authCredential, context}) async {
    await auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneNumber.text}",
        verificationCompleted:verificationCompleted(authCredential,context),
        verificationFailed:verificationFailed ,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  verifyOtp(context) {
    updatePin();
    print(otp.text);
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: otp.text);


    // auth.signInWithPhoneNumber(phoneNumber.text).then((value) async {
    //   await value.confirm(verId).then((value) async {
    //     authentication(context);
    //   });
    // });
    verificationCompleted (phoneAuthCredential, context);
    
  }

  registerUser(context) async {
    userDetails.profilePhoto = await uploadPhoto(context);
    if(userDetails.phoneNo == "") {
      print(auth.currentUser.phoneNumber);
      userDetails.phoneNo = auth.currentUser.phoneNumber;
    }
    userDetails.uid = auth.currentUser.uid;
    var data =                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    userDetails.toMap(userDetails);
    api.register(auth.currentUser.uid, userDetails.toMap(userDetails));
    print(data);

  }



  uploadPhoto(context) async{
   widget.showDialog(message: "Please wait your file is being uploaded",context: context);

    FirebaseStorage storage =   FirebaseStorage.instance;

    TaskSnapshot task = await storage.ref('user/profile/${auth.currentUser.uid}')
        .putFile(image).then((value) async{
       double transfer = ((value.bytesTransferred/value.totalBytes)*100).roundToDouble();
           widget.updateDialog("Please wait your file is being uploaded \n $transfer");
          if(transfer >= 100){
            widget.closeDialog();
          }
          return value;
    });
    // String  transfer = ((task.bytesTransferred/task.totalBytes)*100).roundToDouble();
    return await task.ref.getDownloadURL();

  }

   onWeightChange(value) {
     userDetails.weight = "$value $weightType";
     notifyListeners();
   }



}