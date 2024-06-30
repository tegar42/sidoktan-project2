import 'package:flutter/material.dart';
import 'package:sidoktan/services/detection_disease_service.dart'; // Import your detection service

class DetectionResultPage extends StatelessWidget {
  final String diseaseName;
  final double confidence;
  final String imagePath;
  final String fileName;

  const DetectionResultPage({
    super.key,
    required this.diseaseName,
    required this.confidence,
    required this.imagePath,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Detected Disease: $diseaseName'),
            Text('Confidence: ${confidence.toStringAsFixed(2)}%'),
            Image.network(imagePath),
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Recommendations:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Symptoms: ${data['gejala']}'),
                      Text(
                          'Biological control: ${data['pengendalian_hayati']}'),
                      Text('Chemical control: ${data['pengendalian_kimiawi']}'),
                    ],
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
