import 'package:flutter/material.dart';
import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';
import 'package:sidoktan/models/portal_petani.dart';
import 'package:sidoktan/models/user.dart';
import 'package:sidoktan/services/portal_petani_service.dart';
import 'package:sidoktan/services/user_service.dart'; // Import UserService
import 'package:sidoktan/pages/post/comments_page.dart';
import 'package:sidoktan/pages/profile_page.dart';
import 'package:sidoktan/Widgets/post_form.dart';

abstract class PostSortingStrategy {
  void sort(List<PortalPetani> posts);
}

class SortByLatest implements PostSortingStrategy {
  @override
  void sort(List<PortalPetani> posts) {
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

class SortByPopularity implements PostSortingStrategy {
  @override
  void sort(List<PortalPetani> posts) {
    posts.sort((a, b) => b.likes.compareTo(a.likes));
  }
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<PortalPetani> _posts = [];
  final PortalPetaniService _portalPetaniService = PortalPetaniService();
  final UserService _userService = UserService();
  bool _isLoading = true;

  final TextEditingController _postController = TextEditingController();
  File? _image;

  Users? _currentUser;

  late PostSortingStrategy _sortingStrategy;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadPosts();
    _setSortingStrategy(PostSortOption.latest);
  }

  void _setSortingStrategy(PostSortOption option) {
    setState(() {
      switch (option) {
        case PostSortOption.latest:
          _sortingStrategy = SortByLatest();
          break;
        case PostSortOption.popularity:
          _sortingStrategy = SortByPopularity();
          break;
      }
      _sortPosts(); // Sort posts based on the selected option
    });
  }

  void _sortPosts() {
    _sortingStrategy.sort(_posts);
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _userService.getUser(9);
      if (user['data'] != null) {
        setState(() {
          _currentUser = Users.fromJson(user['data']);
        });
      } else {
        print('User data is null or invalid');
      }
    } catch (e) {
      print('Error loading current user: $e');
      // Handle error as per your application's needs
    }
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final posts = await _portalPetaniService.getPosts('publish');
      final commentCounts = await _portalPetaniService.getCommentCounts();

      for (var postJson in posts) {
        final post = PortalPetani.fromJson(postJson);

        final totalLikes =
            await _portalPetaniService.getLikes(post.idPortalPetani);
        post.likes = totalLikes;

        post.commentCount = commentCounts[post.idPortalPetani] ?? 0;

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
    return _userService.getProfileImageUrl(filename);
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
            _currentUser!.id, post.idPortalPetani);
        setState(() {
          post.isLiked = false;
          post.likes--;
        });
      } else {
        await _portalPetaniService.likePost(
            _currentUser!.id, post.idPortalPetani);
        setState(() {
          post.isLiked = true;
          post.likes++;
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

  void _addPost(Users user) async {
    if (_postController.text.isEmpty && _image == null) return;

    try {
      setState(() {
        _isLoading = true; // Set loading state while adding post
      });

      final response = await _portalPetaniService.createPost(
        user.id,
        _postController.text,
        'publish',
        imagePath: _image?.path,
      );

      // Assuming response handling logic here (e.g., update UI with new post)
      // You might want to fetch new posts or update existing list

      setState(() {
        _isLoading = false; // Clear loading state after adding post
        _postController.clear(); // Clear post text field
        _image = null; // Clear selected image
      });

      // Optionally, refresh posts after adding a new post
      _handleRefresh();
    } catch (e) {
      print('Error adding post: $e');
      setState(() {
        _isLoading = false; // Clear loading state on error
      });
      // Handle error as per your application's needs
    }
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
    setState(() {
      _isLoading = true;
    });

    await _loadPosts();

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToComments(int postId) {
    if (_currentUser != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CommentPage(
            postId: postId,
            currentUser: _currentUser!, // Pass currentUser to CommentPage
          ),
        ),
      );
    } else {
      print('Current user is null or not loaded yet.');
    }
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
            onTap: () {
              if (_currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfilePage(userId: _currentUser!.id),
                  ),
                );
              } else {
                print('Current user is null or not loaded yet.');
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 18.0,
                backgroundImage: _currentUser != null
                    ? NetworkImage(
                        _userService.getProfileImageUrl(_currentUser!.foto),
                      )
                    : const AssetImage('assets/images/profile.png'),
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
                      pickImageFromCamera: _pickImageFromCamera,
                      pickImageFromGallery: _pickImageFromGallery,
                      addPost: () => _addPost(_currentUser!),
                      hasImage: _image != null,
                      image: _image,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.grey),
                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Sort by',
                            style: TextStyle(fontSize: 16),
                          ),
                          DropdownButton<PostSortOption>(
                            value: _sortingStrategy is SortByLatest
                                ? PostSortOption.latest
                                : PostSortOption.popularity,
                            icon: const Icon(Icons.filter_alt),
                            onChanged: (PostSortOption? newValue) {
                              if (newValue != null) {
                                _setSortingStrategy(newValue);
                              }
                            },
                            items: <PostSortOption>[
                              PostSortOption.latest,
                              PostSortOption.popularity,
                            ].map<DropdownMenuItem<PostSortOption>>(
                                (PostSortOption value) {
                              return DropdownMenuItem<PostSortOption>(
                                value: value,
                                child: Text(value == PostSortOption.latest
                                    ? 'Latest'
                                    : 'Popularity'),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
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
                                            height: 200,
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
                                                    _navigateToComments(
                                                        post.idPortalPetani);
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

enum PostSortOption {
  latest,
  popularity,
}
