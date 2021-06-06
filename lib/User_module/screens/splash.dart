
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paldes/Widgets/image.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/utils/colors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
class SplashScreen extends HookWidget {

  FirebaseAuth _auth= FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // var auth = useProvider(authProvider);
    Timer(Duration(milliseconds: 1500), (){
      if( _auth.currentUser != null){
        // if( auth.userDetails.name != "")
          Navigator.pushNamed(context, '/home');
        // else
        //   Navigator.pushNamed(context, '/selectBranch');
      }else{
        Navigator.pushNamed(context, '/login');
      }
      // Navigator.of(context).push(MaterialPageRoute(builder: (_)=> PhoneNumber()));
    });
    return Container(
      color: PRIMARY_COLOR,
      height: 1.sh,
      width: 1.sw,
      child: Center(
        child: Hero(
          tag: 'logo',
          child: Logo(width: 0.7.sw,),
        ),
      ),
    );
  }
}
