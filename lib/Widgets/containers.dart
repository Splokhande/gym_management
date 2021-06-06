
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class PinField extends StatelessWidget {
  final Widget widget;
  final TextEditingController controller;
  final String text;
  final TextInputType inputType;
  final int maxLength;
  final FocusNode focusNode;
  final Function onChanged;
  PinField({this.widget,this.text, this.onChanged, this.controller, this.focusNode, this.maxLength, this.inputType});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 0.12.sw,
      height: 0.06.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).backgroundColor,
      ),
      child: Center(child: Text(text)),
    );

  }
}
