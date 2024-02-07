import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:insuno_m/main.dart';
import 'package:insuno_m/screens/dashboard.dart';
import 'package:insuno_m/screens/login.dart';

class ResetPassword extends StatelessWidget {
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
    double imageWidth = 257.0;
    double imageHeight = 213.0;

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE), // Background color
      resizeToAvoidBottomInset:
          true, // Ensure the scaffold resizes when the keyboard appears
      body: SingleChildScrollView(
        // Allows the content to be scrollable
        child: Container(
          height: MediaQuery.of(context)
              .size
              .height, // Ensure the container takes full screen height
          child: Stack(
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

              // "Welcome onboard" text using AutoSizeText
              Positioned(
                top: 260,
                left: screenWidth *
                    0.275, // Centering text by adjusting left padding
                child: Container(
                  width: screenWidth * 0.45, // 45% width of the screen
                  height: 24,
                  child: AutoSizeText(
                    'Reset password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),

              // Second text using AutoSizeText
              Positioned(
                top: 316,
                left: screenWidth *
                    0.15, // Adjusting left padding to center the text
                child: Container(
                  width: screenWidth * 0.7, // 70% width of the screen
                  height: 48,
                  child: AutoSizeText(
                    'Enter the email address you used when you joined and we’ll send you instructions to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                    minFontSize: 10,
                  ),
                ),
              ),

              // Text input for email
              Positioned(
                top: 444, // Adjust top positioning as needed
                left: screenWidth * 0.06, // To achieve 88% width of the screen
                right: screenWidth * 0.06,
                child: Container(
                  height: 50, // Height is 50
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color white
                    borderRadius: BorderRadius.circular(25), // Corner radius 25
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none, // No border
                      hintText: 'Enter your email', // Placeholder text
                      hintStyle: TextStyle(
                          color: Colors.grey), // Placeholder text color
                      contentPadding: EdgeInsets.only(
                        left: 40,
                        top: 15,
                        bottom: 15,
                        right: 40,
                      ), // Padding inside the input field, including 20 from the left
                    ),
                    style: TextStyle(
                      fontSize: 12, // Smaller font size
                    ),
                  ),
                ),
              ),

              // Positioned Register Button
              Positioned(
                bottom: 79, //top: screenHeight * 0.83, // 83% from the top
                left: screenWidth *
                    0.06, // 6% padding from left to achieve 88% width
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DashboardPage()),
                    // );
                  },
                  child: Text(
                    'Reset password',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF), // Text color
                      fontSize: 13, // Adjust the font size as needed
                    ),
                  ),
                ),
              ),
              // Positioned "Already have an account? Sign In"
              Positioned(
                bottom: 34, // Adjust this value as needed to position the text
                child: Container(
                  width: screenWidth, // Full screen width for easy centering
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black), // Default text style
                        children: <TextSpan>[
                          TextSpan(text: 'You remember you password? '),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 19, 81, 85),
                                fontWeight:
                                    FontWeight.bold), // Sign In text style
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
