import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String? _cityName;
  Weather? _weather;
  bool _isLoading = true;
  bool _searchVisibility = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _cityName = widget.cityName;
    _fetchWeatherData();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration:
          const BoxDecoration(gradient: GradientColor.homeScreenGradient),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => _searchFocusNode.unfocus(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: _buildAppBar(),
              drawer: _buildDrawerMenu(),
              body: _isLoading
                  ? const Loading()
                  : SingleChildScrollView(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 30),
                          child: Column(
                            children: [
                              _buildHeaderSection(textTheme),
                              const SizedBox(height: 20),
                              _buildMainSection(textTheme, size),
                              const SizedBox(height: 30),
                              _buildFooterSection(size, textTheme),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

// drawe menu with listtiles =>
  Drawer _buildDrawerMenu() {
    return Drawer(
      backgroundColor: SolidColors.draweMenuColor,
      child: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Icon(
              size: 50,
              Icons.content_copy,
              color: SolidColors.whiteColor,
            ),
          ),
          const SizedBox(height: 35),
          const ListTile(
            title: Text(Strings.weather),
          ),
          ListTile(
            onTap: () => _launchUrl(Strings.gitHubLink),
            title: const Text(Strings.opt1),
          ),
          ListTile(
            onTap: () => _launchUrl(Strings.apiWebsite),
            title: const Text(Strings.opt2),
          ),
        ],
      ),
    );
  }

  // appbar with search , menu , textfield =>
  AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: () {
            setState(
              () {
                _searchVisibility == false
                    ? _searchVisibility = true
                    : _searchVisibility = false;
              },
            );
          },
          child: const Icon(HugeIcons.strokeRoundedSearch01),
        ),
      ),
      title: _buildSearchInput(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Builder(
            builder: (context) => InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(HugeIcons.strokeRoundedMenu02),
            ),
          ),
        ),
      ],
    );
  }

  // search input , inside appbar =>
  SizedBox _buildSearchInput() {
    return SizedBox(
      height: 45,
      width: 260,
      child: Visibility(
        visible: _searchVisibility,
        child: Center(
          child: TextField(
            textAlign: TextAlign.center,
            cursorOpacityAnimates: true,
            keyboardType: TextInputType.name,
            cursorColor: SolidColors.whiteColor,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlignVertical: TextAlignVertical.center,
            //styles end ------------------------------
            focusNode: _searchFocusNode,
            controller: _searchController,
            onChanged: (value) async {
              if (_searchController.text == '') {
                _fetchWeatherData();
              }
              Weather freshWeather =
                  await WeatherService().getWeatherData(_searchController.text);
              setState(
                () => _weather = freshWeather,
              );
            },
          ),
        ),
      ),
    );
  }

// header section , contain city and date =>
  Column _buildHeaderSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        Text(_weather!.name, style: textTheme.bodyLarge),
        Text(_weather!.country, style: textTheme.bodyLarge),
        Text(_getDate(), style: textTheme.bodyMedium),
      ],
    );
  }

// main section , contain animation & temp =>
  Row _buildMainSection(TextTheme textTheme, Size size) {
    return Row(
      spacing: 30,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height / 6,
          child: LottieBuilder.asset(_getWeatherAnimation()),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _weather!.temp.round().toString(),
                  style: textTheme.titleLarge,
                ),
                Text(
                  _weather!.main,
                  style: textTheme.bodyMedium!.copyWith(fontSize: 23),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text('°', style: textTheme.bodyLarge),
                    Text('C', style: textTheme.bodyLarge),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

// footer section , contains three rows =>
  Column _buildFooterSection(Size size, TextTheme textTheme) {
    return Column(
      spacing: 20,
      children: [
        //condition data =>
        InformationColumnWidget(
            shadowColor: SolidColors.yellowShadowColor,
            icon: const Icon(CupertinoIcons.doc,
                color: SolidColors.yellowIconColor),
            title: 'condition :',
            value: _weather!.main),
        //humidity data =>
        InformationColumnWidget(
            shadowColor: SolidColors.blueShadowColor,
            icon: const Icon(CupertinoIcons.drop,
                color: SolidColors.blueIconColor),
            title: 'humidity :',
            value: _weather!.humidity.toString()),
        //wind speed data =>
        InformationColumnWidget(
            shadowColor: SolidColors.greenShadowColor,
            icon: const Icon(CupertinoIcons.wind,
                color: SolidColors.greenIconColor),
            title: 'wind speed :',
            value: _weather!.windSpeed.toString()),
      ],
    );
  }

// get animation for main section ui =>
  String _getWeatherAnimation() {
    String mainCondition = _weather!.main;
    String baseAddress = 'assets/images/';
    if (mainCondition.isEmpty && _isLoading == true) {
      return '${baseAddress}sunny.json';
    }
    switch (mainCondition) {
      case 'Clouds':
      case 'Mist':
      case 'Smoke':
      case 'Haze':
      case 'Dust':
      case 'Fog':
        return '${baseAddress}cludy.json';
      case 'Rain':
      case 'Drizzle':
      case 'Showe rain':
        return '${baseAddress}rain.json';
      case 'Thunderstorm':
        return '${baseAddress}thunder.json';
      case 'Clear':
        return '${baseAddress}sunny.json';
      default:
        return '${baseAddress}sunny.json';
    }
  }

// get date for header section ui =>
  String _getDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, MMM d').format(now);
    return formattedDate;
  }

// fetch data from service =>
  void _fetchWeatherData() async {
    try {
      Weather weather = await WeatherService().getWeatherData(_cityName!);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      developer.log('error while fetching city data');
    }
  }

// url luncher for drawer menu
  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        developer.log('');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('we cant open the link right now'),
          ),
        );
      }
    } catch (e) {
      developer.log('there is a problem with the whole lunch method');
    }
  }
}
