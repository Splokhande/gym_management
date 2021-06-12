
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/User_module/riverpod/page.dart';


class ProfileScreen extends HookWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);
    final pages = useProvider(appPages);
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            height: 0.8.sh,
            width: 0.35.sw,
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 0.1.sh,

                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                auth.userDetails.profilePhoto
                            )
                        )
                    ),

                  ),
                ),
                SizedBox(
                  height: 0.01.sh,
                ),

                for(int i =0; i< pages.profileDrawer.length;i++)...[
                  pages.rowDrawer(pages.profileDrawer[i],pages.selectedprofileDrawer == i, i),
                ],
                // row("My Profile",false),
                // SizedBox(
                //   height: 0.02.sh,
                // ),
                // row("Attendance",true),
              ],
            ),

          ),
          Container(
              width: 0.65.sw,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: pages.getProfileScreen(context)
          )
        ],
      ),
    );
  }
}

