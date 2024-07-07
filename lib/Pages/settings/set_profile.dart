import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sidoktan/services/user_service.dart';
import 'package:sidoktan/models/user.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  File? _image;
  final picker = ImagePicker();
  final UserService _userService = UserService();

  Users? _currentUser;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController locationController;
  late TextEditingController gardenLocationController;
  late TextEditingController bioController;

  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    genderController = TextEditingController();
    locationController = TextEditingController();
    gardenLocationController = TextEditingController();
    bioController = TextEditingController();

    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _userService.getUser(8);
      if (user['data'] != null) {
        setState(() {
          _currentUser = Users.fromJson(user['data']);
          nameController.text = _currentUser!.nama;
          emailController.text = _currentUser!.email;
          phoneController.text = _currentUser!.noTelp;
          genderController.text = _currentUser!.jenisKelamin;
          locationController.text = _currentUser!.wilayah;
          gardenLocationController.text = _currentUser!.alamat;
          bioController.text = _currentUser!.deskripsi;
        });
      } else {
        print('User data is null or invalid');
      }
    } catch (e) {
      print('Error loading current user: $e');
      // Handle error as per your application's needs
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    locationController.dispose();
    gardenLocationController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isModified = true; // Mark as modified when image is picked
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveProfile() async {
    // Close the keyboard and remove focus from all fields
    FocusScope.of(context).unfocus();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Prepare user data for update
    Map<String, dynamic> userData = {
      'id': _currentUser!.id,
      'email': emailController.text,
      'nama': nameController.text,
      'tgl_lahir': _currentUser!.tglLahir,
      'jenis_kelamin': genderController.text,
      'deskripsi': bioController.text,
      'foto': _image != null ? _image!.path.split('/').last : '',
      'no_telp': phoneController.text,
      'wilayah': locationController.text,
      'alamat': gardenLocationController.text,
      'created_at': _currentUser!.createdAt,
      'updated_at': DateTime.now().toString(),
    };

    try {
      // Update user data (excluding image) first
      await _userService.updateUser(userData, _image?.path ?? '');

      // Hide loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.lightGreen,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10.0),
        ),
      );

      // Reset modification flag
      setState(() {
        _isModified = false;
      });
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set Profile",
          style: TextStyle(
            color: Color(0xFF5B5CDB),
            fontWeight: FontWeight.bold,
            fontFamily: 'DMSerifDisplay',
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF5B5CDB)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_isModified) // Show Save button only if modified
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF5B5CDB),
                  fontSize: 18.0,
                  fontFamily: 'DMSans',
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(
                            _userService.getProfileImageUrl(
                              _currentUser!.foto,
                            ),
                          ) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: gardenLocationController,
              decoration: const InputDecoration(labelText: 'Garden Location'),
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
