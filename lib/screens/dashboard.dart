import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:insuno_m/main.dart';
import 'package:insuno_m/screens/configure_ap.dart';
import 'package:insuno_m/screens/configure_reboot.dart';
import 'package:insuno_m/screens/configure_wifi.dart';
import 'package:insuno_m/screens/configure_insuno_splash.dart';
import 'package:insuno_m/screens/login.dart';
import 'package:insuno_m/screens/registration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DeviceCard extends StatefulWidget {
  final String deviceId;

  DeviceCard({required this.deviceId});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  double current = 0.0;
  double voltage = 0.0;
  Map<String, bool> relayStates = {
    'WiFi Charger': false,
    'LED': false,
    'USB-C': false,
  };

  Timer? measurementsTimer;
  Timer? parametersTimer; // Timer for fetching parameters

  @override
  void initState() {
    super.initState();
    fetchMeasurements();
    // measurementsTimer =
    //     Timer.periodic(Duration(seconds: 10), (Timer t) => fetchMeasurements());
    fetchParameters();
    // parametersTimer =
    //     Timer.periodic(Duration(seconds: 10), (Timer t) => fetchParameters());
  }

  Future<void> fetchMeasurements() async {
    // String postUrl =
    //     "https://firestore.googleapis.com/v1/projects/espmeasurement/databases/(default)/documents:runQuery";
    String postUrl =
        "https://firestore.googleapis.com/v1/projects/espmeasurement/databases/(default)/documents/devices/${widget.deviceId}:runQuery";
    String postBody = json.encode({
      "structuredQuery": {
        "from": [
          {"collectionId": "measurements"}
        ],
        "orderBy": [
          {
            "field": {"fieldPath": "timestamp"},
            "direction": "DESCENDING"
          }
        ],
        "limit": 1
      }
    });
    final response = await http.post(
      Uri.parse(postUrl),
      body: postBody,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          current =
              (data[0]['document']['fields']['current']['doubleValue'] as num)
                  .toDouble();
          voltage =
              (data[0]['document']['fields']['voltage']['doubleValue'] as num)
                  .toDouble();
        });
      }
    } else {
      // Handle the error; for simplicity, we're just printing it
      print('Failed to load measurements: ${response.reasonPhrase}');
    }
  }

  Future<void> fetchParameters() async {
    // String postUrl =
    //     "https://firestore.googleapis.com/v1/projects/espmeasurement/databases/(default)/documents/parameters";
    String postUrl =
        "https://firestore.googleapis.com/v1/projects/espmeasurement/databases/(default)/documents/devices/${widget.deviceId}/parameters";

    final response = await http.get(Uri.parse(postUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(response.body);

      for (var document in parsedJson['documents']) {
        // Extracting the relay number from the 'name' field
        String name = document['name'];
        var relayNumber = name
            .split('/')
            .last
            .split('_')
            .last; // Extracts the number from relay_X

        // Extracting the state value
        bool state = false;
        try {
          state = document['fields']['state']['integerValue'] == "1";
        } catch (e) {}

        // Mapping the relay number to the corresponding relay in relayStates map
        switch (relayNumber) {
          case '1':
            relayStates['WiFi Charger'] = state;
            break;
          case '2':
            relayStates['LED'] = state;
            break;
          case '3':
            relayStates['USB-C'] = state;
            break;
          // Add more cases as needed
        }
      }
      // Update the UI
      setState(() {});
    } else {
      print('Failed to load parameters: ${response.reasonPhrase}');
    }
  }

  void updateRelay(String relay) async {
    const String baseUrl = 'https://firestore.googleapis.com/v1';
    const String projectId =
        'espmeasurement'; // Replace with your Firebase project ID
    const String collectionName =
        'parameters'; // Replace with your collection name
    const String accessToken =
        'YOUR_ACCESS_TOKEN'; // Replace with a valid access token
    bool state;

    String relayName = "relay_1";
    state = relayStates[relay] ?? false;

    switch (relay) {
      case 'WiFi Charger':
        relayName = 'relay_1';
        break;
      case 'LED':
        relayName = 'relay_2';
        break;
      case 'USB-C':
        relayName = 'relay_3';
        break;
    }

    // Step 2: Update the document using the document ID
    String updateUrl =
        '$baseUrl/projects/$projectId/databases/(default)/documents/devices/${widget.deviceId}/$collectionName/$relayName';
    String updateBody = json.encode({
      'fields': {
        // Update your fields here
        'state': {'integerValue': state ? 1 : 0},
      },
    });
    final updateResponse = await http.patch(
      Uri.parse(updateUrl),
      body: updateBody,
    );

    if (updateResponse.statusCode == 200) {
      //print('Document successfully updated.');
    } else {
      //print('Failed to update document. StatusCode: ${updateResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your existing card layout code here
    // Replace 'Beach table 1' with widget.deviceName
    // Positioned Card
    return Card(
      color: Color(0xFFFFFFFF), // Card background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13), // Corner radius
      ),
      child: Container(
        height: 151, // Fixed height
        padding: EdgeInsets.all(8), // Padding inside the card
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Space rows evenly within the card
          children: [
            // First Row
            Row(
              children: [
                Text(
                  widget.deviceId,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0x46000000),
                  ),
                ),
              ],
            ),

            // Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Space elements evenly in the row
              children: [
                SvgPicture.asset('assets/bolt.svg',
                    width: 24,
                    height: 24), // Replace with your actual SVG asset
                Text(
                  '$current A',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0x46000000),
                  ),
                ),
                SvgPicture.asset('assets/battery.svg',
                    width: 24,
                    height: 24), // Replace with your actual SVG asset
                Text(
                  '$voltage V',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0x46000000),
                  ),
                ),
              ],
            ),

            // Third Row - Texts
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Space texts evenly in the row
              children: relayStates.keys.map((relay) => Text(relay)).toList(),
            ),

            // Fourth Row - Switches aligned under the texts
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Align centers of switches under the texts
              children: relayStates.keys.toList().asMap().entries.map((entry) {
                int idx = entry.key;
                String relay = entry.value;
                Widget switchWidget = Switch(
                  value: relayStates[relay]!,
                  onChanged: (bool value) {
                    // Handle relay toggle
                    setState(() {
                      relayStates[relay] = value;
                    });
                    updateRelay(relay);
                    // Update the relay state in your backend or model as well
                  },
                  activeTrackColor: Color(0xFFF06E33),
                );

                // Apply translation to the second switch only
                if (idx == 0) {
                  // Remember, index is 0-based so the second item is at index 1
                  return Transform.translate(
                    offset: Offset(25, 0), // Move 100 pixels to the right
                    child: switchWidget,
                  );
                }
                if (idx == 1) {
                  // Remember, index is 0-based so the second item is at index 1
                  return Transform.translate(
                    offset: Offset(27, 0), // Move 100 pixels to the right
                    child: switchWidget,
                  );
                }
                if (idx == 2) {
                  // Remember, index is 0-based so the second item is at index 1
                  return Transform.translate(
                    offset: Offset(7, 0), // Move 100 pixels to the right
                    child: switchWidget,
                  );
                }
                return switchWidget;
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  final bool isCardVisibleInitially;
  DashboardPage({this.isCardVisibleInitially = false});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  // Dummy data for current and voltage
  double? current;
  double? voltage;

  List<DeviceCard> deviceCards = [];

  bool isCardVisible = false; // State variable for card visibility

  void toggleCard() {
    setState(() {
      isCardVisible = !isCardVisible; // Toggle the card visibility
    });
  }

  // Initial states for the relays
  Map<String, bool> relayStates = {
    'WiFi Charger': false,
    'LED': false,
    'USB-C': false,
  };

  @override
  void initState() {
    super.initState();
    isCardVisible = widget.isCardVisibleInitially;
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    String devicesUrl =
        "https://firestore.googleapis.com/v1/projects/espmeasurement/databases/(default)/documents/device_names";
    final response = await http.get(Uri.parse(devicesUrl));

    if (response.statusCode == 200) {
      List<dynamic> devicesData = json.decode(response.body)['documents'];
      setState(() {
        deviceCards = devicesData.map((deviceData) {
          return DeviceCard(
            deviceId: deviceData['name'].split('/').last,
          );
        }).toList();
      });
    } else {
      print('Failed to load devices: ${response.reasonPhrase}');
    }
  }

  @override
  void dispose() {
    super.dispose();
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
              Positioned(
                top: 0, // At the top of the screen
                child: Container(
                  width: screenWidth, // Fill the width of the screen
                  height: 292, // Fixed height of 292 pixels
                  color: Color(0xFFF06E33), // Rectangle color
                ),
              ),

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
                      color: Color(0xFFfbb89a), // Circle color
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
                      color: Color(0xFFfbb89a), // Circle color
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // "Welcome onboard" text using AutoSizeText
              Positioned(
                top: 241,
                left: screenWidth *
                    0.275, // Centering text by adjusting left padding
                child: Container(
                  width: screenWidth * 0.45, // 45% width of the screen
                  height: 24,
                  child: const AutoSizeText(
                    'Welcome Faruk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              // Positioned Circular Image
              if (!isCardVisible) ...[
                Positioned(
                  top: 106, // Positioned 194 pixels from the top
                  left: (screenWidth - 100) / 2, // Centered horizontally
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, // Makes the container circular
                      image: DecorationImage(
                        fit: BoxFit
                            .cover, // Ensures the image covers the container
                        image: AssetImage(
                            'assets/faruk.png'), // Load the image from assets
                      ),
                    ),
                  ),
                ),
              ],
              // "Welcome onboard" text using AutoSizeText
              Positioned(
                top: 322,
                left: 25, // Centering text by adjusting left padding
                child: Container(
                  width: 119, // 45% width of the screen
                  height: 24,
                  child: const AutoSizeText(
                    'Insuno tables',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              Positioned(
                top: 375,
                left: screenWidth * 0.06, // To achieve 88% width of the screen
                right: screenWidth * 0.06,
                bottom: 0, // Stretch down to the bottom of the screen
                child: ListView.builder(
                  itemCount: deviceCards.length,
                  itemBuilder: (context, index) {
                    return deviceCards[index];
                  },
                  padding: EdgeInsets.zero, // Remove default padding
                ),
              ),
              Positioned(
                right: 30, // Adjusted as needed from the right edge
                top: 322, // Adjusted as needed from the bottom edge
                child: InkWell(
                  onTap: () {
                    toggleCard(); // Action to toggle card visibility
                  },
                  child: Icon(
                    Icons.more_vert, // Three horizontal dots icon
                    size: 35, // Adjust the size as needed
                    color: Color(0xFFF06E33), // Adjust the color as needed
                  ),
                ),
              ),

              // The toggleable card
              if (isCardVisible) ...[
                Positioned.fill(
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.6), // Black color with 60% opacity
                  ),
                ),
                Positioned(
                  top: 117,
                  left:
                      screenWidth * 0.025, // To achieve 95% width of the screen
                  right: screenWidth * 0.025,
                  bottom: -15,
                  child: Card(
                    color: Color(0xFFFFFFFF), // Card background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13), // Corner radius
                    ),
                    child: Container(
                      height: 737, // Card height
                      child: ListView(
                        // Remove padding if needed
                        padding: EdgeInsets.zero,
                        children: [
                          // Profile picture and name
                          Padding(
                            padding: EdgeInsets.only(
                              left: 30.0,
                              top: 16.0,
                              bottom: 16.0,
                            ), // Add left padding
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Shadow color with some transparency
                                        spreadRadius: 1, // Spread radius
                                        blurRadius: 2, // Blur radius
                                        offset: Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/faruk.png'), // Replace with your profile image URL
                                    radius: 25, // Adjust the size as needed
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left: 16.0),
                                  child: Text(
                                    'Faruk',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Spacer(), // This will push the SVG icon to the end of the row
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.05), // 5% padding from the right
                                  child: GestureDetector(
                                    onTap: () {
                                      toggleCard(); // Toggle card visibility
                                    },
                                    child: SvgPicture.asset(
                                      'assets/x.svg',
                                      width: 27.0,
                                      height: 27.0,
                                    ),
                                  ),
                                ),
                                // Line separating profile from settings
                              ],
                            ),
                          ),
                          Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.9, // 90% of the available width
                              child: Divider(
                                color: const Color.fromARGB(255, 211, 210, 210),
                                thickness:
                                    1, // Optional: Sets the thickness of the divider
                              ),
                            ),
                          ),
                          // Group 1
                          // SizedBox as a spacer
                          SizedBox(
                              height:
                                  15), // Adjust the height for desired spacing
                          ListTile(
                            title: Text(
                              'Configuration',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 211, 210, 210)),
                            ),
                            enabled: false, // Make ListTile unclickable
                          ),
                          ListTile(
                            title: Text("Configure WiFi"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfigureInsunoSplash(
                                        destination: ConfigureWiFi())),
                              );
                            },
                          ),
                          ListTile(
                            title: Text("Configure AP"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfigureInsunoSplash(
                                        destination: ConfigureAP())),
                              );
                            },
                          ),
                          ListTile(
                            title: Text("Reboot"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfigureInsunoSplash(
                                        destination: ConfigureReboot())),
                              );
                            },
                          ),
                          Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.9, // 90% of the available width
                              child: Divider(
                                color: const Color.fromARGB(255, 211, 210, 210),
                                thickness:
                                    1, // Optional: Sets the thickness of the divider
                              ),
                            ),
                          ), // Line at the bottom of the group

                          // Group 2
                          // SizedBox as a spacer
                          SizedBox(
                              height:
                                  15), // Adjust the height for desired spacing
                          ListTile(
                            title: Text(
                              'Profile',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 211, 210, 210)),
                            ),
                            enabled: false, // Make ListTile unclickable
                          ),
                          ListTile(
                            title: Text('Log Out'),
                            onTap: () {
                              // Implement navigation or functionality for each item
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                          ), // Line at the bottom of the group

                          // Add more groups as needed
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
