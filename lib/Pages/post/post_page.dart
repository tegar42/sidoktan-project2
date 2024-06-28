import 'package:flutter/material.dart';
import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';
import 'package:sidoktan/models/portal_petani.dart';
import 'package:sidoktan/models/user_model.dart';
import 'package:sidoktan/services/portal_petani_service.dart';
import 'package:sidoktan/pages/post/comments_page.dart';
import 'package:sidoktan/Widgets/post_form.dart'; // Import widget PostFormWidget

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<PortalPetani> _posts = [];
  final PortalPetaniService _portalPetaniService = PortalPetaniService();
  bool _isLoading = true; // State to control loading indicator

  // State for handling post form
  final TextEditingController _postController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  File? _image;

  final User currentUser = User(
    idUser: 7,
    username: "Jordan Poole",
    profilePictureUrl: "assets/images/poole.png",
    email: 'test@example.com',
    password: 'password123',
  );

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final posts = await _portalPetaniService.getPosts('publish');

      for (var postJson in posts) {
        final post = PortalPetani.fromJson(postJson);

        // Fetch comments for each post and count them
        final comments =
            await _portalPetaniService.getComments(post.idPortalPetani);
        post.commentCount = comments.length;

        final totalLikes =
            await _portalPetaniService.getLikes(post.idPortalPetani);
        post.likes = totalLikes;

        setState(() {
          _posts.add(post);
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _getProfileImageUrl(String? filename) {
    if (filename == null || filename.isEmpty) {
      return null;
    }
    const baseUrl = 'http://10.0.2.2:5000/images/profile/';
    return '$baseUrl$filename';
  }

  String? _getPostImageUrl(String? filename) {
    if (filename == null || filename.isEmpty) {
      return null;
    }
    const baseUrl = 'http://10.0.2.2:5000/images/portal_petani/';
    return '$baseUrl$filename';
  }

  void _toggleLike(PortalPetani post) async {
    try {
      if (post.isLiked) {
        await _portalPetaniService.unlikePost(
            currentUser.idUser, post.idPortalPetani);
        setState(() {
          post.isLiked = false;
          post.likes--; // Update local post object
        });
      } else {
        await _portalPetaniService.likePost(
            currentUser.idUser, post.idPortalPetani);
        setState(() {
          post.isLiked = true;
          post.likes++; // Update local post object
        });
      }

      // Update likes count in _posts list
      final index =
          _posts.indexWhere((p) => p.idPortalPetani == post.idPortalPetani);
      if (index != -1) {
        setState(() {
          _posts[index] = post; // Update specific post in the list
        });
      }
    } catch (e) {
      print('Error liking/unliking post: $e');
      // Handle error as per your application's needs
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return timeago.format(timestamp, allowFromNow: true, locale: 'en_short');
  }

  void _addPost(User user) {
    if (_postController.text.isEmpty && _image == null) return;

    setState(() {
      // Update your logic to add the new post to _posts list or save it to API
      // Example: _posts.insert(0, newPost);
      _postController.clear();
      _image = null;
    });
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print('Image path from camera: ${image.path}');
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Image path from gallery: ${image.path}');
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.5,
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
            color: Colors.grey,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 18.0,
                backgroundImage: AssetImage(currentUser.profilePictureUrl),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PostFormWidget(
                      postController: _postController,
                      focusNode: _focusNode,
                      pickImageFromCamera: _pickImageFromCamera,
                      pickImageFromGallery: _pickImageFromGallery,
                      addPost: () => _addPost(currentUser),
                      hasImage: _image != null,
                      image: _image,
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        final profileUrl = _getProfileImageUrl(post.profile);
                        final imageUrl = _getPostImageUrl(post.image);
                        final String formattedTimestamp =
                            _formatTimestamp(post.createdAt);

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: profileUrl != null
                                        ? NetworkImage(profileUrl)
                                        : const AssetImage(
                                            'assets/images/profile.png',
                                          ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${post.namaUser} · $formattedTimestamp',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(post.isiKonten),
                                        if (imageUrl != null)
                                          Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(post.isLiked
                                                      ? Icons.thumb_up
                                                      : Icons
                                                          .thumb_up_alt_outlined),
                                                  iconSize: 20.0,
                                                  onPressed: () async {
                                                    _toggleLike(
                                                        post); // Toggle like state
                                                  },
                                                  color: post.isLiked
                                                      ? const Color(0xFF5B5CDB)
                                                      : null,
                                                ),
                                                Text(
                                                  '${post.likes} likes',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 6),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.comment,
                                                      size: 16),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentPage(
                                                                postId: post
                                                                    .idPortalPetani),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  '${post.commentCount} comments',
                                                  style: const TextStyle(
                                                      fontSize: 12),
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
                  ],
                ),
              ),
            ),
    );
  }
}
