import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/views/userProfileView.dart';
import 'package:myapp/services/notificationService.dart';
import 'package:myapp/services/recipeService.dart';
import 'package:toastification/toastification.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final RecipeDto recipe;
  final bool? isCurrentUser;
  final VoidCallback? onRefresh;

  const RecipeDetailsScreen(
      {super.key, required this.recipe, this.isCurrentUser, this.onRefresh});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late RecipeDto recipe;
  late bool isCurrentUser;
  final RecipeService _recipeService = RecipeService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
    isCurrentUser = widget.isCurrentUser ?? false;
  }

  Future<void> _handleDelete(BuildContext context, int id) async {
    try {
      await _recipeService.changeStatus(id, 'delete');
      widget.onRefresh!();
      if (context.mounted == false) return;
      _notificationService.showNotification(
          context: context,
          message: 'Registro Eliminado',
          type: ToastificationType.success,
          
          duration: Duration(seconds: 3));

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
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
                                      color: const Color.fromARGB(
                                          20, 182, 182, 182),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 143, 143, 143),
                                          radius: 15,
                                          child: Text(
                                            recipe
                                                .instructions[index].stepNumber
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
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
            if (isCurrentUser)
              Positioned(
                  top: 20,
                  right: 2,
                  child: IconButton(
                      onPressed: () {
                        _showMenuOptions(context, recipe.id);
                      },
                      icon: Icon(
                        Iconsax.more,
                        color: Colors.white,
                      )))
          ],
        ));
  }

  void _showMenuOptions(BuildContext context, int recipeId) {
    WoltModalSheet.show(
        context: context,
        pageListBuilder: (context) => [
              WoltModalSheetPage(
                  backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirmación"),
                                      content: const Text(
                                          "¿Estás seguro de que quieres eliminar esta receta?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _handleDelete(context, recipe.id);
                                          },
                                          child: const Text("Eliminar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Icon(
                                    Iconsax.trash,
                                    color: Colors.redAccent,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Eliminar",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
                  ))
            ]);
  }
}
