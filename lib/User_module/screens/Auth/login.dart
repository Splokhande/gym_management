import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:paldes/API/firebaseApi.dart';
import 'package:paldes/Widgets/buttons.dart';
import 'package:paldes/Widgets/containers.dart';
import 'package:paldes/Widgets/image.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/Widgets/textfield.dart';
import 'package:paldes/modal/User.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/utils/colors.dart';
import 'package:paldes/utils/text.dart';


class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key key}) : super(key: key);

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {

  FocusNode  fc1 ;
  FocusNode  fc2;
  FocusNode  fc3;
  FocusNode  fc4 ;
  FocusNode  fc5 ;
  FocusNode  fc6 ;
  FirebaseDb api = FirebaseDb();
  UserDetails userDetails;


  @override
  void initState() {
    fc1 = FocusNode();
    fc2 = FocusNode();
    fc3 = FocusNode();
    fc4 = FocusNode();
    fc5 = FocusNode();
    fc6 = FocusNode();
    userDetails = UserDetails();
  }



  @override
  Widget build(BuildContext context) {

    // final auth = useProvider(authProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (_,watch,widget){
          var auth = watch(authProvider);
          return  WillPopScope(
            onWillPop: ()async{
              if(auth.showOtp) {
                auth.hideOtpScreen();
                return false;
              }
              else{
                exit(0);
              }
            },
            child: Container(
              color: PRIMARY_COLOR,
              width: 1.sw,

              // padding: const EdgeInsets.symmetric(horizontal: 50),
              height: 1.sh,
              child: Stack(
                children: [
                  if (auth.showOtp)
                    Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 15,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 0.05.sh,
                              child: WhiteButton(
                                onTap: ()async {
                                  if(auth.otp.text.length <6) {
                                    showToast("Invalid otp",
                                        context: context,
                                        backgroundColor:
                                        Theme.of(context).backgroundColor,
                                        position: StyledToastPosition.bottom,
                                        textStyle: TextStyle(color: PRIMARY_COLOR));

                                  }else{
                                    auth.userDetails.phoneNo = auth.phoneNumber.text;
                                    auth.verifyOtp(context);
                                  }

                                  // if(auth.user !=null) {
                                  //   // Navigator.of(context).pushNamed('/selectBranch');
                                  //   print(auth.user);
                                  //   auth.authentication(context);
                                  // }
                                },
                                text: "CONTINUE",
                              ),
                            ),
                          ],
                        )),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Hero(
                        tag: 'logo',
                        child: Logo(
                          width: 0.2.sw,
                        )),
                  ),
                  if (!auth.showOtp)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField1(
                              controller: auth.phoneNumber,
                              maxLength: 10,
                              inputType: TextInputType.phone,
                              hint: "Enter Your Mobile Number",
                              label: "",
                              icon: 'assets/gymui/book gray.png',
                            ),
                            SizedBox(
                              height: 0.1.sh,
                            ),
                            WhiteButton(
                              text: "CONTINUE",
                              onTap: () async {
                                if(auth.phoneNumber.text == "") {
                                  showToast("Enter Phone number.",
                                      context: context,
                                      backgroundColor:
                                      Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.center,
                                      textStyle: TextStyle(color: PRIMARY_COLOR));
                                }
                                else if(auth.phoneNumber.text.length < 10) {
                                  showToast("Enter Phone number.",
                                      context: context,
                                      backgroundColor:
                                      Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.center,
                                      textStyle: TextStyle(color: PRIMARY_COLOR)
                                  );
                                }
                                else
                                {
                                  await auth.phoneVerify(context: context);
                                  auth.showOtpScreen();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  if (auth.showOtp)
                    Positioned(
                      top: 50,
                      left: 5,
                      right: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PText(
                                  text: "Enter Verification code",
                                  color: Theme.of(context).backgroundColor,
                                ),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                PText(
                                  text: "Please enter OTP sent to mobile number",
                                  isMd: false,
                                  color: Theme.of(context).backgroundColor,
                                ),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                PText(
                                  text: "${auth.phoneNumber.text}",
                                  isMd: false,
                                  color: Theme.of(context).backgroundColor,
                                ),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PinField(
                                      onChanged: (value) {
                                        if (value.length > 0) {
                                          auth.updatePin();
                                          fc2.requestFocus();
                                        }
                                      },
                                      text: auth.pin1.text,
                                      controller: auth.pin1,
                                      focusNode: fc1,
                                      maxLength: 1,
                                      inputType: TextInputType.numberWithOptions(
                                          signed: false, decimal: false),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    PinField(
                                      onChanged: (value) {
                                        if (value.length > 0) fc3.requestFocus();
                                      },
                                      controller: auth.pin2,
                                      text: auth.pin2.text,
                                      focusNode: fc2,
                                      maxLength: 1,
                                      inputType: TextInputType.numberWithOptions(
                                          signed: false, decimal: false),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    PinField(
                                      onChanged: (value) {
                                        if (value.length > 0) fc4.requestFocus();
                                      },
                                      controller: auth.pin3,
                                      text: auth.pin3.text,
                                      focusNode: fc3,
                                      maxLength: 1,
                                      inputType: TextInputType.numberWithOptions(
                                          signed: false, decimal: false),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    PinField(
                                      onChanged: (value) {
                                        if (value.length > 0) fc5.requestFocus();
                                      },
                                      controller: auth.pin4,
                                      text: auth.pin4.text,
                                      focusNode: fc4,
                                      maxLength: 1,
                                      inputType: TextInputType.numberWithOptions(
                                          signed: false, decimal: false),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    PinField(
                                      controller: auth.pin5,
                                      text: auth.pin5.text,
                                      focusNode: fc5,
                                      maxLength: 1,
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    PinField(
                                      onChanged: (value) {
                                        // if(value.length >0)
                                        // fc2.requestFocus();
                                      },
                                      controller: auth.pin6,
                                      text: auth.pin6.text,
                                      focusNode: fc6,
                                      maxLength: 1,
                                      inputType: TextInputType.numberWithOptions(
                                          signed: false, decimal: false),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 0.03.sh,
                                ),
                                Container(
                                  width: 0.9.sw,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // PText(
                                      //   text: "00:${auth.time}",
                                      //   color: DECORATION_COLOR,
                                      //   isMd: false,
                                      //   fontSize: smallText,
                                      // ),
                                      SizedBox(
                                        width: 0.1.sw,
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          auth.phoneVerify();
                                          showToast("OTP send",
                                              context: context,
                                              backgroundColor:
                                              Theme.of(context).backgroundColor,
                                              position: StyledToastPosition.center,
                                              textStyle: TextStyle(color: PRIMARY_COLOR));
                                        },
                                        child: PText(
                                          text: "Resend",
                                          color: DECORATION_COLOR,
                                          isMd: false,
                                          fontSize: smallText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            width: 1.sw,
                            child: NumericKeyboard(
                                onKeyboardTap:auth.onKeyboardTap,
                                textColor: Theme.of(context).backgroundColor,
                                rightButtonFn: auth.onKeyboardbackPressed,
                                rightIcon: Icon(Icons.backspace, color: Theme.of(context).backgroundColor,),
                                // leftButtonFn: auth.onKeyboardbackPressed,
                                // leftIcon: Icon(Icons.check, color: Colors.red,),
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }


}
