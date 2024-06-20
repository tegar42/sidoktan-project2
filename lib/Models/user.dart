// class User {
//   int id;
//   String email;
//   String password;
//   String nama;
//   DateTime tglLahir;
//   String jenisKelamin;
//   String deskripsi;
//   String foto;
//   String noTelp;
//   String wilayah;
//   String alamat;
//   DateTime createdAt;
//   DateTime updatedAt;

//   User({
//     required this.id,
//     required this.email,
//     required this.password,
//     required this.nama,
//     required this.tglLahir,
//     required this.jenisKelamin,
//     required this.deskripsi,
//     required this.foto,
//     required this.noTelp,
//     required this.wilayah,
//     required this.alamat,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       email: json['email'],
//       password: json['password'],
//       nama: json['nama'],
//       tglLahir: DateTime.parse(json['tgl_lahir']),
//       jenisKelamin: json['jenis_kelamin'],
//       deskripsi: json['deskripsi'],
//       foto: json['foto'],
//       noTelp: json['no_telp'],
//       wilayah: json['wilayah'],
//       alamat: json['alamat'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'password': password,
//       'nama': nama,
//       'tgl_lahir': tglLahir.toIso8601String(),
//       'jenis_kelamin': jenisKelamin,
//       'deskripsi': deskripsi,
//       'foto': foto,
//       'no_telp': noTelp,
//       'wilayah': wilayah,
//       'alamat': alamat,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//     };
//   }
// }
