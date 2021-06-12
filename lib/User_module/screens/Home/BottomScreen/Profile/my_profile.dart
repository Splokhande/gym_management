
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/User_module/riverpod/page.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/utils/text.dart';

class MyProfileScreen extends HookWidget {

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);
    final pages = useProvider(appPages);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 0.05.sh,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PText(
                  text: auth.userDetails.name,
                  color: Theme.of(context).primaryColor,

                ),
                SizedBox(
                  width: 0.5.sw,
                  child: PText(
                    text:"ID "+ auth.userDetails.uid.substring(0,15),color: Theme.of(context).primaryColor,
                  ),
                ),

              ],
            ),
            Image.asset("assets/gymui/edit profile.png")

          ],
        ),
        SizedBox(height: 0.05.sh,),
        pages.profileRow(title: "Date of joining",value: auth.userDetails.doj,context: context),
        SizedBox(height: 0.02.sh,),
        pages.profileRow(title: "Date Of birth",value: auth.userDetails.dob,context: context),
        SizedBox(height: 0.02.sh,),
        pages.profileRow(title: "Weight",value: auth.userDetails.weight,context: context),
        SizedBox(height: 0.02.sh,),
        pages.profileRow(title: "Height",value: auth.userDetails.height,context: context),
        SizedBox(height: 0.02.sh,),
        pages.profileRow(title: "Mobile No.",value: auth.userDetails.phoneNo,context: context),
        // SizedBox(height: 0.02.sh,),
        // profileRow(title: "Email Id",value: auth.userDetails.emailId,context: context),
        SizedBox(height: 0.02.sh,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment. center,
            children: [
              Expanded(child: PText(text: "Gym Program",color: Theme.of(context).primaryColor,fontSize: smallText,)),
              Container(
                  width: 0.3.sw,
                  height: 0.05.sh,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor,width: 1)
                  ),
                  child: PText(
                    text: auth.userDetails.gymProgram??"",
                    color: Theme.of(context).primaryColor,
                    fontSize: smallText,)
              ),
            ],
          ),
        )

      ],
    );
  }
}

