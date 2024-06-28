import 'package:flutter/material.dart';
import 'package:sidoktan/Widgets/button.dart';
import 'package:sidoktan/Widgets/text_field_register.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllersw
  final usernameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up
  void signUp() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordTextController.text != confirmPasswordController.text) {
      Navigator.pop(context);

      displayMessage("Passwords don't match!");
      return;
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  // try{
  //   await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
  // }

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
                const SizedBox(height: 20),
                //logo
                _buildLogo(),

                //welcomeMessage
                _buildWelcomeMessage(),
                const SizedBox(height: 10),

                //username textField
                MyTextField(
                  controller: usernameTextController,
                  labelText: 'Username',
                  hintText: 'Create your Username',
                  obscureText: false,
                ),
                const SizedBox(height: 5),
                //Email textField
                MyTextField(
                  controller: emailTextController,
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                  obscureText: false,
                ),
                const SizedBox(height: 5),
                //Password textField
                MyTextField(
                  controller: passwordTextController,
                  labelText: 'Password',
                  hintText: 'Create your Password',
                  obscureText: true,
                ),
                const SizedBox(height: 5),
                MyTextField(
                  controller: confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                // Button
                MyButton(
                  onTap: () {},
                  text: "Sign Up",
                ),

                const SizedBox(height: 10),

                // Go to Registr
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an Account?",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: "DMSerifText-Regular",
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: "DMSerifText-Regular",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B5CDB),
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
            "Register",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 26,
              color: Color(0xFF666666),
              fontFamily: 'DMSerifText',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Let's create your account",
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
