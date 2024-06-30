import 'package:flutter/material.dart';
import 'package:sidoktan/services/detection_disease_service.dart'; // Import your detection service

class DetectionResultPage extends StatelessWidget {
  final String diseaseName;
  final double confidence;
  final String imagePath;
  final String fileName;
  final String detectionDate;

  const DetectionResultPage({
    super.key,
    required this.diseaseName,
    required this.confidence,
    required this.imagePath,
    required this.fileName,
    required this.detectionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Result",
              style: TextStyle(
                color: Color(
                    0xFF5B5CDB), // Changed to match the color in the image
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'DMSerifDisplay',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close,
                  color: Color(0xFF5B5CDB)), // Close icon
              onPressed: () {
                Navigator.pop(
                    context); // Function to return to the previous page
              },
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.network(
                  imagePath,
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disease name: $diseaseName',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Confidence: ${confidence.toStringAsFixed(2)}%',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Date: $detectionDate',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: DetectionService.fetchRecommendations(diseaseName),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                      'Error loading recommendations: ${snapshot.error}');
                } else if (!snapshot.hasData ||
                    snapshot.data!.containsKey('error')) {
                  return const Text('No recommendations available.');
                } else {
                  var data = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDAD8F8), // Background color of the recommendations box
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Recommendations:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Biological Control: ${data['pengendalian_hayati']}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Chemical Control: ${data['pengendalian_kimiawi']}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
