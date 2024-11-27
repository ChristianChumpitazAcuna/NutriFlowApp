import 'package:flutter/material.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: SearchBarAnimation(
          textEditingController: controller,
          isOriginalAnimation: true,
          enableKeyboardFocus: true,
          cursorColour: Colors.white,
          searchBoxColour: Colors.black26,
          buttonColour: Colors.black,
          enteredTextStyle: const TextStyle(color: Colors.white),
          trailingWidget: const Icon(
            Icons.search,
            size: 20,
            color: Colors.white,
          ),
          secondaryButtonWidget: const Icon(
            Icons.close,
            size: 20,
            color: Colors.white,
          ),
          buttonWidget: const Icon(
            Icons.search,
            size: 20,
            color: Colors.white,
          ),
        ));
  }
}
