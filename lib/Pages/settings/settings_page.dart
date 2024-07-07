import 'package:flutter/material.dart';
import 'package:sidoktan/Widgets/setting_items.dart';
import 'package:sidoktan/pages/settings/set_profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "siDokTan",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'DMSerifDisplay',
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            color: Colors.grey, // Ubah warna sesuai kebutuhan
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SettingItem(
            icon: Icons.person_outlined,
            title: 'Account Information',
            subtitle:
                'Set your account like your username, phone number, and email address',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetProfile()),
              );
            },
          ),
          SettingItem(
            icon: Icons.logout_sharp,
            title: 'Logout',
            subtitle: 'Log out of your account',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
