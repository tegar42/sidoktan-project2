import 'package:flutter/material.dart';
import 'package:sidoktan/models/user.dart';
import 'package:sidoktan/models/portal_petani.dart';
import 'package:sidoktan/services/portal_petani_service.dart';
import 'package:sidoktan/services/user_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sidoktan/pages/post/comments_page.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserService _userService = UserService();
  final PortalPetaniService _portalPetaniService = PortalPetaniService();
  Map<String, dynamic>? _user;
  bool _loading = false;
  String _errorMessage = '';
  final List<PortalPetani> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _loadPosts();
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

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _loading = true;
      });

      final posts = await _portalPetaniService.getPosts('publish');
      final commentCounts = await _portalPetaniService.getCommentCounts();

      for (var postJson in posts) {
        final post = PortalPetani.fromJson(postJson);

        if (post.idUser == widget.userId) {
          final totalLikes =
              await _portalPetaniService.getLikes(post.idPortalPetani);
          post.likes = totalLikes;

          post.commentCount = commentCounts[post.idPortalPetani] ?? 0;

          setState(() {
            _posts.add(post);
          });
        }
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        _loading = false;
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

  String _formatTimestamp(DateTime timestamp) {
    return timeago.format(timestamp, allowFromNow: true, locale: 'en_short');
  }

  void _toggleLike(PortalPetani post) async {
    try {
      if (post.isLiked) {
        await _portalPetaniService.unlikePost(
            _user!['id'], post.idPortalPetani);
        setState(() {
          post.isLiked = false;
          post.likes--;
        });
      } else {
        await _portalPetaniService.likePost(_user!['id'], post.idPortalPetani);
        setState(() {
          post.isLiked = true;
          post.likes++;
        });
      }

      final index =
          _posts.indexWhere((p) => p.idPortalPetani == post.idPortalPetani);
      if (index != -1) {
        setState(() {
          _posts[index] = post;
        });
      }
    } catch (e) {
      print('Error liking/unliking post: $e');
    }
  }

  void _navigateToComments(int postId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommentPage(
          postId: postId,
          currentUser: Users.fromJson(_user!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  ? CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          centerTitle: true,
                          leading: IconButton(
                            icon: const Icon(Icons.chevron_left,
                                color: Color(0xFF5B5CDB)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          expandedHeight: 300,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
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
                                          _userService.getProfileImageUrl(
                                              _user!['foto']),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 4),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.eco,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 4),
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
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 50),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final post = _posts[index];
                              final profileUrl =
                                  _getProfileImageUrl(post.profile);
                              final imageUrl = _getPostImageUrl(post.image);
                              final String formattedTimestamp =
                                  _formatTimestamp(post.createdAt);

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: profileUrl != null
                                              ? NetworkImage(profileUrl)
                                              : const AssetImage(
                                                  'assets/images/profile.png',
                                                ) as ImageProvider,
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                            ? const Color(
                                                                0xFF5B5CDB)
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
                                                          size: 16,
                                                        ),
                                                        onPressed: () {
                                                          _navigateToComments(post
                                                              .idPortalPetani);
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
                            childCount: _posts.length,
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
