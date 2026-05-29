import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';

/// Extensions on [num] / [int] / [double] for concise Figma-to-device scaling.
extension ResKitNumExtension on num {
  double get w  => ResKit.width(this);
  double get h  => ResKit.height(this);
  double get r  => ResKit.radius(this);
  double get sp => ResKit.sp(this);
  double get dp => ResKit.dp(this);
  double get pt => ResKit.pt(this);
  double get sw => ResKit.sw(toDouble());
  double get sh => ResKit.sh(toDouble());
}

extension ResKitIntExtension on int {
  double get w  => ResKit.width(this);
  double get h  => ResKit.height(this);
  double get r  => ResKit.radius(this);
  double get sp => ResKit.sp(this);
  double get dp => ResKit.dp(this);
  double get pt => ResKit.pt(this);
  double get sw => ResKit.sw(toDouble());
  double get sh => ResKit.sh(toDouble());
}

extension ResKitDoubleExtension on double {
  double get w  => ResKit.width(this);
  double get h  => ResKit.height(this);
  double get r  => ResKit.radius(this);
  double get sp => ResKit.sp(this);
  double get dp => ResKit.dp(this);
  double get pt => ResKit.pt(this);
  double get sw => ResKit.sw(this);
  double get sh => ResKit.sh(this);
}

extension ResKitEdgeInsetsExtension on EdgeInsets {
  EdgeInsets get scaled => EdgeInsets.fromLTRB(
    ResKit.width(left), ResKit.height(top),
    ResKit.width(right), ResKit.height(bottom),
  );
}

extension ResKitSizeExtension on Size {
  Size get scaled => Size(ResKit.width(width), ResKit.height(height));
}
