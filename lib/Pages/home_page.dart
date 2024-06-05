import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sidoktan/Models/post_model.dart';
import 'package:sidoktan/Models/user_model.dart';
import 'package:sidoktan/Pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _postController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<Post> _posts = [];
  File? _image;

  final User currentUser = User(
    username: "Jordan Poole",
    profilePictureUrl: "assets/images/poole.png",
  );

  void _addPost(User user) {
    if (_postController.text.isEmpty && _image == null) return;

    final newPost = Post(
      user: user,
      content: _postController.text,
      imageUrl: _image?.path ?? '',
      timestamp: DateTime.now(),
      isLiked: false,
      likeCount: 0,
      commentCount: 0,
    );

    setState(() {
      _posts.insert(0, newPost);
      _postController.clear();
      _image = null;
    });
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return timeago.format(timestamp, allowFromNow: true, locale: 'en_short');
  }

  void _toggleLike(Post post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likeCount += post.isLiked ? 1 : -1;
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _navigateToUserProfile(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Sidoktan',
          style: TextStyle(fontFamily: 'DMSerifDisplay'),
        ),
        actions: [
          GestureDetector(
            onTap: () => _navigateToUserProfile(currentUser),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(currentUser.profilePictureUrl),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // post maker
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Ensure the row aligns at the top
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage(currentUser.profilePictureUrl),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _postController,
                              focusNode: _focusNode,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'What are you thinking right now?',
                                hintStyle: const TextStyle(fontSize: 12),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
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
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          size: 20,
                                        ),
                                        onPressed: _pickImageFromCamera,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.photo,
                                          size: 20,
                                        ),
                                        onPressed: _pickImageFromGallery,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () => _addPost(currentUser),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      backgroundColor: const Color(
                                          0xFF5B5CDB), // Ubah warna latar belakang tombol
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                          100, 30), // Ubah warna teks tombol
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
                  if (_image != null) ...[
                    const SizedBox(height: 10),
                    Image.file(_image!),
                  ],
                ],
              ),
            ),
            const Divider(),
            // post maker end //

            // Post Page
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                final String formattedTimestamp =
                    _formatTimestamp(post.timestamp);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage(currentUser.profilePictureUrl),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${post.user.username} · $formattedTimestamp',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(post.content),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(post.isLiked
                                              ? Icons.thumb_up
                                              : Icons.thumb_up_alt_outlined),
                                          iconSize: 20.0,
                                          onPressed: () => _toggleLike(post),
                                          color: post.isLiked
                                              ? const Color(0xFF5B5CDB)
                                              : null,
                                        ),
                                        Text(
                                          '${post.likeCount} likes',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 6),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.comment,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            // Placeholder function for comment interaction
                                          },
                                        ),
                                        Text(
                                          '${post.commentCount} comments',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
            // post page end
          ],
        ),
      ),
    );
  }
}
