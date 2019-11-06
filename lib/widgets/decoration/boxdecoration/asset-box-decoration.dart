import 'package:flutter/material.dart';

class AssetBoxDecoration {
  static Decoration coverAssetDecoration(String asset) {
    return BoxDecoration(image: _assetDecorationImage(asset, BoxFit.cover));
  }

  static DecorationImage _assetDecorationImage(String asset, BoxFit boxFix) {
    return DecorationImage(
      image: ExactAssetImage(asset),
      fit: boxFix,
    );
  }
}
