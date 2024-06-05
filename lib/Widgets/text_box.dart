import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String title;
  final String subtitle;
  const TextBox({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        // Menambahkan Padding widget di sini
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0), // Mengatur padding atas dan bawah
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5B5CDB),
              fontFamily: "DMSerifText",
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 13, height: 1.5, fontFamily: 'DMSans'),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}
