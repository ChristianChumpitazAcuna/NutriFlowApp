import 'package:flutter/material.dart';

class MenuBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MenuBarWidget(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMenuItem(
            icon: Icons.home_outlined,
            index: 0,
          ),
          _buildMenuItem(
            icon: Icons.grid_view_rounded,
            index: 1,
          ),
          _buildMainButton(index: 2),
          _buildMenuItem(
            icon: Icons.favorite_outline,
            index: 3,
          ),
          _buildMenuItem(
            icon: Icons.person_3_outlined,
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required int index}) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(icon,
            color: selectedIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            size: 20),
      ),
    );
  }

  Widget _buildMainButton({required int index}) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.symmetric(
              horizontal: BorderSide(
                color: const Color.fromARGB(255, 17, 0, 255).withOpacity(0.5),
                width: 4,
              ),
            )),
        child: const Icon(
          Icons.add, // Ícono central
          color: Colors.black,
          size: 25,
        ),
      ),
    );
  }
}
