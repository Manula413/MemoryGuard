import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dementia_care/components/curve_btn.dart';
import 'package:dementia_care/components/snackbar.dart';
import '../components/coustom_bottom_nav_bar.dart';
import '../helper/enums.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;
  bool isImageSelected = false;
  File? imageFile;
  String _selectedUserName = "";
  List<String> _userNames = [];

  @override
  void initState() {
    super.initState();
    _fetchUserCareOptions();
  }

  Future<void> _fetchUserCareOptions() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .where('care', isEqualTo: userId)
        .get();

    List<String> userNames = querySnapshot.docs
        .map(
            (doc) => doc['name'] as String) // Ensure userName is cast to String
        .toList();

    setState(() {
      _selectedUserName = userNames[0];
      _userNames = userNames;
    });
  }

  _selected() {
    return isImageSelected ? 400.0 : 300.0;
  }

  _pickImagefromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
          isImageSelected = true;
        });
      } else {
        // ignore: use_build_context_synchronously
        snackBar(context, "Error");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      snackBar(context, "Error");
    }
  }

  _pickImagefromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
          isImageSelected = true;
        });
      } else {
        // ignore: use_build_context_synchronously
        snackBar(context, "Error");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      snackBar(context, "Error");
    }
  }

  void _removeImage() {
    setState(() {
      imageFile = null;
      isImageSelected = false;
    });
  }

  Future<String?> uploadImageToFirebase() async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String imageName = 'image_$timestamp.jpg';

    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('images/$imageName.jpg');
      UploadTask uploadTask = ref.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> saveImageURLToFirestore(String imageURL) async {
    try {
      await FirebaseFirestore.instance
          .collection('images')
          .add({'url': imageURL, 'owner': _selectedUserName, 'care': userId});
          // ignore: use_build_context_synchronously
          snackBar(context, "Image Uploaded");
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
    }
  }

  Future<void> _uploadImage() async {
    String? imageURL = await uploadImageToFirebase();
    if (imageURL != null) {
      await saveImageURLToFirestore(imageURL);
      print('Image uploaded and URL saved to Firestore.');
      snackBar(context, "Image Uploaded");
    } else {
      print('Failed to upload image or save URL.');
      snackBar(context, "Failed to upload image.");
    }
  }


  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: const Color.fromARGB(48, 0, 0, 0),
              centerTitle: true,
              title: const Text('Prescription',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0))),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Center(
            child: Card(
              margin: const EdgeInsets.only(top: 100.0),
              elevation: 5,
              shadowColor: Colors.black,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: SizedBox(
                width: 300,
                height: _selected(),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        isImageSelected
                            ? Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8.0)),
                                  child: Image.file(imageFile!,
                                      fit: BoxFit.cover,
                                      width: 300,
                                      height: 100),
                                ),
                              )
                            : const SizedBox(
                                height: 40,
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        isImageSelected
                            ? DropdownButton<String>(
                                value: _selectedUserName,
                                hint: const Text('Select User Name'),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedUserName = newValue!;
                                  });
                                },
                                items: _userNames.map((String userName) {
                                  return DropdownMenuItem<String>(
                                    value: userName,
                                    child: Text(userName),
                                  );
                                }).toList(),
                              )
                            : const SizedBox(height: 2),
                        const SizedBox(
                          height: 30,
                        ),
                        isImageSelected
                            ? CurvedGradientButton(
                                gradientColors: const [
                                  Color.fromARGB(255, 219, 184, 233),
                                  Color.fromARGB(255, 188, 150, 250)
                                ],
                                text: "Upload",
                                onPressed: () async {
                                  _uploadImage();
                                },
                                width: 100,
                              )
                            : CurvedGradientButton(
                                gradientColors: const [
                                  Color.fromARGB(255, 219, 184, 233),
                                  Color.fromARGB(255, 188, 150, 250)
                                ],
                                text: "Camera",
                                onPressed: () async {
                                  await _pickImagefromCamera();
                                },
                                width: 100,
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        isImageSelected
                            ? CurvedGradientButton(
                                gradientColors: const [
                                  Color.fromARGB(255, 219, 184, 233),
                                  Color.fromARGB(255, 188, 150, 250)
                                ],
                                text: "Remove",
                                onPressed: () {
                                  _removeImage();
                                },
                                width: 100,
                              )
                            : CurvedGradientButton(
                                gradientColors: const [
                                  Color.fromARGB(255, 219, 184, 233),
                                  Color.fromARGB(255, 188, 150, 250)
                                ],
                                text: "Gallery",
                                onPressed: () async {
                                  await _pickImagefromGallery();
                                },
                                width: 100,
                              )
                      ],
                    )),
              ),
            ),
          ),
          bottomNavigationBar:
              const CustomBottomNavBar(selectedMenu: MenuState.upload));
    }
  }
}
