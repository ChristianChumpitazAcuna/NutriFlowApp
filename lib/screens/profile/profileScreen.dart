import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/screens/profile/widgets/userRecipesWidget.dart';
import 'package:myapp/services/auth/authService.dart';
import 'package:myapp/screens/loginScreen.dart';
import 'package:myapp/screens/profile/widgets/userInfoWidget.dart';
import 'package:myapp/services/recipeService.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class UserData {
  final String displayName;
  final String email;
  final String photoUrl;

  UserData({
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final RecipeService _recipeService = RecipeService();
  List<RecipeDto> recipes = [];
  bool _isLoading = false;
  UserData? userData;
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _loadUserData();
      await _getUserId();
      await _fetchRecipes();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> _getUserId() async {
    try {
      final id = await _authService.getUserId();
      setState(() {
        _userId = id;
      });

      print('userId : $_userId');

      return id;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _fetchRecipes() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final data = await _recipeService.getByUser(_userId, 'active');

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

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _authService.getUserData();
      setState(() {
        userData = UserData(
            displayName: user['displayName']!,
            email: user['email']!,
            photoUrl: user['photoUrl']!);
      });
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signOut();
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LogInScreen()),
      );
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                  height: screenHeight / 3,
                  width: screenWidth,
                  child: UserInfoWidget(
                      displayName: userData!.displayName,
                      email: userData!.email,
                      photoUrl: userData!.photoUrl)),
              Expanded(
                  child: Container(
                      color: const Color.fromARGB(255, 12, 12, 12),
                      child: _isLoading
                          ? Center(
                              child: LoadingAnimationWidget.dotsTriangle(
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                          : UserRecipesWidget(recipes: recipes))),
            ],
          ),
          Positioned(
              top: 25,
              right: 10,
              child: IconButton(
                onPressed: _showMenuOptions,
                icon: const Icon(Iconsax.setting),
                color: Colors.white,
              ))
        ]));
  }

  void _showMenuOptions() {
    WoltModalSheet.show(
        context: context,
        pageListBuilder: (context) => [
              WoltModalSheetPage(
                  backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ListTile(
                        //   leading: const Icon(
                        //     Iconsax.setting_2,
                        //     color: Colors.white,
                        //   ),
                        //   title: const Text(
                        //     'Configuración',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   onTap: () {
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                        ListTile(
                          leading: const Icon(
                            Iconsax.logout,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Cerrar sesión',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _handleLogout();
                          },
                        ),
                      ]))
            ]);
  }
}
