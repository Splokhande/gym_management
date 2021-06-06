

import 'package:flutter/material.dart';
import 'package:paldes/utils/colors.dart';
import 'package:paldes/utils/text.dart';

class PText extends StatelessWidget {
  final String text;
  final bool isMd;
  final fontName;
  final fontSize;
  final bool isWhite;
  final fontWeight;
  final color;
  final double opacity;
  PText({this.text,this.isWhite, this.opacity, this.fontName,this.fontWeight, this.fontSize, this.color, this.isMd = false  });

  @override
  Widget build(BuildContext context) {
    return Text(text,style:  TextStyle(
        fontFamily: fontName ?? isMd
            ?
        'Futura Md BT'
            :
        'Futura Bk BT',
        fontSize: fontSize ?? normalText,
        fontWeight: fontWeight,
        color: color!= null ?color : isWhite?Theme.of(context).backgroundColor.withOpacity(opacity??1):TEXT_COLOR

    ),);
  }
}
