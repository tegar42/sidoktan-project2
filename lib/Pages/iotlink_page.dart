import 'package:flutter/material.dart';

class IotlinkPage extends StatelessWidget {
  const IotlinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IoT Integration",
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF5B5CDB), // Ubah warna ikon di sini
            ),
            onSelected: (value) {
              // Handle dropdown menu item selection here
              if (value == 'API Management') {
                // Navigate to API Management screen or perform related action
              } else if (value == 'UI Management') {
                // Navigate to UI Management screen or perform related action
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'API Management',
                height: 20,
                child: Text(
                  'API Management',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'UI Management',
                height: 20,
                child: Text(
                  'UI Management',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Center(child: Text("IoT")),
    );
  }
}
