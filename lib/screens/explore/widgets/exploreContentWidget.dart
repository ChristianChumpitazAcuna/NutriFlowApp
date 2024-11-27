import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/views/recipeDetailsScreen.dart';

class ExploreContentWidget extends StatelessWidget {
  final List<RecipeDto> recipes;
  const ExploreContentWidget({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1.5,
          mainAxisSpacing: 1.5,
          childAspectRatio: 0.8,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailsScreen(recipe: recipe)));
              },
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: Colors.amber,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        recipe.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(
                        recipe.userId.avatarUrl,
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}
