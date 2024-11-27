import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 12, 12, 12),
        child: const Center(
          child: Text(
            'Comming soon!',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
