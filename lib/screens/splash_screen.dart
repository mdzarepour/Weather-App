import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/components/constants/colors.dart';
import 'package:weather_app/components/constants/strings.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/weather_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late String _cityName;
  WeatherService weatherService = WeatherService();
  @override
  void initState() {
    super.initState();
    _getCityName();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(gradient: GradientColor.backGroundGrdaient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: LottieBuilder.asset(
                    Strings.animationAssetSplash,
                  ),
                ),
                const SpinKitThreeBounce(
                  duration: Duration(seconds: 4),
                  size: 19,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getCityName() async {
    String city = await WeatherService().getUserCity();
    _cityName = city;
    _navigateToHomeScreen();
  }

  _navigateToHomeScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(cityName: _cityName),
        ));
  }
}
