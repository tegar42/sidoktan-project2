import 'package:http/http.dart' as http;
import 'dart:convert';

class PortalPetaniService {
  static const String baseUrl = 'http://192.168.1.8:5000';
  Future<List<dynamic>> getPosts(String status) async {
    final response =
        await http.get(Uri.parse('$baseUrl/portal_petani?status=$status'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('data')) {
        return jsonData['data']; // Return post data from the response
      } else {
        throw Exception('API response does not contain data field');
      }
    } else {
      throw Exception(
          'Failed to load posts. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> createPost(
      int userId, String content, String status,
      {String? imagePath}) async {
    var uri = Uri.parse('$baseUrl/portal_petani');

    var request = http.MultipartRequest('POST', uri);
    request.fields['id_user'] = userId.toString();
    request.fields['isi_konten'] = content;
    request.fields['status'] = status;

    if (imagePath != null) {
      var image = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(image);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var responseString = utf8.decode(responseData);
      return jsonDecode(responseString);
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<void> likePost(int userId, int postId) async {
    var url = Uri.parse('$baseUrl/portal_petani/like_post');

    var response = await http.post(
      url,
      body: {
        'id_user': userId.toString(),
        'id_post': postId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }
  }

  Future<void> unlikePost(int userId, int postId) async {
    var url = Uri.parse(
        '$baseUrl/portal_petani/like_post?id_user=$userId&id_post=$postId');

    var response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to unlike post');
    }
  }

  Future<List<dynamic>> getComments(int postId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/portal_petani/komentar?id_portal_petani=$postId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['data']; // Return comments data from the response
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(int userId, int postId, String comment) async {
    var url = Uri.parse('$baseUrl/portal_petani/komentar');

    var response = await http.post(
      url,
      body: {
        'id_user': userId.toString(),
        'id_post': postId.toString(),
        'isi_komentar': comment,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }

  Future<int> getLikes(int postId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/portal_petani/get_like_post?id_portal_petani=$postId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data']; // Extract 'data' array from JSON

      if (data.isNotEmpty) {
        // Assuming there's only one object in 'data' array based on your example
        int totalLikes = data[0]['total_likes'] ??
            0; // Extract 'total_likes' from the first object

        return totalLikes;
      } else {
        return 0; // Handle case where 'data' array is empty
      }
    } else {
      throw Exception('Failed to load likes');
    }
  }
}
