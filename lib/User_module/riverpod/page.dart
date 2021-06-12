
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paldes/Admin_module/generate_QR.dart';
import 'package:paldes/User_module/riverpod/attendance.dart';
import 'package:paldes/User_module/screens/Home/BottomScreen/Profile/attendance.dart';
import 'package:paldes/User_module/screens/Home/BottomScreen/Profile/my_profile.dart';
import 'package:paldes/User_module/screens/Home/BottomScreen/Profile/profile_main_screen.dart';
import 'package:paldes/User_module/screens/Home/tabBarScreen/attendance.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/modal/Attendance.dart';
import 'package:paldes/utils/colors.dart';
import 'package:paldes/utils/text.dart';
import 'package:table_calendar/table_calendar.dart';

class NavigationItem {
  final Image icon;
  final String label;

  NavigationItem({this.icon, this.label});
}

var appPages = ChangeNotifierProvider<AppPages>((ref)=>AppPages(ref));


class AppPages extends ChangeNotifier{
  ProviderReference ref;
  int selectedTab = 0;
  int selectedBottomNav = 0;
  int selectedprofileDrawer = 0;
  List<String> topTabs = [
    "Attendance",
    "Supplement",
    "Diet Plan",
    "Trainer"
  ];

  List<String> bottomNav = [
    "Home",
    "Booking",
    "Cart",
    "Profile"
  ];

  List<String> unselectedImage = [
    "assets/gymui/home gray.png",
    "assets/gymui/book gray.png",
    "assets/gymui/cart gray.png",
    "assets/gymui/gymui2/profile gray.png"
  ];

  List<String> selectedImage = [
    "assets/gymui/home black.png",
    "assets/gymui/book black.png",
    "assets/gymui/cart black.png",
    "assets/gymui/gymui2/profile black.png"
  ];


  List<String> profileDrawer = [
    "My Profile",
    "Attendance",
    "Trainers",
    "Notification",
    "Refer & Earn",
    "FAQ",
    "Help Center",
    "Enquiry",
    "Settings",
  ];

  AppPages(this.ref);


  topbar(context){
    switch(selectedTab){
      case 0:

        break;
      case 1:

        break;
      case 2:

        break;
      case 3:

        break;

      default:

        break;
    }
  }

  bottomTabs(tabController , context){
    final auth = ref.watch(authProvider);
    switch(selectedBottomNav){
      case 0:
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 0.05.sh,
                width: 1.sw,
                color: BG_COLOR,
                child: TabBar(
                  controller: tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).primaryColor.withOpacity(0.5),
                  labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor
                  ),
                  isScrollable: true,
                  physics: ScrollPhysics(),
                  tabs: [
                    for(int i=0; i<topTabs.length;i++)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Text(
                            topTabs[i],

                          )

                        // PText(text:page.topTabs[i],
                        // isMd: false,
                        //   color: page.selectedTab == i ? Theme.of(context).primaryColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        //   fontSize: normalText,
                        // ),
                      )
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                    controller: tabController,
                    children: [
                      // GenerateQR(),
                      QRScanner(),
                      for(int i=1; i< topTabs.length; i++)...[
                        Container(
                          child: Center(
                            child: PText(text:topTabs[i], color: TEXT_COLOR,),
                          ),
                        )
                      ]
                    ]),
              ),
            ],
          );
        break;

      case 1:
        return Container(
          child: Center(
            child: Text("Booking"),
          ),
        );
        break;

      case 2:
        return Container(
          child: Center(
            child: Text("Cart"),
          ),
        );
        break;

      case 3:
          return ProfileScreen();
        break;

      default:

        break;
    }
  }

  Widget profileRow({title, value, context}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment. center,
        children: [
          Expanded(child: PText(text: title,color: Theme.of(context).primaryColor,fontSize: smallText,)),
          Expanded(child: PText(text: value,color: Theme.of(context).primaryColor,fontSize: smallText,)),

        ],
      ),
    );
  }

  Widget rowDrawer(text,isSelected, i){
    return GestureDetector(
      onTap: (){
        selectedprofileDrawer = i;
        notifyListeners();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/gymui/profile high.png"),
            SizedBox(width: 0.05.sw,),
            PText(text:text,isWhite: true,fontSize: smallText,opacity: !isSelected?0.75:1,)
          ],
        ),
      ),
    );
  }

   selectPage(int i) {
     selectedBottomNav = i;
     notifyListeners();
   }

   String getFromDate(){
     DateFormat format = DateFormat('dd MMMM yyyy');
      var auth = ref.watch(authProvider);
      int duration =  DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day)
          .difference(DateFormat.yMMMMd().parse(auth.userDetails.doj)).inDays       ;
      print(duration);
     print(  DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day)
         .difference(DateFormat.yMMMMd().parse(auth.userDetails.doj)).inDays
          < 90 );
     DateTime date =   DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day)
         .difference(DateFormat.yMMMMd().parse(auth.userDetails.doj)).inDays < 90?  DateFormat.yMMMMd().parse(auth.userDetails.doj) : DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day);


     // DateTime date = DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day);

    return (format.format(date)).toString();
   }

   String getToDate(){
    DateTime date = DateTime.now();
    DateFormat format = DateFormat('dd MMMM yyyy');
    return (format.format(date)).toString();
   }

  Widget getProfileScreen(context) {
    final auth = ref.watch(authProvider);
    final attend = ref.watch(attendanceProvider);
    attend.myAttendance=  attend.getAttendanceList(DateTime.now());
    switch(selectedprofileDrawer){
      case 0:
        return MyProfileScreen();

      case 1:
        return MyAttendanceScreen();
    }
  }

}