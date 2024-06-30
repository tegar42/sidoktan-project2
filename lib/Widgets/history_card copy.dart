import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HistoryCard extends StatelessWidget {
  final String diseaseName;
  final String confidence;
  final String date;
  final String imageUrl;

  const HistoryCard({
    required this.diseaseName,
    required this.confidence,
    required this.date,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: SizedBox(
          width: 50.0, // Set the width of the image
          height: 50.0, // Set the height of the image
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover, // Adjust the image to cover the container
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(diseaseName),
        subtitle: Text('Confidence: $confidence'),
        trailing: Text(date),
      ),
    );
  }
}
