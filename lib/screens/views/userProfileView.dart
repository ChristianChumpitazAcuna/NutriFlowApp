import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/profile/widgets/userInfoWidget.dart';
import 'package:myapp/screens/profile/widgets/userRecipesWidget.dart';
import 'package:myapp/services/recipeService.dart';

class UserProfileView extends StatefulWidget {
  final int userId;
  const UserProfileView({super.key, required this.userId});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final RecipeService _recipeService = RecipeService();
  List<RecipeDto> recipes = [];
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

      final data = await _recipeService.getByUser(widget.userId, 'active');

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
        backgroundColor: Colors.black,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: screenHeight / 3,
                width: screenWidth,
                child: recipes.isNotEmpty
                    ? UserInfoWidget(
                        displayName: recipes[0].userId.displayName,
                        email: recipes[0].userId.email,
                        photoUrl: recipes[0].userId.avatarUrl)
                    : Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      ),
              ),
              Expanded(
                  child: Container(
                      color: const Color.fromARGB(255, 12, 12, 12),
                      child: _isLoading
                          ? LoadingAnimationWidget.dotsTriangle(
                              color: Colors.white,
                              size: 40,
                            )
                          : UserRecipesWidget(recipes: recipes))),
            ],
          ),
        ]));
  }
}
