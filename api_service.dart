import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = '';
  static const String baseUrl = 'https://api.spoonacular.com';

  Future<List<dynamic>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recipes/complexSearch?query=$query&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<dynamic> getRecipeDetails(int id) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/recipes/$id/information?includeNutrition=false&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}
