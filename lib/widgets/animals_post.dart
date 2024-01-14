import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../utils/utils.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Uint8List? _selectedPhoto;
  bool _imageSelected = false;

  // Dog detail text controllers
  TextEditingController _dogNameController = TextEditingController();
  TextEditingController _breedController = TextEditingController();

  // Selected gender and age
  String? _selectedGender;
  String? _selectedAge;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> ageOptions = ['Puppy', 'Young', 'Adult', 'Senior'];

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _selectImage() async {
    Uint8List? selectedFile = await pickImage(ImageSource.gallery);

    if (mounted && selectedFile != null) {
      setState(() {
        _selectedPhoto = selectedFile;
        _imageSelected = true;
      });
    }
  }

  _postImage() async {
    // Check if an image is selected
    if (_selectedPhoto == null) {
      // Handle the case where no image is selected
      _showSnackbar('Please select an image.');
      return;
    }

    // Create a reference to the Firebase Storage bucket
    final firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child('dog_images');

    // Generate a unique ID for the image
    final String imageId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // Upload the image to Firebase Storage
      final firebase_storage.UploadTask uploadTask =
          storageReference.child('$imageId.jpg').putData(_selectedPhoto!);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL of the uploaded image
      final String imageUrl =
          await storageReference.child('$imageId.jpg').getDownloadURL();

      // Store dog details and image URL in Firebase Firestore
      await FirebaseFirestore.instance.collection('dogs').add({
        'dogName': _dogNameController.text,
        'breed': _breedController.text,
        'gender': _selectedGender,
        'age': _selectedAge,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show a success Snackbar
      _showSnackbar('Posted successfully!');

      // Clear the form
      _dogNameController.clear();
      _breedController.clear();
      setState(() {
        _selectedPhoto = null;
        _imageSelected = false;
      });

      // Navigate back to the AdoptScreen
      Navigator.of(context).pop();
    } catch (error) {
      // Show an error Snackbar if there's an issue
      _showSnackbar('Error posting: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
        title: Text(
          'Selected Photo',
          style: GoogleFonts.barlow(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedPhoto != null)
              Container(
                width: 370,
                height: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: MemoryImage(_selectedPhoto!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Lottie.asset(
                'lib/animations/post.json',
                width: 480,
                height: 470,
                fit: BoxFit.cover,
              ),
            const SizedBox(
              height: 40,
            ),
            // Dog detail text fields
            if (_imageSelected)
              Column(
                children: [
                  SizedBox(
                    width: 370,
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      controller: _dogNameController,
                      decoration: InputDecoration(
                        labelText: 'Dog Name',
                        labelStyle: TextStyle(color: Colors.blue),
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: Icon(
                          FontAwesomeIcons.dog,
                          color: Colors.blue[100],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 370,
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      controller: _breedController,
                      decoration: InputDecoration(
                        labelText: 'Breed',
                        labelStyle: TextStyle(color: Colors.blue),
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: Icon(
                          FontAwesomeIcons.paw,
                          color: Colors.blue[100],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 370,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      items: genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(
                            gender,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(color: Colors.blue),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: Icon(
                          FontAwesomeIcons.venusMars,
                          color: Colors.blue[100],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 370,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: _selectedAge,
                      onChanged: (value) {
                        setState(() {
                          _selectedAge = value;
                        });
                      },
                      items: ageOptions.map((String age) {
                        return DropdownMenuItem<String>(
                          value: age,
                          child: Text(
                            age,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Age',
                        labelStyle: TextStyle(color: Colors.blue),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: Icon(
                          FontAwesomeIcons.birthdayCake,
                          color: Colors.blue[100],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: ElevatedButton(
                      onPressed: _postImage,
                      child: Text(
                        'Post',
                        style: GoogleFonts.barlow(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectImage,
                  child: Text(
                    'Select Image',
                    style: GoogleFonts.barlow(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
