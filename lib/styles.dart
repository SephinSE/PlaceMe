import 'package:flutter/material.dart';

class AppStyles {
  static Color thistleColor = const Color(0xFF3468EA);
  static Color thistleColor2 = const Color(0xFF383C86);
  static Color onThistleColor = const Color(0xFFB6C5FF);

  static TextStyle textStyle = TextStyle(
    fontFamily: 'Roboto Flex',
    fontWeight: FontWeight.w400,
    color: thistleColor2,
    fontSize: 15,
  );
  static InputDecoration formStyle = InputDecoration(
    fillColor: const Color(0xFFFFFFFF),
    filled: true,
    hintStyle: textStyle.copyWith(
      fontSize: 20,
      color: thistleColor2,
    ),
    floatingLabelStyle: textStyle.copyWith(
        fontSize: 20,
        color: thistleColor2,
        height: 100
    ),
    contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 24
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(22),
    ),
  );
  static ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(thistleColor),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      textStyle: WidgetStateProperty.all<TextStyle>(textStyle.copyWith(
        fontSize: 19,
      )),
      padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))
  );

  Widget progressIndicator = const SizedBox(
    height: 22,
    width: 22,
    child: Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    ),
  );
}