import 'dart:developer';

import 'package:flutter/material.dart';

class SnackBarProxy {

  final BuildContext _buildContext;

  SnackBarProxy(this._buildContext);

  void showSnackBar({int seconds, String text}) {
    try {
      SnackBar snackBar = SnackBar(
          duration: Duration(seconds: seconds),
          content: Text(text));

      Scaffold.of(_buildContext).showSnackBar(snackBar);
    } catch (e) {
      log("There was an error while tring to show snackbar.");
    }
  }

  void hideCurrentSnackBar(){
    try {
      Scaffold.of(_buildContext).hideCurrentSnackBar();
    } catch (e) {
      log("There was an error while tring to hide snackbar.");
    }
  }
}