import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/widgets/decoration/boxdecoration/asset-box-decoration.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final String asset;

  const BackgroundContainer({Key key, this.asset, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: AssetBoxDecoration.coverAssetDecoration(asset),
        child: Scaffold(body: child, backgroundColor: Colors.transparent));
  }
}
