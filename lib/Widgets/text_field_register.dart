import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      required this.obscureText});
  // const MyTextField({
  //   Key? key,
  //   required this.controller,
  //   required this.labelText,
  //   required this.hintText,
  //   required this.obscureText,
  // }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
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
            ],
          ),
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: widget.controller,
              obscureText: _obscureText && widget.obscureText,
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
                    vertical: 10.0, horizontal: 20.0),
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
            if (widget.obscureText) // Show eye icon only for password field
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
