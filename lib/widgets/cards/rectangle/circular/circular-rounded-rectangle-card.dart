import 'package:flutter/material.dart';

import '../rounded-rectangle-card.dart';

class CircularRoundedRectangleCard extends RoundedRectangleCard {
  CircularRoundedRectangleCard(
      {@required double radius,
      @required Color color,
      @required Widget child,
      Key key})
      : super(_getBorderRadiusGeometry(radius), color, child, key: key);

  static BorderRadiusGeometry _getBorderRadiusGeometry(double radius) {
    return BorderRadius.circular(radius);
  }
}
