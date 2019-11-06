import 'package:flutter/material.dart';

import '../custom-text.dart';

class EllipsisCustomText extends CustomText {
  EllipsisCustomText.leftStyle(
      {@required String text,
      @required FontWeight fontWeight,
      @required Color color,
      @required double fontSize,
      Key key})
      : super.style(
            text: text,
            textAlign: TextAlign.left,
            fontWeight: fontWeight,
            color: color,
            fontSize: fontSize,
            textOverflow: TextOverflow.ellipsis,
            key: key);

  EllipsisCustomText.left(
      {@required String text, @required TextStyle textStyle, Key key})
      : super(
            text: text,
            textAlign: TextAlign.left,
            textOverflow: TextOverflow.ellipsis,
            textStyle: textStyle,
            key: key);
}
