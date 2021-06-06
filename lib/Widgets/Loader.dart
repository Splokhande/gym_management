
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Loader extends StatelessWidget {
  const Loader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 1.sw,
      child: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).backgroundColor),),
      ),
    );
  }
}

class Dialogs{

  showErrorDialogs(context,path){
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return Container(
        height: 0.4.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Something went wrong"),
            SizedBox(height:0.1.sh),
            ElevatedButton(onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context,path , (route) => false);
            },
                child: Center(
              child: Text("Back"),
            )),
          ],
        ),
      );

    },


    );


  }
}