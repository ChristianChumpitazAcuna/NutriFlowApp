import 'package:flutter/material.dart';
import 'package:myapp/screens/create/createScreen.dart';
import 'package:myapp/screens/favorites/favoritesScreen.dart';
import 'package:myapp/screens/explore/exploreScreen.dart';
import 'package:myapp/screens/main/homeScreen.dart';
import 'package:myapp/screens/profile/profileScreen.dart';
import 'package:myapp/widgets/menuBarWidget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const CreateScreen(),
    const FavoritesScreem(),
    const ProfileScreen()
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[selectedIndex],
        bottomNavigationBar: MenuBarWidget(
          onItemTapped: onItemTapped,
          selectedIndex: selectedIndex,
        ));
  }
}
