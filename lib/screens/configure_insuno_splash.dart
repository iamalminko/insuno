import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:insuno_m/main.dart';
import 'package:insuno_m/screens/configure_wifi.dart';
import 'package:insuno_m/screens/registration.dart';

class ConfigureInsunoSplash extends StatelessWidget {
  final Widget destination;

  ConfigureInsunoSplash({required this.destination});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double circleDiameter = screenWidth / 2;
    // Adjusting the position to center the circles based on the provided coordinates
    double circle1Top = 91 - circleDiameter / 2;
    double circle1Left = 0 - circleDiameter / 2;
    double circle2Top = 0 - circleDiameter / 2;
    double circle2Left = 96 - circleDiameter / 2;

    // SVG Image dimensions
    double imageWidth = 260.0;
    double imageHeight = 174.0;

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE), // Background color
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
                  color: Color(0xFFEBAC90), // Circle color
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
                  color: Color(0xFFEBAC90), // Circle color
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Positioned SVG Image
          Positioned(
            top: screenHeight * 0.28, // 28% from the top
            left: (screenWidth - imageWidth) / 2, // Centered horizontally
            child: SvgPicture.asset(
              'assets/undraw_set_preferences_kwia.svg', // Ensure this path is correct
              width: imageWidth,
              height: imageHeight,
            ),
          ),

          // Auto Size Text
          Positioned(
            top: 512,
            left: screenWidth * 0.06, // 6% padding from left
            right: screenWidth *
                0.06, // 6% padding from right to maintain 88% width
            child: AutoSizeText(
              'Configuration mode',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold font
                // No need to set fontSize here, AutoSizeText will adjust it automatically
              ),
              maxLines: 1,
              textAlign: TextAlign.center, // Center align text
            ),
          ),
          // Second Auto Size Text
          Positioned(
            top: 567,
            left: screenWidth *
                0.15, // Centering the text by setting left to 37.5% (since width is 25%)
            child: Container(
              width: screenWidth * 0.70, // Width is 25% of the screen width
              height: 65, // Fixed height
              child: AutoSizeText(
                '• Please turn off Mobile Data\n'
                '• Connect to INSUNO AP using WiFi\n'
                '• Then press Proceed',
                textAlign: TextAlign.left, // Center align text
                style: TextStyle(
                    // Use a regular font style
                    ),
                maxLines: 4, // Text should fit in 3 rows
                minFontSize:
                    10, // Minimum font size to use (can adjust based on your needs)
              ),
            ),
          ),
          // Positioned Button
          Positioned(
            bottom: 79, // Adjust this value as needed to position the button
            left:
                screenWidth * 0.06, // 6% padding from left to achieve 88% width
            right: screenWidth *
                0.06, // 6% padding from right to achieve 88% width
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF06E33), // Button color
                fixedSize: Size(screenWidth * 0.88, 60), // Button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No corner radius
                ),
              ),
              onPressed: () {
                // Navigate to InsunoHomePage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              },
              child: Text(
                'Proceed',
                style: TextStyle(
                  fontSize: 13, // Adjust the font size as needed
                  color: Color(0xFFFFFFFF), // Text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
