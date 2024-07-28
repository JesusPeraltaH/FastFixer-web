import 'package:fastfixer_web/theme/colors.dart';
import 'package:fastfixer_web/theme/sizes.dart';

import 'package:flutter/material.dart';

class TOutlinedButtontheme {
  TOutlinedButtontheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        foregroundColor: tSecondaryColor,
        side: const BorderSide(color: tSecondaryColor),
        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        foregroundColor: tWhitecolor,
        side: const BorderSide(color: tWhitecolor),
        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)),
  );
}
