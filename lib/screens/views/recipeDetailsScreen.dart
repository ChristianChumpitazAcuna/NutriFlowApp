import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/main/widgets/avatarWidget.dart';
import 'package:myapp/screens/views/userProfileView.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final RecipeDto recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        splashColor: Colors.white,
        backgroundColor: const Color.fromARGB(195, 255, 255, 255),
        onPressed: () {
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Iconsax.arrow_left_2,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
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
                  height: 300,
                  width: screenWidth,
                ),
                Container(
                  height: 301,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black12,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        GestureDetector(
                            onTap: () {
                              final userId = recipe.userId.id;
                              if (userId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfileView(userId: userId),
                                  ),
                                );
                              } else {
                                return;
                              }
                            },
                            child: ClipOval(
                                child: CachedNetworkImage(
                              imageUrl: recipe.userId.avatarUrl,
                              height: screenHeight / 20,
                              fit: BoxFit.cover,
                            )))
                      ],
                    ),
                    Row(
                      children: [
                        Row(children: [
                          const Icon(
                            Icons.timelapse_rounded,
                            color: Colors.white54,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipe.time,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white54),
                          ),
                        ]),
                        const SizedBox(width: 20),
                        Row(children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white54,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipe.servings.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white54),
                          ),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Ingredientes",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            recipe.ingredients.length,
                            (index) => Text(
                                  "- ${recipe.ingredients[index].name}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white54,
                                  ),
                                ))),
                    const SizedBox(height: 20),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          const Text(
                            "Instrucciones",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(
                            recipe.instructions.length,
                            (index) => Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(20, 182, 182, 182),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color.fromARGB(
                                        255, 143, 143, 143),
                                    radius: 15,
                                    child: Text(
                                      recipe.instructions[index].stepNumber
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(
                                    recipe.instructions[index].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white54,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ]))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
