import 'dart:convert';
import 'package:http/http.dart' as http;

class DetectionService {
  static const String baseUrl = 'http://192.168.1.8:5000';

  static Future<Map<String, dynamic>> detectDisease(
      String plantType, String imagePath) async {
    try {
      String apiUrl = '$baseUrl/detection/$plantType';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return jsonDecode(responseData);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return {'error': 'Request failed with status: ${response.statusCode}'};
      }
    } catch (e) {
      print('Error sending request: $e');
      return {'error': 'Error sending request: $e'};
    }
  }

  static Future<List<dynamic>> fetchHistory(int userId) async {
    try {
      String apiUrl = '$baseUrl/history_detection?id_user=$userId';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'];
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error sending request: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchRecommendations(
      String diseaseName) async {
    String apiUrl = '$baseUrl/recommendation_care?kelas=$diseaseName';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        print('Failed to load recommendations: ${response.statusCode}');
        return {
          'error': 'Failed to load recommendations: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error loading recommendations: $e');
      return {'error': 'Error loading recommendations: $e'};
    }
  }
}
