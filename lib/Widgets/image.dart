

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Logo extends StatelessWidget {
  BoxFit fit;
  final double width;
  Logo({this.width, this.fit});
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/Logo.png",width: width ?? 0.7.sw,fit:fit?? BoxFit.fitWidth,);
  }
}
