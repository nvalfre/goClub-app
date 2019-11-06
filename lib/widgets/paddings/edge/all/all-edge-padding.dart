import 'package:flutter/material.dart';

import '../edge-padding.dart';

class AllEdgePaddedWidget extends EdgePaddingWidget {
  AllEdgePaddedWidget({@required Widget child, @required double padding, Key key})
      : super(EdgeInsets.all(padding), child, key: key);
}