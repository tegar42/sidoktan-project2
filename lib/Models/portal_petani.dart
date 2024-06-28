class PortalPetani {
  final int idUser;
  final int idPortalPetani;
  final String namaUser;
  final String profile;
  final String isiKonten;
  int likes;
  final DateTime createdAt;
  final String? image;
  bool isLiked;
  int commentCount; // Add this line

  PortalPetani({
    required this.idUser,
    required this.idPortalPetani,
    required this.namaUser,
    required this.profile,
    required this.isiKonten,
    required this.likes,
    required this.createdAt,
    this.image,
    this.isLiked = false,
    this.commentCount = 0, // Add this line
  });

  factory PortalPetani.fromJson(Map<String, dynamic> json) {
    return PortalPetani(
      idUser: json['id_user'],
      idPortalPetani: json['id_portal_petani'],
      namaUser: json['nama_user'],
      profile: json['profile'],
      isiKonten: json['isi_konten'],
      likes: json['likes'],
      createdAt: DateTime.parse(json['created_at']),
      image: json['image'],
      isLiked: json['is_liked'] ?? false,
      commentCount: json['comment_count'] ?? 0, // Add this line
    );
  }
}

class Komentar {
  final int idKomentar;
  final int idUser;
  final int idPortalPetani;
  final String isiKomentar;
  final DateTime timestamp;

  Komentar({
    required this.idKomentar,
    required this.idUser,
    required this.idPortalPetani,
    required this.isiKomentar,
    required this.timestamp,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      idKomentar: json['id_komentar'],
      idUser: json['id_user'],
      idPortalPetani: json['id_portal_petani'],
      isiKomentar: json['isi_komentar'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_komentar': idKomentar,
      'id_user': idUser,
      'id_portal_petani': idPortalPetani,
      'isi_komentar': isiKomentar,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
