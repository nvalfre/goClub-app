import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/user_model.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

bool hasMoreLenghtThan(String s, int lenght) {
  if (s.length > lenght) {
    return true;
  } else {
    return false;
  }
}
GetUserByName(List<UserModel> users ,name) {
  var value;
  for (var user in users) {
    if(user.name == name)
    value = user;
  }
  return value;
}

void showAlert(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informacion incorrect'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}
