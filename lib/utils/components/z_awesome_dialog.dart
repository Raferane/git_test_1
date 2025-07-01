import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class ZAwesomeDialog {
  static void show(
    BuildContext context,
    DialogType dialogType,
    String title,
    String body,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: title,
      body: Text(body),
    ).show();
  }
}

class ZAwesomeDialog2 {
  static void show(
    BuildContext context,
    DialogType dialogType,
    String title,
    String body,
    void Function()? btnOkOnPress,
    void Function()? btnCancelOnPress,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: title,
      body: Text(body),
      btnOkOnPress: btnOkOnPress,
      btnCancelOnPress: btnCancelOnPress,
    ).show();
  }
}
