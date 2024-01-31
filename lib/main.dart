import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import async library for Timer

void main() {
  runApp(InsunoApp());
}

class InsunoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insuno',
      home: InsunoHomePage(),
    );
  }
}

class InsunoHomePage extends StatefulWidget {
  @override
  _InsunoHomePageState createState() => _InsunoHomePageState();
}

class _InsunoHomePageState extends State<InsunoHomePage> {
  // Dummy data for current and voltage
  double? current;
  double? voltage;
  Timer? measurementsTimer;
  Timer? parametersTimer; // Timer for fetching parameters

  // Initial states for the relays
  Map<String, bool> relayStates = {
    'Wireless charger': false,
    'LED lights': false,
    'USB-c charger': false,
  };

  @override
  void initState() {
    super.initState();
    fetchMeasurements();
    measurementsTimer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => fetchMeasurements());
    fetchParameters();
    parametersTimer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => fetchParameters());
  }

  Future<void> fetchMeasurements() async {
    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/espmeasurement/databases/(default)/documents/measurements?pageSize=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final documents = data['documents'] as List;
      if (documents.isNotEmpty) {
        setState(() {
          current = documents[0]['fields']['current']['doubleValue'];
          voltage = documents[0]['fields']['voltage']['doubleValue'];
        });
      }
    } else {
      // Handle the error; for simplicity, we're just printing it
      print('Failed to load measurements: ${response.reasonPhrase}');
    }
  }

  Future<void> fetchParameters() async {
    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/espmeasurement/databases/(default)/documents/parameters'));

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
        bool state = document['fields']['state']['integerValue'] != "0";

        // Mapping the relay number to the corresponding relay in relayStates map
        switch (relayNumber) {
          case '1':
            relayStates['Wireless charger'] = state;
            break;
          case '2':
            relayStates['LED lights'] = state;
            break;
          case '3':
            relayStates['USB-c charger'] = state;
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

  @override
  void dispose() {
    measurementsTimer?.cancel();
    parametersTimer?.cancel(); // Cancel the parameters timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insuno'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Center the column's content vertically
            crossAxisAlignment: CrossAxisAlignment
                .center, // Center the column's content horizontally
            children: [
              Text('Current: $current A', style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text('Battery: $voltage V', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: relayStates.keys.map((relay) {
                    return ListTile(
                      key: ValueKey(relay),
                      title: Text(relay),
                      trailing: Switch(
                        value: relayStates[relay]!,
                        onChanged: (bool value) {
                          // Handle relay toggle
                          setState(() {
                            relayStates[relay] = value;
                          });
                          // Here you would also send a request to update the relay state
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
