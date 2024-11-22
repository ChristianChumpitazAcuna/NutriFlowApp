import 'package:flutter/material.dart';
import 'package:myapp/widgets/searchBarWidget.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(232, 0, 0, 0),
      child: const Column(
        children: [SearchBarWidget()],
      ),
    );
  }
}
