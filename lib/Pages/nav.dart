import 'package:flutter/material.dart';
import 'package:sidoktan/Pages/chatbot_page.dart';
import 'package:sidoktan/Pages/iotlink_page.dart';
import 'package:sidoktan/Pages/setting_page.dart';
import 'package:sidoktan/Widgets/bottom_navbar.dart';
// import 'package:sidoktan/pages/scan_menu.dart';
// import 'package:sidoktan/pages/settings_page.dart';
import 'package:sidoktan/pages/home_page.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const ChatBotPage(),
    const IotlinkPage(),
    const SettingsPage(),
  ];

  // Handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 60.0,
        child: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60, // Adjust the width
        height: 60, // Adjust the height
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF5B5CDB),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
              side: const BorderSide(color: Color(0xFF8889F0), width: 2.0)),
          child: const Icon(
            Icons.center_focus_strong,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
