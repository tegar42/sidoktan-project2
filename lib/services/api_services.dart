// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String baseUrl = 'http://127.0.0.1:5000'; // Ganti dengan URL API Anda

//   Future<List<Post>> fetchPosts() async {
//     final response = await http.get(
//         Uri.parse('$baseUrl/portal_petani')); // Ganti dengan endpoint API Anda

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body)['data'];
//       return data.map((json) => Post.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load posts');
//     }
//   }
// }
