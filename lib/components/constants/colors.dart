import 'package:flutter/material.dart';

class SolidColors {
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Color.fromARGB(118, 44, 45, 53);
  static const Color draweMenuColor = Color.fromARGB(255, 44, 45, 53);
  static const Color greenIconColor = Colors.greenAccent;
  static const Color blueIconColor = Colors.lightBlueAccent;
  static const Color yellowIconColor = Colors.yellowAccent;
  static const Color greenShadowColor = Color.fromARGB(80, 105, 240, 175);
  static const Color blueShadowColor = Color.fromARGB(80, 64, 195, 255);
  static const Color yellowShadowColor = Color.fromARGB(80, 255, 255, 0);
}

class GradientColor {
  static const LinearGradient backGroundGrdaient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xff484B5B),
        Color(0xff2C2D35),
      ]);
  static const LinearGradient homeScreenGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff484B5B),
        Color(0xff2C2D35),
      ]);
}
