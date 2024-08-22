import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeService {
  String apiKey = '828a9a6d41ad4bb3a0ca28644e1b4fc8';
  String searchBaseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
  String detailsBaseUrl = 'https://api.spoonacular.com/recipes';
  Future<Map<String, dynamic>> fetchRecipe(String dish) async {
    final url = '$searchBaseUrl?apiKey=$apiKey&query=$dish&number=5';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch recipe');
    }
  }

  // Fetch detailed information about a recipe by its ID
  Future<Map<String, dynamic>> fetchRecipeDetails(int id) async {
    final url = '$detailsBaseUrl/$id/information?apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch recipe details');
    }
  }

  Future<List<dynamic>?> fetchrecipeSuggestions(String query) async {
    final url = '$searchBaseUrl?apiKey=$apiKey&query=$query&numer=5';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      return null;
    }
  }
}
