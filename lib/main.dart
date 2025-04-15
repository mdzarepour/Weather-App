import 'package:flutter/material.dart';

main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        listTileTheme: listTileTheme(),
        inputDecorationTheme: textFieldDecoration(),
        appBarTheme: _appBarTheme(),
        textTheme: textThemes(),
      ),
      home: const SplashScreen(),
    );
  }

  // drawer Listtile themes =>
  ListTileThemeData listTileTheme() {
    return const ListTileThemeData(
      titleTextStyle: TextStyle(
        fontSize: 25,
        fontFamily: 'ARLRDBD',
        color: SolidColors.whiteColor,
      ),
    );
  }

  // seach textField theme =>
  InputDecorationTheme textFieldDecoration() {
    return const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      fillColor: SolidColors.greyColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }

  // appBar theme =>
  AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: SolidColors.whiteColor, size: 30),
    );
  }

  // textThemes =>
  TextTheme textThemes() {
    return const TextTheme(
      //city and country name textTheme
      bodyLarge: TextStyle(
        color: SolidColors.whiteColor,
        fontSize: 30,
        letterSpacing: 1.5,
        fontFamily: 'ARLRDBD',
        fontWeight: FontWeight.w700,
      ),
      //splash screen textTheme
      headlineLarge: TextStyle(
        color: SolidColors.whiteColor,
        fontSize: 19,
        letterSpacing: 1.2,
        fontFamily: 'ARLRDBD',
        fontWeight: FontWeight.w700,
      ),
      //date textTheme
      bodyMedium: TextStyle(
        color: SolidColors.whiteColor,
        fontSize: 17,
        letterSpacing: 1.2,
        fontFamily: 'ARLRDBD',
        fontWeight: FontWeight.w100,
      ),
      //temp textTheme
      titleLarge: TextStyle(
        fontFamily: 'ARLRDBD',
        color: SolidColors.whiteColor,
        fontSize: 90,
        letterSpacing: 1.2,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
