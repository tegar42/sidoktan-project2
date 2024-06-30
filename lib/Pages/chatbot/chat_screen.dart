import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, dynamic>> _messages = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    setState(() {
      _messages.add({"message": message, "isUser": true});
      _isProcessing = true;
    });
    _controller.clear();
    _getResponse(message);
  }

  void _getResponse(String message) async {
    // Simulate delay before responding
    await Future.delayed(const Duration(seconds: 2));
    String response = _simulateResponse(message);
    setState(() {
      _messages.add({"message": response, "isUser": false});
      _isProcessing = false;
    });
    _focusNode.requestFocus();
  }

  String _simulateResponse(String message) {
    // This is the simulated data we use to respond to the user's message
    if (message.toLowerCase().contains("siapa kamu")) {
      return "Halo! Aku Dok-tan. Ada yang bisa saya bantu?";
    } else if (message.toLowerCase().contains("cuaca")) {
      return "Cuaca hari ini cerah!";
    } else if (message.toLowerCase().contains("nama")) {
      return "Nama saya Chatbot Simulasi.";
    } else {
      return "Maaf, saya tidak mengerti.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dok-Tan",
          style: TextStyle(color: Color(0xFF5B5CDB)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF5B5CDB)),
          onPressed: () {
            Navigator.pop(
                context); // Menambahkan fungsi untuk kembali ke halaman sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF5B5CDB)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: _messages[index]['isUser']
                      ? null
                      : const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/kattan.png'),
                        ),
                  trailing: _messages[index]['isUser']
                      ? const CircleAvatar(
                          backgroundImage: AssetImage('assets/user_avatar.png'),
                        )
                      : null,
                  title: Align(
                    alignment: _messages[index]['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: _messages[index]['isUser']
                            ? Colors.white
                            : const Color.fromARGB(255, 210, 210, 251),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        _messages[index]['message'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Input message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: (text) => _sendMessage(text),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF5B5CDB)),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
