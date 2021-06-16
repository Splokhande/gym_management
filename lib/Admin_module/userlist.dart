import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paldes/Admin_module/Riverpod/User.dart';
import 'package:paldes/User_module/screens/Home/BottomScreen/Home/header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/calendar.dart';


class UserList extends HookWidget {
  @override
  Widget build(BuildContext context) {
  var user = useProvider(userProvider);

    return Scaffold(
      body: Column(
        children: [
          HeaderPage(),

          Expanded(
            child: FutureBuilder(
                future: user.getUserList(),
                builder: (_,snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return ListView.builder(
                        itemCount: user.userDetailList.length,
                        itemBuilder: (_,i){
                      return SizedBox(
                        width: 1.sw,
                        child: ListTile(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Calender()));
                          },
                          leading: Container(
                            height: 0.06.sh,
                            width: 0.15.sw,
                            child: Image.network(user.userDetailList[i].profilePhoto),
                          ),
                          title: PText(text:user.userDetailList[i].name,isWhite: false,),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: PText(text: user.userDetailList[i].phoneNo,isWhite: false,fontSize: 12.sp,)),
                              Expanded(child: PText(text: "Status: ${user.userDetailList[i].status?? ""}",isWhite: false,)),
                            ],
                          ),
                        ),
                      );
                    });
                  }
                  else{
                    return Container(
                      width: 1.sw,
                      height: 1.sh,
                      child: Center(
                          child: CircularProgressIndicator()
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}




