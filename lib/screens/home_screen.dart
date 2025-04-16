import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:developer' as developer;

import 'package:weather_app/components/constants/colors.dart';
import 'package:weather_app/components/constants/strings.dart';
import 'package:weather_app/components/widgets/detail_column_widget.dart';
import 'package:weather_app/components/widgets/loading.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  final String cityName;
  const HomeScreen({super.key, required this.cityName});
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late String _cityName;
  late Future<Weather> _weather;
  late Weather uiWeather;
  bool isVisible = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cityName = widget.cityName;
    _fetchWeatherData();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.dispose();
  }

  void _fetchWeatherData() {
    _weather = WeatherService().getWeatherData(_cityName);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: GradientColor.homeScreenGradient,
      ),
      child: GestureDetector(
        onTap: () => _searchFocusNode.unfocus(),
        child: Scaffold(
          appBar: _buildAppBar(context),
          drawer: _buildDrawerMenu(),
          body: FutureBuilder(
            future: _weather,
            builder: (context, snapshot) {
              // accurate condition --->
              if (snapshot.hasData) {
                uiWeather = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 50,
                  ),
                  child: Column(
                    spacing: 40,
                    children: [
                      _buildHeaderSection(textTheme),
                      _buildMainSection(textTheme, size),
                      _buildFooterSection(size, textTheme),
                    ],
                  ),
                );
                //error condition --->
              } else if (snapshot.hasError) {
                return Center(
                  child: OutlinedButton(
                    onPressed: () => _fetchWeatherData(),
                    child: Text('retry'),
                  ),
                );
                // waiting condition --->
              } else {
                return Loading();
              }
            },
          ),
        ),
      ),
    );
  }

  // appBar widget --->
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // menu icon --->
      leading: Builder(
        builder:
            (context) => InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(HugeIcons.strokeRoundedMenu02, size: 30),
            ),
      ),
      // search textfiels --->
      title: SizedBox(
        height: 45,
        width: 260,
        child: Center(
          child: TextField(
            decoration: InputDecoration(hintText: 'Search City'),
            textAlign: TextAlign.center,
            cursorOpacityAnimates: true,
            keyboardType: TextInputType.name,
            cursorColor: SolidColors.whiteColor,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlignVertical: TextAlignVertical.center,
            focusNode: _searchFocusNode,
            onSubmitted: (value) {
              _searchCity(value);
            },
          ),
        ),
      ),
    );
  }

  _searchCity(String input) async {
    setState(() {
      _weather = WeatherService().getWeatherData(input);
    });
  }

  // drawer menu widget --->
  Drawer _buildDrawerMenu() {
    // map contains listTiles data --->
    Map<String, String> listTile = {
      DrawerStrings.flutterTitle: DrawerStrings.flutterLink,
      DrawerStrings.gitHubTitle: DrawerStrings.gitHubLink,
      DrawerStrings.websiteTitle: DrawerStrings.websiteLink,
    };
    return Drawer(
      backgroundColor: SolidColors.draweMenuColor,
      child: ListView(
        children: [
          for (int i = 0; i < listTile.length; i++)
            ListTile(
              onTap: () => _launchUrl(listTile.values.elementAt(i)),
              title: Text(listTile.keys.elementAt(i)),
            ),
        ],
      ),
    );
  }

  // header contains city,country,date --->
  Column _buildHeaderSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        Text(uiWeather.name, style: textTheme.bodyLarge),
        Text(uiWeather.country, style: textTheme.bodyLarge),
        Text(_getDate(), style: textTheme.bodyMedium),
      ],
    );
  }

  Row _buildMainSection(TextTheme textTheme, Size size) {
    return Row(
      spacing: size.width / 15,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // animation --->
        SizedBox(
          height: size.height / 6,
          child: LottieBuilder.asset(_getWeatherAnimation(uiWeather)),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // temp & condition --->
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  uiWeather.temp.round().toString(),
                  style: textTheme.titleLarge,
                ),
                Text(
                  uiWeather.main,
                  style: textTheme.bodyMedium!.copyWith(fontSize: 23),
                ),
              ],
            ),
            // temperature symbol --->
            Row(
              children: [
                Text('°', style: textTheme.bodyLarge),
                Text('C', style: textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column _buildFooterSection(Size size, TextTheme textTheme) {
    Map<String, List<dynamic>> infoWidgets = {
      'Condition': [
        SolidColors.yellowShadowColor,
        Icon(CupertinoIcons.doc, color: SolidColors.yellowIconColor),
        uiWeather.main,
      ],
      'Humidity': [
        SolidColors.blueShadowColor,
        Icon(CupertinoIcons.drop, color: SolidColors.blueIconColor),
        uiWeather.humidity.toString(),
      ],
      'Wind Speed': [
        SolidColors.greenShadowColor,
        Icon(CupertinoIcons.wind, color: SolidColors.greenIconColor),
        uiWeather.windSpeed.toString(),
      ],
    };
    return Column(
      spacing: 20,
      children: [
        // create three widget using map data --->
        for (int i = 0; i < 3; i++)
          InformationColumnWidget(
            shadowColor: infoWidgets.values.elementAt(i)[0],
            icon: infoWidgets.values.elementAt(i)[1],
            title: infoWidgets.keys.elementAt(i),
            value: infoWidgets.values.elementAt(i)[2],
          ),
      ],
    );
  }
}

// used in drawer menu widget --->
void _launchUrl(String url) async {
  Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      developer.log('Failed to open URL: $url');
    }
  } catch (e) {
    developer.log('There is a problem with the whole launch method: $e');
  }
}

// used in headr section --->
String _getDate() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('EEE, MMM d').format(now);
  return formattedDate;
}

// used in main section --->
String _getWeatherAnimation(Weather uiWeather) {
  const baseAddress = 'assets/images/';
  final conditionMap = {
    'Clouds': 'cloudy.json',
    'Mist': 'cloudy.json',
    'Smoke': 'cloudy.json',
    'Haze': 'cloudy.json',
    'Dust': 'cloudy.json',
    'Fog': 'cloudy.json',
    'Rain': 'rain.json',
    'Drizzle': 'rain.json',
    'Shower rain': 'rain.json', // Fixed typo
    'Thunderstorm': 'thunder.json',
    'Clear': 'sunny.json',
  };
  return '$baseAddress${conditionMap[uiWeather.main] ?? 'sunny.json'}';
}
