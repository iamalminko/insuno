import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insuno_m/main.dart';
import 'package:insuno_m/screens/getting_started.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GettingStarted(),
        ),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleDiameter = 296.0;
    // Calculate the top and left properties for the circles to position them by their centers
    double circle1Top = 91 - circleDiameter / 2;
    double circle1Left = 0 - circleDiameter / 2;
    double circle2Top = 0 - circleDiameter / 2;
    double circle2Left = 96 - circleDiameter / 2;

    return Scaffold(
      backgroundColor: Color(0xFF010101), // Background color
      body: Stack(
        children: [
          // First circle
          Positioned(
            top: circle1Top,
            left: circle1Left,
            child: Opacity(
              opacity: 0.44,
              child: Container(
                width: circleDiameter,
                height: circleDiameter,
                decoration: BoxDecoration(
                  color: Color(0xFFEBAC90),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Second circle
          Positioned(
            top: circle2Top,
            left: circle2Left,
            child: Opacity(
              opacity: 0.44,
              child: Container(
                width: circleDiameter,
                height: circleDiameter,
                decoration: BoxDecoration(
                  color: Color(0xFFEBAC90),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Image in the center
          Positioned(
            top: 274,
            left: 44,
            child: Container(
              width: 304,
              height: 304,
              child: Image.asset(
                  'assets/splash_logo_dark.jpg'), // Replace 'your_image.png' with your actual image asset name
            ),
          ),
        ],
      ),
    );
  }
}
