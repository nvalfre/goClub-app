import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String logoAsset;
  final double width;
  final double height;

  const LogoWidget({Key key, this.logoAsset, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(logoAsset,
          width: width,
          height: height,
      ),
    );
  }
}
