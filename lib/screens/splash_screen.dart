import 'package:flutter/material.dart';
import 'package:weather_app/components/constants/colors.dart';
import 'package:weather_app/components/widgets/loading.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/weather_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late Future<String> _cityName;

  @override
  void initState() {
    super.initState();
    _getCityName();
  }

  _getCityName() async {
    setState(() {
      _cityName = WeatherService().getUserCity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: GradientColor.backGroundGrdaient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: _cityName,
              builder: (context, snapshot) {
                // accurate condition --->
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => HomeScreen(cityName: snapshot.data!),
                      ),
                    );
                  });

                  // error condition --->
                } else if (snapshot.hasError) {
                  return OutlinedButton(
                    onPressed: () => _getCityName(),
                    child: Text('retry'),
                  );
                  // waiting condition --->
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Image.asset('assets/images/splash.png', height: 60),
                      Loading(),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  // navigate to HomeScreen and pass _cityName --->
}
