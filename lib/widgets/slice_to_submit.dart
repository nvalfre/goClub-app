import 'dart:math';

import 'package:flutter/material.dart';

class SlideToSubmitWidget extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function onSubmit;

  const SlideToSubmitWidget({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.color,
    @required this.onSubmit}) : super(key: key);

  @override
  _SlideToSubmitWidgetState createState() => _SlideToSubmitWidgetState();
}

class _SlideToSubmitWidgetState extends State<SlideToSubmitWidget>
    with SingleTickerProviderStateMixin {
  double slidePercent = 0.0;
  double widgetWidth = 0;
  bool dragging = false;
  bool loading = false;
  bool success = false;
  double dragStartAt = 0;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _controller.addListener(() {
      setState(() {
        slidePercent = _controller.value;
      });
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          dragging = false;
          widgetWidth = 0;
          dragStartAt = 0;
          slidePercent = 0;
        });
      }
    });
  }

  _dragStart(DragStartDetails details) {
    setState(() {
      dragging = true;
      dragStartAt = details.globalPosition.dx;
      widgetWidth = context.size.width;
    });
  }

  _dragUpdate(DragUpdateDetails details) {
    if (dragging) {
      var maxDragDistance = widgetWidth - 80.0;

      var distance = min(
          maxDragDistance, details.globalPosition.dx - dragStartAt);

      if (distance > 0) {
        setState(() {
          slidePercent = distance / widgetWidth;
        });
      }
    }
  }

  _dragEnd(DragEndDetails details) {
    setState(() {
      if (widgetWidth * (1.0 - slidePercent) == 80) {
        widget.onSubmit(_onFinish, _onError);

        loading = true;
        _controller.reverse(from: slidePercent);
      } else {
        _controller.reverse(from: slidePercent);
      }
    });
  }

  _onFinish() {
    setState(() {
      success = true;
    });
  }

  _onError() {
    setState(() {
      dragging = false;
      loading = false;
      slidePercent = 0;
      widgetWidth = 0;
    });
  }

  Widget _normal() {
    return Container(
      height: 80.0,
      width: dragging ? widgetWidth * (1.0 - slidePercent) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: widget.color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 10),
          GestureDetector(
            onHorizontalDragStart: _dragStart,
            onHorizontalDragUpdate: _dragUpdate,
            onHorizontalDragEnd: _dragEnd,
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              child: Icon(widget.icon,
                size: 40.0,
                color: widget.color,
              ),
            ),
          ),
          Container(
            width: dragging
                ? (widgetWidth * (1.0 - slidePercent) - 80)
                : null,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 36.0),
              child: Text(widget.text,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _loading() {
    return Container(
      height: 80.0,
      width: 80.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: widget.color,

      ),
      child: AnimatedCrossFade(
        firstChild: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
        secondChild: Center(
          child: Icon(Icons.check,
            size: 30,
            color: Colors.white,),
        ),
        crossFadeState: success ? CrossFadeState.showSecond : CrossFadeState
            .showFirst,
        duration: Duration(milliseconds: 750),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: dragging ? widgetWidth * slidePercent : 0,
        ),
        loading ? _loading() : _normal(),
      ],
    );
  }
}