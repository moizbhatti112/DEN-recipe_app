import 'package:flutter/material.dart';
import 'package:recipe_app/services/recipe_service.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailsScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final RecipeService _recipeService = RecipeService();
  Map<String, dynamic>? _recipeDetails;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      final details = await _recipeService.fetchRecipeDetails(widget.recipeId);
      setState(() {
        _recipeDetails = details;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(_recipeDetails?['title'] ?? 'Loading...'),
        ),
        body: _recipeDetails == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(_recipeDetails!['image']),
                      const SizedBox(height: 10),
                      Text(
                        _recipeDetails!['title'],
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('Ready in ${_recipeDetails!['readyInMinutes']} minutes'),
                      const SizedBox(height: 10),
                      Text('Servings: ${_recipeDetails!['servings']}'),
                      const SizedBox(height: 20),
                      const Text(
                        'Ingredients',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ..._recipeDetails!['extendedIngredients'].map<Widget>((ingredient) {
                        return Text('- ${ingredient['original']}');
                      }).toList(),
                      const SizedBox(height: 20),
                      const Text(
                        'Instructions',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(_recipeDetails!['instructions'] ?? 'No instructions available.'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
