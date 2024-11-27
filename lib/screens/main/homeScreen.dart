import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/views/recipeDetailsScreen.dart';
import 'package:myapp/screens/main/widgets/avatarWidget.dart';
import 'package:myapp/screens/main/widgets/descriptionWidget.dart';
import 'package:myapp/screens/views/userProfileView.dart';
import 'package:myapp/services/recipeService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  List<RecipeDto> recipes = [];
  int currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
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
      });
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      if (_isLoading)
        Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: LoadingAnimationWidget.dotsTriangle(
              color: Colors.white,
              size: 40,
            ),
          ),
        )
      else if (recipes.isEmpty)
        const Center(
          child: Text(
            "No hay recetas disponibles",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        )
      else
        Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailsScreen(recipe: recipe),
                            ),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
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
                              // width: double.infinity,
                              // height: double.infinity,
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: DescriptionWidget(
                                  name: recipe.name,
                                  description: recipe.description,
                                  screenWidth: screenWidth,
                                ))
                          ],
                        ),
                      );
                    },
                    itemCount: recipes.length,
                    itemWidth: 380,
                    itemHeight: 500,
                    layout: SwiperLayout.DEFAULT,
                    scrollDirection: Axis.vertical,
                    onIndexChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                )
              ],
            ),
            Positioned(
              top: 50,
              right: 10,
              child: GestureDetector(
                  onTap: () {
                    final userId = recipes[currentIndex].userId.id;
                    if (userId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileView(userId: userId),
                        ),
                      );
                    } else {
                      return;
                    }
                  },
                  child: AvatarWidget(
                      avatar: recipes[currentIndex].userId.avatarUrl,
                      displayName: recipes[currentIndex].userId.displayName)),
            )
          ],
        ),
    ]);
  }
}
