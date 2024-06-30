import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl =
      'http://192.168.1.8:5000'; // Replace with your actual API base URL

  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> createUser(
      Map<String, dynamic> userData, String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users'));
    userData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (filePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto', filePath));
    }

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return jsonDecode(responseBody.body);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> userData, String filePath) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/users/update'));
    userData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (filePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto', filePath));
    }

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return jsonDecode(responseBody.body);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<Map<String, dynamic>> deleteUser(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/delete'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete user');
    }
  }

  String getProfileImageUrl(String filename) {
    return '$baseUrl/images/profile/$filename';
  }
}
