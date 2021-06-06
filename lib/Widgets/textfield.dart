import 'package:flutter/material.dart';
import 'package:paldes/utils/colors.dart';

class   TextField1 extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String icon;
  final String label;
  final Function validator;
  final TextInputType inputType;
  final int maxLength;
  final FocusNode focusNode;
  final Function onChanged;
  TextField1({
    this.controller,
    this.hint,
    this.validator,
    this.label,
    this.icon,
    this.inputType,
    this.maxLength,
    this.focusNode,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(
        color: Theme.of(context).backgroundColor
      ),
        keyboardType: inputType ?? TextInputType.name,
        maxLength: maxLength,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          fillColor: PRIMARY_COLOR,
          counterText: "",
          hintStyle: TextStyle(color:HINT_COLOR),
          prefixIcon: icon == null?null:Image.asset(icon,height:10,fit: BoxFit.scaleDown,),
          hintText: hint,
            // labelStyle: TextStyle(color:HINT_COLOR),
            // labelText: label == ""? hint:label,
            border: UnderlineInputBorder(
                borderSide: BorderSide(

                    color: Colors.black, )
            ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(

                  color: Theme.of(context).backgroundColor)
          ),
           focusedBorder: UnderlineInputBorder(
               borderSide: BorderSide(
                 color:Theme.of(context).backgroundColor)
           ),
          disabledBorder:UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).backgroundColor)
          ),
        )
    );
  }
}
