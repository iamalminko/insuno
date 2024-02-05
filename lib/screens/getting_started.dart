import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:insuno_m/main.dart';

class GettingStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double circleDiameter = 296.0;
    // Adjusting the position to center the circles based on the provided coordinates
    double circle1Top = 91 - circleDiameter / 2;
    double circle1Left = 0 - circleDiameter / 2;
    double circle2Top = 0 - circleDiameter / 2;
    double circle2Left = 96 - circleDiameter / 2;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // SVG Image dimensions
    double imageWidth = 257.0;
    double imageHeight = 213.0;

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
              'assets/undraw_home_screen_re_640d.svg', // Ensure this path is correct
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
              'Manage smart tables with Insuno M',
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
            top: 555,
            left: screenWidth *
                0.15, // Centering the text by setting left to 37.5% (since width is 25%)
            child: Container(
              width: screenWidth * 0.70, // Width is 25% of the screen width
              height: 99, // Fixed height
              child: AutoSizeText(
                'Gain insight into the battery level and power consumption of Insuno Smart Tables. Enable wireless charger, USB-C charger, LED lights and much more.',
                textAlign: TextAlign.center, // Center align text
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
            bottom: 73, // Adjust this value as needed to position the button
            left:
                screenWidth * 0.06, // 6% padding from left to achieve 88% width
            right: screenWidth *
                0.06, // 6% padding from right to achieve 88% width
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF06E33), // Button color
                fixedSize: Size(screenWidth * 0.88, 60), // Button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No corner radius
                ),
              ),
              onPressed: () {
                // Navigate to InsunoHomePage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InsunoHomePage()),
                );
              },
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 15, // Adjust the font size as needed
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
