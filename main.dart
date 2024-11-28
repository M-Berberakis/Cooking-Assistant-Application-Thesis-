import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for input formatters
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'; // Import the package
import 'temp.dart'; // Import the NewScreen
import 'recipe_request.dart'; // Import the RecipeRequestScreen

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  String? _unitFromDropdownValue;
  String? _unitToDropdownValue;
  String? _materialDropdownValue; // Variable for the third dropdown

  final Map<String, double> _ingredientDensities = {
    'Flour': 0.53, // density in g/mL
    'Sugar': 0.85,
    'Salt': 1.2,
    'Water': 1.0,
    'Oil': 0.92,
    'Butter': 0.911,
  };

  @override
  void dispose() {
    _amountController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            leading: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(MdiIcons.thermometer),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewScreen()),
                  );
                },
              ),
            ),
            title: const Text("Unit Conversion"),
            centerTitle: true,
            backgroundColor:
                Colors.lightBlue, // Set the AppBar color to light blue
            actions: [
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(MdiIcons.potMix),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 30),
            DropdownButton<String>(
              value: _unitFromDropdownValue,
              hint: const Text('From Unit'),
              onChanged: (value) =>
                  setState(() => _unitFromDropdownValue = value),
              items: [
                'KG',
                'Grams',
                'L',
                'mL',
                'Cups',
                'oZ',
                'Gal',
                'Tbsp',
                'Tsp',
                'Lbs',
                'Dram',
                'Oka'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            DropdownButton<String>(
              value: _unitToDropdownValue,
              hint: const Text('To Unit'),
              onChanged: (value) =>
                  setState(() => _unitToDropdownValue = value),
              items: [
                'KG',
                'Grams',
                'L',
                'mL',
                'Cups',
                'oZ',
                'Gal',
                'Tbsp',
                'Tsp',
                'Lbs',
                'Dram',
                'Oka'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            DropdownButton<String>(
              value: _materialDropdownValue,
              hint: const Text('Select Material'),
              onChanged: (value) =>
                  setState(() => _materialDropdownValue = value),
              items: _ingredientDensities.keys
                  .map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateResult,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _resultController,
              decoration: const InputDecoration(
                labelText: 'Result',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  void _updateResult() {
    if (_amountController.text.isEmpty ||
        _unitFromDropdownValue == null ||
        _unitToDropdownValue == null ||
        _materialDropdownValue == null) {
      _resultController.text = 'Invalid input';
      return;
    }

    double input = double.tryParse(_amountController.text) ?? 0.0;
    double density = _ingredientDensities[_materialDropdownValue!] ??
        1.0; // Default to density of water if not found
    double result = 0.0;

    // Convert the input amount to grams if necessary
    double amountInGrams = input;
    if (_unitFromDropdownValue != 'Grams') {
      amountInGrams = _convertToGrams(input, _unitFromDropdownValue!, density);
    }

    // Convert the amount in grams to the desired unit
    result = _convertFromGrams(amountInGrams, _unitToDropdownValue!, density);

    _resultController.text = result.toStringAsFixed(2);
  }

  double _convertToGrams(double amount, String unit, double density) {
    switch (unit) {
      case 'Cups':
        return amount * 236.588 * density;
      case 'oZ':
        return amount * 28.3495;
      case 'Gal':
        return amount * 3785.41 * density;
      case 'Tbsp':
        return amount * 14.7868 * density;
      case 'Tsp':
        return amount * 4.92892 * density;
      case 'Dram':
        return amount * 1.77185;
      case 'Oka':
        return amount * 1282.0;
      case 'L':
        return amount * 1000.0 * density;
      case 'KG':
        return amount * 1000.0;
      case 'Lbs':
        return amount * 453.592;
      default:
        return amount; // Assume unit is already Grams
    }
  }

  double _convertFromGrams(double amountInGrams, String unit, double density) {
    switch (unit) {
      case 'Cups':
        return amountInGrams / (236.588 * density);
      case 'oZ':
        return amountInGrams / 28.3495;
      case 'Gal':
        return amountInGrams / (3785.41 * density);
      case 'Tbsp':
        return amountInGrams / (14.7868 * density);
      case 'Tsp':
        return amountInGrams / (4.92892 * density);
      case 'Dram':
        return amountInGrams / 1.77185;
      case 'Oka':
        return amountInGrams / 1282.0;
      case 'L':
        return amountInGrams / (1000.0 * density);
      case 'KG':
        return amountInGrams / 1000.0;
      case 'Lbs':
        return amountInGrams / 453.592;
      default:
        return amountInGrams; // Assume unit is already Grams
    }
  }
}
