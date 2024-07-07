import 'package:flutter/material.dart';
import 'package:sidoktan/pages/chatbot/chatbot_page.dart';
import 'package:sidoktan/pages/iotlink/iotlink_page.dart';
import 'package:sidoktan/pages/settings/settings_page.dart';
import 'package:sidoktan/Widgets/bottom_navbar.dart';
import 'package:sidoktan/pages/detection/detection_page.dart';
import 'package:sidoktan/pages/post/post_page.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    // const HomePage(),
    const PostPage(),
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
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: SizedBox(
        width: 60, // Adjust the width
        height: 60, // Adjust the height
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanPage()),
            );
          },
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
