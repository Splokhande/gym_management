
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paldes/Widgets/Loader.dart';
import 'package:paldes/Widgets/buttons.dart';
import 'package:paldes/Widgets/image.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/User_module/riverpod/auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paldes/utils/colors.dart';
import 'package:paldes/utils/text.dart';

class SelectBranch extends StatelessWidget {
  const SelectBranch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final auth = useProvider(authProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 10,
            child:  Hero(
                tag: 'logo',
                child: Logo(width: 0.2.sw,)),
          ),

          Positioned(
            top: 100,
            left: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PText(text: "Our Branches",color: Theme.of(context).backgroundColor,isMd: true,),
                SizedBox(height: 0.01.sh,),

                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PText(
                        fontSize: smallText,
                        text: "Select your nearest location",
                        isMd: false,color: Theme.of(context).backgroundColor,),
                      SizedBox(height: 0.01.sh,),
                      Container(
                        height: 0.5.sh,
                        width: 0.8.sw,
                        child: FutureBuilder(
                            future: FirebaseFirestore.instance.collection("branches").get(),
                            builder: (_,snapshot){
                              if(snapshot.connectionState == ConnectionState.done){
                                if (snapshot.hasData) {
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (_,i){
                                        return GestureDetector(
                                          onTap: (){
                                            context.read(authProvider).userDetails.admissionBranchId = snapshot.data.docs[i]["id"];
                                            context.read(authProvider).userDetails.admissionBranch = snapshot.data.docs[i]["area"];
                                            Navigator.pushNamedAndRemoveUntil(context, '/regScreen', (route) => false);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/gymui/marker.png",
                                                height: 0.04.sh,

                                              ),
                                              SizedBox(width: 0.1.sw,),
                                              PText(text: "${snapshot.data.docs[i]["area"]}",isMd: false,color: Theme.of(context).backgroundColor,fontSize: 25.sp,)
                                            ],
                                          ),
                                        );

                                      },
                                      separatorBuilder: (_,i) => SizedBox(height: 0.03.sh,),
                                      itemCount: snapshot.data.docs.length);
                                }
                                else if(snapshot.hasError){
                                  return Dialogs().showErrorDialogs(context, "selectBranch");
                                }
                                else{
                                  return Loader();
                                }

                              }

                              else{
                                return Loader();
                              }

                            }),
                      ),
                    ],
                  ),
                ),




              ],
            ),
          ),
        ],
      ),
    );
  }



}

class RegScreen extends ConsumerWidget
{
  const RegScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context,watch) {
    final auth = watch(authProvider);
    return WillPopScope(
      onWillPop: ()async{
        if(auth.currentScreen ==0){
          Navigator.pushNamedAndRemoveUntil(context, '/selectBranch', (route) => false);
          return true;
        }else {
          auth.previousScreen();
          return false;
        }

      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [

            Positioned(
              bottom: 20,
              right: 10,
              child:  Hero(
                  tag: 'logo',
                  child: Logo(width: 0.2.sw,)),
            ),




            Positioned(
                top: 100,
                left: 15,
                right: 15,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children:[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            PText(text: "${auth.regScreenTitle[auth.currentScreen]}",color: Theme.of(context).backgroundColor,isMd: true,),

                            Row(
                              children: [
                                if(auth.currentScreen >0)
                                  GestureDetector(
                                      onTap: () => auth.previousScreen(),
                                      child: Image.asset('assets/gymui/back icon-2.png',width: 0.15.sw,)),
                                SizedBox(width: 0.01.sw,),
                                if(auth.currentScreen <5)
                                  GestureDetector(
                                      onTap: () => auth.nextScreen(),
                                      child: Image.asset('assets/gymui/back icon.png',width: 0.15.sw,)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 0.1.sh,),
                      SizedBox(
                        height: 0.3.sh,
                        child: Center (child: auth.screen(context)),
                      ),

                      SizedBox(height: 0.1.sh,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 0.05.sh,
                            child: WhiteButton(
                              onTap: ()async{
                                if(auth.currentScreen == 0 && auth.userDetails.dob == "")
                                  showToast(
                                      "Please select Date of birth",
                                      context:context,backgroundColor: Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.bottom,
                                      textStyle: TextStyle(color: PRIMARY_COLOR)
                                  );

                                else if(auth.currentScreen == 1 && auth.userDetails.gender == "")
                                  showToast(
                                      "Please Select Gender",
                                      context:context,backgroundColor: Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.center,
                                      textStyle: TextStyle(color: PRIMARY_COLOR)
                                  );

                                else if(auth.currentScreen == 2 &&  auth.userDetails.weight.split(" ")[0] == "" )
                                  showToast(
                                      "Please mention current weight",
                                      context:context,backgroundColor: Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.center,
                                      textStyle: TextStyle(color: PRIMARY_COLOR)
                                  );

                                else if(auth.currentScreen == 3 &&  auth.userDetails.height.split(" ")[0] == "")
                                  showToast(
                                      "Please mention current height",
                                      context:context,backgroundColor: Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.center,
                                      textStyle: TextStyle(color: PRIMARY_COLOR)
                                  );

                                else if(auth.currentScreen == 5 && auth.image == null)
                                  showToast(
                                      "Add profile photo",
                                      context:context,backgroundColor: Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.center,
                                      textStyle: TextStyle(color: PRIMARY_COLOR)
                                  );

                                else if(auth.currentScreen == 5 && (auth.userDetails.name == null || auth.userDetails.name == ""))
                                  showToast(
                                      "Enter your name",
                                      context:context,backgroundColor: Theme.of(context).backgroundColor,
                                      position: StyledToastPosition.center,
                                      textStyle: TextStyle(color: PRIMARY_COLOR)
                                  );




                                else if(auth.currentScreen <=4)
                                  auth.nextScreen();
                                else {
                                  await auth.registerUser(context);
                                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                }
                              },
                              text:auth.currentScreen == 5?"REGISTER" : "CONTINUE" ,
                            ),
                          ),
                        ],
                      ),
                    ])
            ),

          ],
        ),
      ),
    );
  }

}


