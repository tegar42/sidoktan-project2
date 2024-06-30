import 'package:flutter/material.dart';
import 'package:sidoktan/services/user_service.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await _userService.getUser(widget.userId);
      setState(() {
        _user = user['data'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Image.network(_userService.getProfileImageUrl(_user!['foto'])),
                Text('Name: ${_user!['nama']}'),
                Text('Email: ${_user!['email']}'),
                // Add more fields as needed
              ],
            ),
    );
  }
}
