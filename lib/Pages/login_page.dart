import 'package:flutter/material.dart';
import 'package:sidoktan/Widgets/text_field.dart';
import 'package:sidoktan/Widgets/button.dart';
import 'package:sidoktan/Models/user_model.dart';
import 'package:sidoktan/Pages/nav.dart'; // Import the User model

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Simulated user model
  final List<User> simulatedUsers = [
    User(
      username: 'testuser',
      profilePictureUrl: 'https://example.com/profile.jpg',
      email: 'test@example.com',
      password: 'password123',
    ),
    User(
      username: 'user2',
      profilePictureUrl: 'https://example.com/profile2.jpg',
      email: 'user2@example.com',
      password: 'mypassword',
    ),
  ];

  // display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  // Handle sign-in
  void handleSignIn() {
    String email = emailTextController.text.trim();
    String password = passwordTextController.text.trim();

    // Check if user exists
    User? user = simulatedUsers.firstWhereOrNull(
        (user) => user.email == email && user.password == password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Nav()), // Ganti Navpage dengan halaman navigasi yang benar
      );
    } else {
      displayMessage("Invalid email or password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF6F5FA),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                //logo
                _buildLogo(),

                //welcomeMessage
                _buildWelcomeMessage(),
                const SizedBox(height: 25),

                //Email textField
                MyTextField(
                  controller: emailTextController,
                  labelText: 'Email',
                  hintText: 'Enter Your Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //Password textField
                MyTextField(
                  controller: passwordTextController,
                  labelText: 'Password',
                  hintText: 'Please Enter Your Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                // Button
                MyButton(
                  onTap: handleSignIn,
                  text: "Sign In",
                ),

                const SizedBox(height: 10),

                // Go to Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New on our platform?",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: "DMSans",
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Create an account",
                        style: TextStyle(
                          fontFamily: "DMSans",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B5CDB),
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/sidoktan-logo.png',
      color: const Color(0xFF5B5CDB),
      width: 160,
      height: 80,
    );
  }

  Widget _buildWelcomeMessage() {
    return const SizedBox(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to SiDokTan 👋",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 26,
              color: Color(0xFF666666),
              fontFamily: 'DMSerifDisplay',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Please Sign-in to your account",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999EA1),
              fontFamily: 'DMSans',
            ),
          ),
        ],
      ),
    );
  }
}
