import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_service.dart'; // Import the ApiService
import 'temp.dart'; // Import the NewScreen
import 'main.dart'; // Import the HomeScreen
import 'recipe_details.dart'; // Import the RecipeDetailScreen

class RecipeRequestScreen extends StatefulWidget {
  @override
  _RecipeRequestScreenState createState() => _RecipeRequestScreenState();
}

class _RecipeRequestScreenState extends State<RecipeRequestScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;

  void _searchRecipes() async {
    setState(() {
      _isLoading = true;
    });

    final ApiService apiService = ApiService();
    try {
      final List<dynamic> recipes =
          await apiService.searchRecipes(_searchController.text);
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
      print('Recipes: $recipes'); // Debug statement
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e'); // Debug statement
      _showErrorDialog('Failed to load recipes: $e');
    }
  }

  void _onRecipeTap(int recipeId) async {
    final ApiService apiService = ApiService();
    try {
      final recipeDetails = await apiService.getRecipeDetails(recipeId);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipeDetails)),
      );
    } catch (e) {
      print('Error: $e'); // Debug statement
      _showErrorDialog('Failed to load recipe details: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                icon: Icon(Icons.scale),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
            ),
            title: const Text("Recipes"),
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
                  icon: Icon(Icons.thermostat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewScreen()),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'[a-zA-Z\s]')), // Only allow letters and spaces
                    ],
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _searchRecipes,
                  child: Text('Search'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_recipes[index]['title']),
                    onTap: () =>
                        _onRecipeTap(_recipes[index]['id']), // Handle item tap
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
