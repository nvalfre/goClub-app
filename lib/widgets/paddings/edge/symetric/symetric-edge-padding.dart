import 'package:flutter/material.dart';

import '../edge-padding.dart';

class SymmetricEdgePaddingWidget extends EdgePaddingWidget {
  SymmetricEdgePaddingWidget.vertical(
      {@required double paddingValue, @required Widget child, Key key})
      : super(EdgeInsets.symmetric(vertical: paddingValue), child, key: key);

  SymmetricEdgePaddingWidget.horizontal(
      {@required double paddingValue, @required Widget child, Key key})
      : super(EdgeInsets.symmetric(horizontal: paddingValue), child, key: key);
}
