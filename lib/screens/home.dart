import 'package:flutter/material.dart';
import 'package:recipe_app/screens/detailscreen.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  String _dish = 'pasta';
  Map<String, dynamic>? _recipe;
  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final recipe = await _recipeService.fetchRecipe(_dish);
      setState(() {
        _recipe = recipe;
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          title: const Text('Recipe App',style: TextStyle(fontWeight: FontWeight.w900),),
        ),
        body: Column(
          children: [
            TypeAheadField(
              suggestionsCallback: (search) async {
                return await _recipeService.fetchrecipeSuggestions(search);
                
              },
              builder: (context, controller, focusNode) {
                return Padding(
                  padding: const EdgeInsets.only(top: 18, right: 15, left: 15),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      labelText: 'Search',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _dish = value;
                      });
                      fetchData();
                    },
                  ),
                );
              },
             itemBuilder: (context, suggestion) {
          final imageUrl = suggestion['image'] as String?;
            final title = suggestion['title'] as String?;

             return ListTile(
            leading: imageUrl != null
                 ? Image.network(imageUrl)
                 : const Icon(Icons.image_not_supported),  // Fallback for missing images
                    title: Text(title ?? 'No title available'),  // Fallback for missing title
  );
},

             onSelected: (suggestion) {
  final recipeId = suggestion['id'] as int?;
  
  if (recipeId != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailsScreen(recipeId: recipeId),
      ),
    );
  } else {
    // Handle the case where the selected suggestion has no valid id
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe ID is missing')),
    );
  }
},

            ),
            const SizedBox(
              height: 20,
            ),
            _recipe == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: _recipe?['results']?.length ?? 0,
                        itemBuilder: (context, index) {
                          final recipe = _recipe?['results'][index];
                          return ListTile(
                            title: Text(recipe['title']),
                            subtitle: Text('ID: ${recipe['id']}'),
                            leading: Image.network(
                              recipe['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailsScreen(
                                        recipeId: recipe['id']),
                                  ));
                            },
                          );
                        }))
          ],
        ),
      ),
    );
  }
}
