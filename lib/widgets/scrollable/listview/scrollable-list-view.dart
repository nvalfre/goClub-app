import 'package:flutter/material.dart';

class ScrollableListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController _scrollController;

  ScrollableListView({Key key, this.children}):
        _scrollController = ScrollController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(controller: _scrollController, children: children));
  }

  ScrollController get scrollController => _scrollController;


}
