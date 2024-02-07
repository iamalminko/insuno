import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:insuno_m/main.dart';
import 'package:http/http.dart' as http;
import 'package:insuno_m/screens/dashboard.dart';
import 'package:insuno_m/screens/registration.dart';

enum RequestStatus { initial, loading, success, error }

class ConfigureReboot extends StatefulWidget {
  @override
  _ConfigureReboot createState() => _ConfigureReboot();
}

class _ConfigureReboot extends State<ConfigureReboot> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RequestStatus requestStatus = RequestStatus.initial;

  @override
  void initState() {
    super.initState();
  }

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
                top: 322,
                left: screenWidth *
                    0.275, // Centering text by adjusting left padding
                child: Container(
                  width: screenWidth * 0.45, // 45% width of the screen
                  height: 24,
                  child: const AutoSizeText(
                    'Reboot Insuno',
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
                top: 378,
                left: screenWidth *
                    0.15, // Adjusting left padding to center the text
                child: Container(
                  width: screenWidth * 0.7, // 70% width of the screen
                  height: 48,
                  child: AutoSizeText(
                    'Press the button to reboot the table.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                    minFontSize: 10,
                  ),
                ),
              ),

              Positioned(
                top: 420, // Adjust positioning as needed
                right: screenWidth * 0.06,
                child: requestStatus == RequestStatus.loading
                    ? SizedBox(
                        width:
                            20, // Set the width of the CircularProgressIndicator
                        height:
                            20, // Set the height of the CircularProgressIndicator
                        child: CircularProgressIndicator(),
                      )
                    : requestStatus == RequestStatus.success
                        ? Icon(Icons.check_circle,
                            color: Colors
                                .green) // Show green checkmark for success
                        : requestStatus == RequestStatus.error
                            ? Icon(Icons.error,
                                color:
                                    Colors.red) // Show red 'x' icon for error
                            : Container(), // Initial state, show nothing
              ),

              // "Set" Button
              Positioned(
                top: 635,
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFACA4A0), // Button color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero // Adjust the border radius as needed
                          ),
                    ),
                    onPressed: () async {
                      setState(() {
                        requestStatus =
                            RequestStatus.loading; // Indicate loading status
                      });
                      final String ssid = ssidController.text;
                      final String password = passwordController.text;
                      final Uri url = Uri.parse('http://192.168.4.1/')
                          .replace(queryParameters: {
                        'reset': 'Reboot',
                      });

                      try {
                        final response = await http.get(url).timeout(
                              const Duration(
                                  seconds:
                                      3), // Set the timeout duration to 10 seconds
                            );

                        if (response.statusCode == 200) {
                          setState(() {
                            requestStatus =
                                RequestStatus.success; // Indicate success
                          });
                          // Successfully sent the request
                          print('Request successful');
                        } else {
                          setState(() {
                            requestStatus =
                                RequestStatus.error; // Indicate error
                          });
                          // Error occurred
                          print(
                              'Request failed with status: ${response.statusCode}.');
                        }
                      } on TimeoutException catch (_) {
                        setState(() {
                          requestStatus =
                              RequestStatus.error; // Handle timeout as error
                        });
                        // Handle timeout error
                        print('The request timed out.');
                      } catch (e) {
                        setState(() {
                          requestStatus =
                              RequestStatus.error; // Handle other errors
                        });
                        // Handle any other errors that occur during the request
                        print('Error sending request: $e');
                      }
                      // The functionality previously associated with the "Finish" button
                      // Implement your HTTP request or other logic here
                    },
                    child: Text(
                      'Reboot',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF), // Text color
                        fontSize: 13, // Adjust the font size as needed
                      ),
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
                    //Navigate to InsunoHomePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardPage(isCardVisibleInitially: true),
                      ), // Or false
                    );

                    setState(() {
                      requestStatus = RequestStatus.initial;
                    });
                  },
                  child: Text(
                    'Finish',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF), // Text color
                      fontSize: 13, // Adjust the font size as needed
                    ),
                  ),
                ),
              ),
              // Positioned "Already have an account? Sign In"
            ],
          ),
        ),
      ),
    );
  }
}
