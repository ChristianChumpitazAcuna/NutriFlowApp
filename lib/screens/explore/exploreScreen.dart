import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/explore/widgets/exploreContentWidget.dart';
import 'package:myapp/services/recipeService.dart';
import 'package:myapp/widgets/searchBarWidget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _searchController = TextEditingController();
  List<RecipeDto> recipes = [];
  List<RecipeDto> filterList = [];
  int currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();

    _searchController.addListener(_applyFilter);
  }

  Future<void> _fetchRecipes() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await _recipeService.getData('active');

      if (data.isEmpty) return;

      setState(() {
        recipes = data;
        filterList = data;
      });
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filterList = recipes.where((recipe) {
        return recipe.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 12, 12, 12),
        body: Column(
          children: [
            SearchBarWidget(controller: _searchController),
            Expanded(
              child: _isLoading
                  ? LoadingAnimationWidget.dotsTriangle(
                      color: Colors.white,
                      size: 40,
                    )
                  : ExploreContentWidget(recipes: filterList),
            )
          ],
        ));
  }
}
