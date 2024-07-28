import 'package:fastfixer_web/theme/colors.dart';
import 'package:fastfixer_web/theme/sizes.dart';

import 'package:flutter/material.dart';

class TElevatedButtontheme {
  TElevatedButtontheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        foregroundColor: tWhitecolor,
        backgroundColor: tSecondaryColor,
        side: const BorderSide(color: tSecondaryColor),
        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        foregroundColor: tWhitecolor,
        backgroundColor: tSecondaryColor,
        side: const BorderSide(color: tWhitecolor),
        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)),
  );
}
