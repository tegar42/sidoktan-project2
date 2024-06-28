// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:image_picker/image_picker.dart';
// import 'package:sidoktan/models/portal_petani.dart';
// import 'package:sidoktan/models/user_model.dart';
// import 'package:sidoktan/services/portal_petani_service.dart';
// import 'package:sidoktan/Widgets/post_form.dart'; // Import widget PostFormWidget

// class PostPage extends StatefulWidget {
//   const PostPage({super.key});

//   @override
//   State<PostPage> createState() => _PostPageState();
// }

// class _PostPageState extends State<PostPage> {
//   final List<PortalPetani> _posts = [];
//   final PortalPetaniService _portalPetaniService = PortalPetaniService();
//   bool _isLoading = true;

//   // State for handling post form
//   final TextEditingController _postController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   File? _image;

//   final User currentUser = User(
//     username: "Jordan Poole",
//     profilePictureUrl: "assets/images/poole.png",
//     email: 'test@example.com',
//     password: 'password123',
//   );

//   @override
//   void initState() {
//     super.initState();
//     _loadPosts();
//   }

//   Future<void> _loadPosts() async {
//     try {
//       final posts = await _portalPetaniService.getPosts('publish');
//       setState(() {
//         _posts.addAll(posts.map((postJson) => PortalPetani.fromJson(postJson)));
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading posts: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   String? _getProfileImageUrl(String? filename) {
//     if (filename == null || filename.isEmpty) {
//       return null;
//     }
//     const baseUrl = 'http://10.0.2.2:5000/images/profile/';
//     return '$baseUrl$filename';
//   }

//   String? _getPostImageUrl(String? filename) {
//     if (filename == null || filename.isEmpty) {
//       return null;
//     }
//     const baseUrl = 'http://10.0.2.2:5000/images/portal_petani/';
//     return '$baseUrl$filename';
//   }

//   String _formatTimestamp(DateTime timestamp) {
//     return timeago.format(timestamp, allowFromNow: true, locale: 'en_short');
//   }

//   void _addPost(User user) async {
//     if (_postController.text.isEmpty && _image == null) return;

//     try {
//       await _portalPetaniService.addPost(
//         user.id, // Ganti dengan id user yang sesuai
//         _postController.text,
//         'publish',
//         image: _image != null ? _image!.path : null,
//       );

//       setState(() {
//         _postController.clear();
//         _image = null;
//       });

//       // Reload posts after adding new post
//       _loadPosts();
//     } catch (e) {
//       print('Error adding post: $e');
//       // Handle error
//     }
//   }

//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImageFromCamera() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       print('Image path from camera: ${image.path}');
//       setState(() {
//         _image = File(image.path);
//       });
//     }
//   }

//   Future<void> _pickImageFromGallery() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       print('Image path from gallery: ${image.path}');
//       setState(() {
//         _image = File(image.path);
//       });
//     }
//   }

//   void _toggleLike(PortalPetani post) async {
//     try {
//       if (post.isLiked) {
//         await _portalPetaniService.unlikePost(post.id_portal_petani);
//         setState(() {
//           post.isLiked = false;
//           post.likeCount--;
//         });
//       } else {
//         await _portalPetaniService.likePost(post.id_portal_petani);
//         setState(() {
//           post.isLiked = true;
//           post.likeCount++;
//         });
//       }
//     } catch (e) {
//       print('Error toggling like: $e');
//       // Handle error
//     }
//   }

//   void _handleCommentInteraction(PortalPetani post) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final TextEditingController _commentController = TextEditingController();
//         return AlertDialog(
//           title: Text('Add Comment'),
//           content: TextField(
//             controller: _commentController,
//             decoration: InputDecoration(
//               hintText: 'Enter your comment',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('CANCEL'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child
//               child: Text('COMMENT'),
//               onPressed: () async {
//                 if (_commentController.text.isNotEmpty) {
//                   try {
//                     await _portalPetaniService.addComment(post.id_portal_petani, _commentController.text);
//                     Navigator.of(context).pop();
//                     // Refresh comments after adding new comment
//                     post.commentsCount++;
//                     setState(() {});
//                   } catch (e) {
//                     print('Error adding comment: $e');
//                     // Handle error
//                   }
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Portal Petani'),
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : RefreshIndicator(
//               onRefresh: () async {
//                 _posts.clear();
//                 await _loadPosts();
//               },
//               child: ListView.builder(
//                 itemCount: _posts.length + 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   if (index == 0) {
//                     return PostFormWidget(
//                       postController: _postController,
//                       focusNode: _focusNode,
//                       image: _image,
//                       onPost: () => _addPost(currentUser),
//                       onPickImageFromCamera: _pickImageFromCamera,
//                       onPickImageFromGallery: _pickImageFromGallery,
//                     );
//                   }
//                   final post = _posts[index - 1];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: AssetImage(currentUser.profilePictureUrl),
//                           ),
//                           title: Text(currentUser.username),
//                           subtitle: Text(_formatTimestamp(post.createdAt)),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(post.content),
//                         ),
//                         if (post.imageUrl != null)
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Image.network(_getPostImageUrl(post.imageUrl)!),
//                           ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               TextButton.icon(
//                                 onPressed: () => _toggleLike(post),
//                                 icon: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border),
//                                 label: Text(post.likeCount.toString()),
//                               ),
//                               TextButton.icon(
//                                 onPressed: () => _handleCommentInteraction(post),
//                                 icon: Icon(Icons.comment),
//                                 label: Text(post.commentsCount.toString()),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
