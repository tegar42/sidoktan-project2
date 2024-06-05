import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2.5), // Added vertical padding for consistent spacing
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.labelText,
                style: const TextStyle(
                  fontFamily: 'DMSerifText-Regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF5B5CDB),
                ),
              ),
              if (widget.obscureText)
                TextButton(
                  onPressed: () {
                    // forgot password logic
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove default padding
                    minimumSize:
                        const Size(0, 0), // Remove minimum size constraints
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // Shrink to fit content
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF5B5CDB),
                      fontFamily: 'DMSerifText-Regular',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              style: const TextStyle(
                fontFamily: 'DMSerifText-Regular',
                fontSize: 16,
                color: Color(0xFF666666),
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontFamily: 'DMSerifText-Regular',
                  color: Color(0xFF959595),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC6C6C6)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5B5CDB)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            if (widget.obscureText)
              Positioned(
                right: 8.0,
                top: 12.0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
