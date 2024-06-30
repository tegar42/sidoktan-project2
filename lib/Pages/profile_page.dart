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
  bool _loading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      final user = await _userService.getUser(widget.userId);
      setState(() {
        _user = user['data'];
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _errorMessage = 'Failed to fetch user data. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF5B5CDB)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchUser,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _user != null
                  ? Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 150,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/background-scan.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  _userService
                                      .getProfileImageUrl(_user!['foto']),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${_user!['nama']}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${_user!['deskripsi']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons
                                        .location_on, // Use any icon you prefer
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                      width:
                                          4), // Add some space between the icon and the text
                                  Text(
                                    _user!['wilayah'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.eco, // Use any icon you prefer
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                      width:
                                          4), // Add some space between the icon and the text
                                  Text(
                                    _user!['alamat'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('No user data found.'),
                    ),
    );
  }
}
