import 'package:flutter/material.dart';
import 'package:sidoktan/Widgets/chatbot_card.dart';
import 'package:sidoktan/Widgets/text_box.dart';
import 'package:sidoktan/pages/chat_screen.dart';

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

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
        ), // Judul (header) halaman
      ),
      body: ListView(
        children: <Widget>[
          ChatBotBox(
            imagePath: 'assets/images/kattan.png',
            title: 'Ask Dok-Tan',
            subtitle: 'Dok-Tan: Your Virtual Plant Health Advisor',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
          const TextBox(
            title: 'About Dok-Tan',
            subtitle:
                'Dok-Tan serves as your comprehensive and reliable virtual plant health advisor, providing expert insights, personalized recommendations, and detailed analyses to help you effectively monitor, diagnose, and manage your plants well-being, ensuring optimal growth and vitality for your botanical companions.',
          ),
        ],
      ),
    );
  }
}
