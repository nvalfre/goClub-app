import 'package:flutter/material.dart';

import '../rounded-rectangle-raised-button.dart';

class CircularRoundedRectangleRaisedButton
    extends RoundedRectangleRaisedButton {

  CircularRoundedRectangleRaisedButton.text(
      {@required double radius,
      @required onPressed,
      @required Color color,
      @required String text,
      @required TextStyle textStyle,
      Key key})
      : super(
            borderRadius: _getBorderRadiusGeometry(radius),
            onPressed: onPressed,
            color: color,
            child: _getTextWidget(text, textStyle),
            key: key);

  CircularRoundedRectangleRaisedButton.general(
      {@required double radius,
      @required onPressed,
      @required Color color,
      @required Widget child,
      Key key})
      : super(
            borderRadius: _getBorderRadiusGeometry(radius),
            onPressed: onPressed,
            color: color,
            child: child,
            key: key);

  static BorderRadiusGeometry _getBorderRadiusGeometry(double radius) {
    return BorderRadius.circular(radius);
  }

  static Text _getTextWidget(String text, TextStyle textStyle) {
    return Text(text, style: textStyle);
  }
}
