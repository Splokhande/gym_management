
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paldes/Admin_module/generate_QR.dart';
import 'package:paldes/User_module/screens/Home/tabBarScreen/attendance.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/utils/colors.dart';
import 'package:paldes/utils/text.dart';

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
          return Row(
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

                    for(int i =0; i< profileDrawer.length;i++)...[
                      rowDrawer(profileDrawer[i],selectedprofileDrawer == i, i),
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
                child: Column(
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
                      profileRow(title: "Date of joining",value: auth.userDetails.doj,context: context),
                      SizedBox(height: 0.02.sh,),
                      profileRow(title: "Date Of birth",value: auth.userDetails.dob,context: context),
                      SizedBox(height: 0.02.sh,),
                      profileRow(title: "Weight",value: auth.userDetails.weight,context: context),
                      SizedBox(height: 0.02.sh,),
                      profileRow(title: "Height",value: auth.userDetails.height,context: context),
                      SizedBox(height: 0.02.sh,),
                      profileRow(title: "Mobile No.",value: auth.userDetails.phoneNo,context: context),
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
                ),
              )
            ],
          );
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

}