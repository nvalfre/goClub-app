import 'package:flutter/material.dart';
import '../shaped-raised-button.dart';

class RoundedRectangleRaisedButton extends ShapedRaisedButton {
  RoundedRectangleRaisedButton(
      {@required BorderRadiusGeometry borderRadius,
      @required VoidCallback onPressed,
      @required Color color,
      @required Widget child,
      Key key})
      : super(_getShape(borderRadius), onPressed, color, child, key: key);

  static ShapeBorder _getShape(BorderRadiusGeometry borderRadius) {
    return RoundedRectangleBorder(borderRadius: borderRadius);
  }
}
