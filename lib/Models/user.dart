class Users {
  int id;
  String email;
  String nama;
  String tglLahir;
  String jenisKelamin;
  String deskripsi;
  String foto;
  String noTelp;
  String wilayah;
  String alamat;
  String createdAt;
  String updatedAt;

  Users({
    required this.id,
    required this.email,
    required this.nama,
    required this.tglLahir,
    required this.jenisKelamin,
    this.deskripsi = "",
    this.foto = "",
    this.noTelp = "",
    this.wilayah = "",
    this.alamat = "",
    required this.createdAt,
    required this.updatedAt,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      nama: json['nama'] ?? '',
      tglLahir: json['tgl_lahir'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      foto: json['foto'] ?? '',
      noTelp: json['no_telp'] ?? '',
      wilayah: json['wilayah'] ?? '',
      alamat: json['alamat'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
