import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap, // Aksi ketika card di-click
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 10.0,
          ), // Menambahkan padding langsung pada ListTile
          leading: Icon(
            icon,
            color: const Color(0xFF5B5CDB),
            size: 50.0,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5B5CDB),
              fontFamily: "DMSans",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, fontFamily: 'DMSans'),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
