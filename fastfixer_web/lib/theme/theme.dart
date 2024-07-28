import 'package:fastfixer_web/theme/widget_themes/elevated_button_theme.dart';
import 'package:fastfixer_web/theme/widget_themes/outlined_button_theme..dart';
import 'package:fastfixer_web/theme/widget_themes/text_field_theme.dart';
import 'package:fastfixer_web/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    outlinedButtonTheme: TOutlinedButtontheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButtontheme.lightElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldtheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    outlinedButtonTheme: TOutlinedButtontheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButtontheme.darkElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldtheme.darkInputDecorationTheme,
  );
}
