import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/views/recipeDetailsScreen.dart';

class UserRecipesWidget extends StatefulWidget {
  final List<RecipeDto> recipes;
  final VoidCallback onRefresh;

  const UserRecipesWidget(
      {super.key, required this.recipes, required this.onRefresh});

  @override
  State<UserRecipesWidget> createState() => _UserRecipesWidgetState();
}

class _UserRecipesWidgetState extends State<UserRecipesWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.5,
          mainAxisSpacing: 1.5,
          childAspectRatio: 0.75,
        ),
        itemCount: widget.recipes.length,
        itemBuilder: (context, index) {
          final recipe = widget.recipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeDetailsScreen(
                            recipe: recipe,
                            isCurrentUser: true,
                            onRefresh: widget.onRefresh,
                          )));
            },
            child: CachedNetworkImage(
              imageUrl: recipe.imageUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  color: Colors.amber,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        });
  }
}
