import 'package:flutter/material.dart';
import 'package:sidoktan/Widgets/plant_option.dart';
import 'package:sidoktan/Widgets/history_card.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "siDokTan",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'DMSerifDisplay',
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            color: Colors.grey, // Ubah warna sesuai kebutuhan
          ),
        ), // Judul (header) halaman
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                  image: const AssetImage(
                      'assets/images/poole.png'), // Path to your background image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Start Diagnosis',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PlantOption(
                          image: 'assets/images/tomato.png',
                          title: 'Tomato',
                          onTap: () {
                            // Navigate to diagnosis page for Tomato
                          },
                        ),
                        PlantOption(
                          image: 'assets/images/chilis.png',
                          title: 'Chilli',
                          onTap: () {
                            // Navigate to diagnosis page for Chilli
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: const [
                  HistoryCard(
                    diseaseName: 'Bacterial spot',
                    confidence: 93.22,
                    date: '2024-03-03',
                    image: 'assets/images/leaf.jpg',
                  ),
                  // Add more HistoryCard widgets as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
