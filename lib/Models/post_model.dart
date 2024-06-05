import 'package:sidoktan/Models/user_model.dart';

class Post {
  final User user;
  final String content;
  final String imageUrl;
  final DateTime timestamp;
  bool isLiked;
  int likeCount;
  int commentCount;

  Post({
    required this.user,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
  });
}
