

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CustomWidget {

  ProgressDialog progressDialog ;
  showDialog({context, message}){
    progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: message,
      progressWidget: CircularProgressIndicator(),
      borderRadius: 10,
    );
    progressDialog.show();
  }


  updateDialog(message){
    progressDialog.update(
      progressWidget: CircularProgressIndicator(),
      message: message,
    );
  }

  closeDialog(){
    progressDialog.hide();

  }

}