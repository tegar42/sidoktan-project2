import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sidoktan/Widgets/plant_option.dart';
import 'package:sidoktan/Widgets/history_card.dart';
import 'package:sidoktan/services/detection_disease_service.dart';
import 'package:sidoktan/pages/detection/detection_result.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  List<dynamic> historyData = []; // Update with your actual base URL

  @override
  void initState() {
    super.initState();
    // Fetch initial history data when the page loads
    fetchHistory(
        9); // Replace 1 with actual user ID or handle user authentication
  }

  Future<void> fetchHistory(int userId) async {
    try {
      var fetchedHistory = await DetectionService.fetchHistory(userId);
      setState(() {
        historyData = fetchedHistory;
      });
    } catch (error) {
      print('Error fetching history: $error');
    }
  }

  Future<void> detectDisease(String plantType, String imagePath) async {
    var response = await DetectionService.detectDisease(plantType, imagePath);

    // Check if response is valid
    if (response['status'] == '200') {
      // Extract prediction and confidence from data
      String prediction = response['data']['prediction'];
      double confidence = response['data']['confidence'];
      String imageFullPath = response['data']['image_path'];
      String fileName = response['data']['file_name'];

      String detectionDate = _dateFormat.format(DateTime.now());

      // Navigate to result page after detection
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetectionResultPage(
            diseaseName: prediction,
            confidence: confidence,
            imagePath: imageFullPath,
            fileName: fileName,
            detectionDate: detectionDate,
          ),
        ),
      );
    } else {
      // Handle error or unexpected response
      print('Failed to get valid response from detection service');
      // Show error message or handle appropriately
    }
  }

  Future<void> _pickImage(String plantType) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Picked image path: ${image.path}');
      detectDisease(plantType, image.path);
    }
  }

  Future<void> _captureImage(String plantType) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print('Captured image path: ${image.path}');
      detectDisease(plantType, image.path);
    }
  }

  void _showImageSourceActionSheet(String plantType) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(plantType);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _captureImage(plantType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF5B5CDB)),
          onPressed: () {
            Navigator.pop(
                context); // Menambahkan fungsi untuk kembali ke halaman sebelumnya
          },
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
                  image: const AssetImage('assets/images/background-scan.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Start Diagnosis',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5B5CDB)),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Select the type of plant',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PlantOption(
                          image: 'assets/images/tomatoes.png',
                          title: 'Tomato',
                          onTap: () {
                            print('Tomato option tapped');
                            _showImageSourceActionSheet('tomat');
                          },
                        ),
                        PlantOption(
                          image: 'assets/images/chilli.png',
                          title: 'Chilli',
                          onTap: () {
                            print('Chilli option tapped');
                            _showImageSourceActionSheet('cabai');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B5CDB),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  var item = historyData[index];
                  return HistoryCard(
                    diseaseName: item['nama_penyakit'],
                    confidence: item['hasil_prediksi'],
                    date: item['tanggal'],
                    imageUrl:
                        'http://10.0.2.2:5000/images/${item['foto']}', // Adjust with your actual URL
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
