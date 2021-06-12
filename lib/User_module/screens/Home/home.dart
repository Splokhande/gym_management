import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paldes/Widgets/image.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:paldes/User_module/riverpod/page.dart';
import 'package:paldes/User_module/screens/Home/header.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  TabController tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    tabController?.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: BG_COLOR,
        body: Consumer(
          builder: (_,watch,widget){
            var auth = watch(authProvider);
            var page = watch(appPages);
            if(auth.userDetails.name == "" ||auth.userDetails.name == null )
            auth.populateUserDetails();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SafeArea(
                    child: Container(
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
                            auth.resetValue();
                            Navigator.pushNamedAndRemoveUntil(context, "/splash", (route) => false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: Row(
                              children: [
                                IconButton(icon: Icon(Icons.qr_code_scanner,color: Theme.of(context).primaryColor,), onPressed: ()async{

                                }),
                                SizedBox(width: 0.08.sw,),
                                Image.asset("assets/gymui/noun_Bell_-3.png",width: 0.04.sw,),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                 Expanded(child:  page.bottomTabs(tabController,context)),

              ],
            );
          },
        ),
        bottomNavigationBar: Consumer(
          builder: (_,watch,widget){
            var page = watch(appPages);
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 75.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(25.0),
                //   topRight: Radius.circular(25.0),
                // ),
                color: BOTTOM_NAV_BAR,),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    for (int i = 0; i < page.bottomNav.length; i++) ...[
                      GestureDetector(
                        onTap: (){
                          page.selectPage(i);
                        },
                        child: Container(
                          width: 0.16.sw,

                          decoration: BoxDecoration(
                              color: Color(0xffEFEEEE),
                              boxShadow: [
                                if(page.selectedBottomNav == i)
                                  BoxShadow(
                                    color: Color(0xff000000).withAlpha(38),
                                    offset: Offset(0,1),
                                    blurRadius: 15,
                                    // spreadRadius: 10
                                  )
                              ],
                              shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Image.asset(page.selectedBottomNav == i
                                        ? page.selectedImage[i]
                                        : page.unselectedImage[i]),
                                  ),
                                  SizedBox(
                                    height: 0.01.sh,
                                  ),
                                  Expanded(
                                    child: PText(text:page.bottomNav[i],
                                    color: TEXT_COLOR,
                                      isWhite: false,
                                      isMd: false,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ]),
            );
          },
        ),
      ),
    );
  }
}


class HomePage extends ConsumerWidget {
  final int data;

  HomePage({this.data});

  @override
  Widget build(BuildContext context, watch) {
    var page = watch(appPages);
    return SafeArea(
      child: Scaffold(
        backgroundColor: BG_COLOR,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderPage(),
            Container(
              height: 0.1.sh,
              child: TabBar(
                tabs: [
                  for(int i=0; i<page.topTabs.length;i++)
                    Text(page.topTabs[i],style: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),)
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 75.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(25.0),
              //   topRight: Radius.circular(25.0),
              // ),
            color: BOTTOM_NAV_BAR,),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < page.bottomNav.length; i++) ...[
                  GestureDetector(
                    onTap: (){
                     page.selectPage(i);
                    },
                    child: Container(
                      width: 0.16.sw,

                      decoration: BoxDecoration(
                        color: Color(0xffEFEEEE),
                        boxShadow: [
                          if(page.selectedBottomNav == i)
                          BoxShadow(
                            color: Color(0xff000000).withAlpha(38),
                            offset: Offset(0,1),
                            blurRadius: 15,
                            // spreadRadius: 10
                          )
                        ],
                        shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(page.selectedBottomNav == i
                                  ? page.selectedImage[i]
                                  : page.unselectedImage[i]),
                              SizedBox(
                                height: 0.01.sh,
                              ),
                              Text(page.bottomNav[i]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ]),
        ),
      ),
    );
  }
}
