import 'package:flutter/material.dart';

import '../shaped-card.dart';

class RoundedRectangleCard extends ShapedCard {
  RoundedRectangleCard(
      BorderRadiusGeometry borderRadius, Color color, Widget child,
      {Key key})
      : super(_getShape(borderRadius), color, child, key: key);

  static ShapeBorder _getShape(BorderRadiusGeometry borderRadius) {
    return RoundedRectangleBorder(borderRadius: borderRadius);
  }
}
