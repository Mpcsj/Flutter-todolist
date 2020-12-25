import 'package:flutter/material.dart';

Widget getSimpleActionedSnackbar(
    String message,
    String labelAction,
    Duration duration,
    Function onPressAction){
  return SnackBar(
      content: Text(message),
      action:SnackBarAction(
        label: labelAction,
        onPressed: onPressAction
      ) ,
    duration: duration,
  );
}