import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecipeDetailScreen extends StatelessWidget {
  final dynamic recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    List<dynamic>? ingredients = recipe['extendedIngredients'];
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
                icon: Icon(MdiIcons.potMix),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Text(recipe['title']),
            backgroundColor: Colors.lightBlue,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe['image'] != null) Image.network(recipe['image']),
              SizedBox(height: 16.0),
              Text('Ingredients',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (ingredients != null && ingredients.isNotEmpty)
                ...ingredients.map<Widget>((ingredient) {
                  return Text(
                      '- ${ingredient['original'] ?? 'No description available'}');
                }).toList()
              else
                Text('No ingredients available'),
              SizedBox(height: 16.0),
              Text('Instructions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(recipe['instructions'] ?? 'No instructions available'),
            ],
          ),
        ),
      ),
    );
  }
}
