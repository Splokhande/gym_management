import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paldes/Widgets/image.dart';
import 'package:paldes/utils/colors.dart';


class HeaderPage extends HookWidget {
  const HeaderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.1.sh,
      color: BG_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Logo(width: 0.15.sw,),
            GestureDetector(
              onTap: ()async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, "/splash", (route) => false);
              },
              child: Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: Image.asset("assets/gymui/noun_Bell_-3.png",width: 0.04.sw,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
