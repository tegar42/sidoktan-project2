// class Post {
//   final int idUser;
//   final String isiKonten;
//   final String createdAt;
//   final int likes;
//   final String image;

//   Post({
//     required this.idUser,
//     required this.isiKonten,
//     required this.createdAt,
//     required this.likes,
//     required this.image,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       idUser: json['id_user'] ?? 0,
//       isiKonten: json['isi_konten'] ?? '',
//       createdAt: json['created_at'] ?? '',
//       likes: json['likes'] ?? 0,
//       image: json['image'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id_user': idUser,
//       'isi_konten': isiKonten,
//       'created_at': createdAt,
//       'likes': likes,
//       'image': image,
//     };
//   }
// }
