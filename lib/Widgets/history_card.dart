import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String diseaseName;
  final double confidence;
  final String date;
  final String image;

  const HistoryCard({
    super.key,
    required this.diseaseName,
    required this.confidence,
    required this.date,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(image, width: 50, height: 50),
        title: Text('Disease name: $diseaseName'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confidence: ${confidence.toStringAsFixed(2)}%'),
            Text('Date: $date'),
          ],
        ),
      ),
    );
  }
}
