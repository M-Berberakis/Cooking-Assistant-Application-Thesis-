import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'; // Import the package
import 'recipe_request.dart'; // Import the RecipeRequestScreen
import 'main.dart'; // Import the HomeScreen
import 'package:flutter/services.dart'; // Import the services package for input formatting

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  final double textFieldWidth = 150.0; // Set the width of the text fields
  String? _inputUnit = '°F'; // Initial value for the first dropdown
  String? _outputUnit = '°F'; // Initial value for the second dropdown

  void _convertTemperature() {
    String inputText = _inputController.text;
    if (inputText.isEmpty) return;

    double inputValue = double.tryParse(inputText) ?? 0.0;
    double outputValue;

    if (_inputUnit == _outputUnit) {
      // Do nothing if both dropdowns have the same value
      return;
    } else if (_inputUnit == '°F' && _outputUnit == '°C') {
      // Convert Fahrenheit to Celsius
      outputValue = (inputValue - 32) * 5 / 9;
    } else if (_inputUnit == '°C' && _outputUnit == '°F') {
      // Convert Celsius to Fahrenheit
      outputValue = (inputValue * 9 / 5) + 32;
    } else {
      // Default case, should not reach here
      return;
    }

    _outputController.text = outputValue.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            leading: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(Icons.scale),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
            ),
            title: const Text("Temperature Conversion"),
            centerTitle: true,
            backgroundColor:
                Colors.lightBlue, // Set the AppBar color to light blue
            actions: [
              Container(
                margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(MdiIcons.potMix), // Use the pot icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeRequestScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 50.0), // Add padding to move the text fields closer to the top
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: textFieldWidth,
                    child: TextField(
                      controller: _inputController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ], // Allow only numbers and decimal point
                      decoration: const InputDecoration(
                        labelText: 'Input',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _inputUnit,
                    items: <String>['°F', '°C']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _inputUnit = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: textFieldWidth,
                    child: TextField(
                      controller: _outputController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Output',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _outputUnit,
                    items: <String>['°F', '°C']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _outputUnit = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertTemperature,
                child: const Text('Convert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
