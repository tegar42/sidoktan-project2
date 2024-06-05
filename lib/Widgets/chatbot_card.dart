import 'package:flutter/material.dart';

class ChatBotBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ChatBotBox({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: const Color(0xFF5B5CDB),
          child: CircleAvatar(
            radius: 24.0,
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF5B5CDB),
            fontFamily: "DMSans",
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'DMSans',
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
