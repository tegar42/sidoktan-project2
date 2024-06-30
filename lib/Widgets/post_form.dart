import 'package:flutter/material.dart';
import 'dart:io';

class PostFormWidget extends StatelessWidget {
  final TextEditingController postController;
  final VoidCallback pickImageFromCamera;
  final VoidCallback pickImageFromGallery;
  final VoidCallback addPost;
  final bool hasImage;
  final File? image;

  const PostFormWidget({
    super.key,
    required this.postController,
    required this.pickImageFromCamera,
    required this.pickImageFromGallery,
    required this.addPost,
    required this.hasImage,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: CircleAvatar(
                  radius: 20,
                  // Example image, replace with your own logic to get user profile picture
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    TextFormField(
                      controller: postController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'What are you thinking right now?',
                        hintStyle: const TextStyle(fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.camera_alt, size: 20),
                                onPressed: pickImageFromCamera,
                              ),
                              IconButton(
                                icon: const Icon(Icons.photo, size: 20),
                                onPressed: pickImageFromGallery,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: addPost,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              backgroundColor: const Color(0xFF5B5CDB),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(100, 30),
                            ),
                            child: const Text('Post'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasImage && image != null) ...[
            const SizedBox(height: 10),
            Image.file(image!),
          ],
        ],
      ),
    );
  }
}
