import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Home',
              index: 0,
              iconSize: 26.0),
          _buildNavItem(
              icon: Icons.chat_outlined,
              selectedIcon: Icons.chat,
              label: 'ChatBot',
              index: 1,
              iconSize: 26.0),
          const SizedBox(width: 20),
          _buildNavItem(
              icon: Icons.link,
              selectedIcon: Icons.link,
              label: 'IoT Link',
              index: 2,
              iconSize: 26.0),
          _buildNavItem(
              icon: Icons.person_rounded,
              selectedIcon: Icons.person_rounded,
              label: 'Setting',
              index: 3,
              iconSize: 26.0),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required double iconSize,
  }) {
    return InkWell(
      onTap: () => onItemTapped(index),
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: 80, // Adjust the width as needed
        height: 100, // Adjust the height as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              selectedIndex == index ? selectedIcon : icon,
              color: selectedIndex == index
                  ? const Color(0xFF5B5CDB)
                  : Colors.grey,
              size: iconSize,
            ),
            Text(
              label,
              style: TextStyle(
                color: selectedIndex == index
                    ? const Color(0xFF5B5CDB)
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
