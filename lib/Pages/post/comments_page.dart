import 'package:flutter/material.dart';
import 'package:sidoktan/models/portal_petani.dart';
import 'package:sidoktan/models/user_model.dart';
import 'package:sidoktan/services/portal_petani_service.dart';

class CommentPage extends StatefulWidget {
  final int postId;

  const CommentPage({super.key, required this.postId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final PortalPetaniService _portalPetaniService = PortalPetaniService();
  List<Komentar> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final comments = await _portalPetaniService.getComments(widget.postId);
      setState(() {
        _comments = comments.map((json) => Komentar.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error fetching comments: $e');
      // Handle error as per your application's needs
    }
  }

  Future<void> _addComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    try {
      // Assuming currentUser is available or can be retrieved from somewhere
      final User currentUser = User(
          idUser: 7,
          username: "Jordan Poole",
          profilePictureUrl: "assets/images/poole.png",
          email: 'test@example.com',
          password: 'password123');

      await _portalPetaniService.addComment(
          currentUser.idUser, widget.postId, commentText);

      // After successfully adding comment, refresh comments list
      await _fetchComments();

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
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  title: Text(comment.isiKomentar),
                  subtitle: Text('Comment by User ${comment.idUser}'),
                  // Implement more UI as needed for each comment
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
