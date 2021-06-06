
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paldes/Widgets/text.dart';
import 'package:paldes/utils/colors.dart';


class WhiteButton extends StatelessWidget {

  final bool isMd;
  final fontSize;
  final fontWeight;
  final color;
  final text;
  final onTap;
  WhiteButton({this.fontWeight,this.onTap, this.fontSize, this.color,this.text, this.isMd = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 0.7.sw,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: PText(text:text,
                 isMd :isMd,
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color ?? TEXT_COLOR),
          ),
        ),
      ),
    );
  }
}
