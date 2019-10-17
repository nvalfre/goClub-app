import 'package:flutter/material.dart';

import '../edge-padding.dart';


class OnlyEdgePaddedWidget extends EdgePaddingWidget {
  OnlyEdgePaddedWidget.top({@required Widget child, @required double padding, Key key})
      : super(EdgeInsets.only(top: padding), child, key: key);

  OnlyEdgePaddedWidget.bottom({@required Widget child, @required double padding, Key key})
      : super(EdgeInsets.only(bottom: padding), child, key: key);

  OnlyEdgePaddedWidget.left({@required Widget child, @required double padding, Key key})
      : super(EdgeInsets.only(left: padding), child, key: key);

  OnlyEdgePaddedWidget.right({@required Widget child, @required double padding, Key key})
      : super(EdgeInsets.only(right: padding), child, key: key);
}