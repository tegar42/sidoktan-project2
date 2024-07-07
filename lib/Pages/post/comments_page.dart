import 'package:flutter/material.dart';
import 'package:sidoktan/models/portal_petani.dart';
import 'package:sidoktan/models/user.dart';
import 'package:sidoktan/services/portal_petani_service.dart';
import 'package:sidoktan/services/user_service.dart'; // Import UserService

class CommentPage extends StatefulWidget {
  final int postId;
  final Users currentUser; // Add currentUser parameter

  const CommentPage({Key? key, required this.postId, required this.currentUser})
      : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final PortalPetaniService _portalPetaniService = PortalPetaniService();
  final ScrollController _scrollController = ScrollController();
  final UserService _userService = UserService(); // Instantiate UserService
  final List<Komentar> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final comments = await _portalPetaniService.getComments(widget.postId);

      _comments.clear();

      // Iterate through comments to fetch user information
      for (var jsonComment in comments) {
        final comment = Komentar.fromJson(jsonComment);

        // Fetch user information using UserService
        final userResponse = await _userService.getUser(comment.idUser);
        if (userResponse.containsKey('data')) {
          final userData = userResponse['data'];
          // Update comment with user information
          comment.username = userData['nama'];
          comment.fotoUser = _userService.getProfileImageUrl(userData['foto']);
        }

        setState(() {
          _comments.add(comment);
        });
      }
    } catch (e) {
      print('Error fetching comments: $e');
      // Handle error as per your application's needs
    }
  }

  Future<void> _addComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    try {
      final Users currentUser = widget.currentUser;

      await _portalPetaniService.addComment(
          currentUser.id, widget.postId, commentText);

      // After successfully adding comment, refresh comments list
      await _fetchComments();
      // Close keyboard
      FocusScope.of(context).unfocus();
      // Scroll to the bottom
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );

      // Clear input field after adding comment
      _commentController.clear();
    } catch (e) {
      print('Error adding comment: $e');
      // Handle error as per your application's needs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Comments",
          style: TextStyle(
            color: Color(0xFF5B5CDB),
            fontWeight: FontWeight.bold,
            fontFamily: 'DMSerifDisplay',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF5B5CDB)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: comment.fotoUser != null
                        ? NetworkImage(comment.fotoUser!)
                        : const AssetImage('assets/images/default_avatar.png'),
                  ),
                  title: Text('${comment.username}'),
                  subtitle: Text(comment.isiKomentar),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
