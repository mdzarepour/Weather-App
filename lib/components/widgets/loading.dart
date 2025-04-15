import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/components/constants/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitThreeBounce(
      color: SolidColors.whiteColor,
      size: 20,
      duration: Duration(seconds: 2),
    );
  }
}
