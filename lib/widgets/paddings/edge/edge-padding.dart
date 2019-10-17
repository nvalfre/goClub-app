import 'package:flutter/material.dart';

class EdgePaddingWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets edgeInsets;

  const EdgePaddingWidget(this.edgeInsets, this.child, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: edgeInsets, child: child);
  }
}