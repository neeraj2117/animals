import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/job_car.dart';
import '../widgets/animals_post.dart';
import 'dog_post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdoptScreen extends StatefulWidget {
  const AdoptScreen({Key? key}) : super(key: key);

  @override
  State<AdoptScreen> createState() => _AdoptScreenState();
}

class _AdoptScreenState extends State<AdoptScreen> {
  Uint8List? _file;
  final List jobsForYou = [
    // [companyName, jobTitle, logoImagePath, hourlyRate ]
    ['Uber', ' Pomeranian', 'lib/images/pomeranian.jpeg', 45],
    ['Google', ' Labrador', 'lib/images/Labrador.jpeg', 80],
    ['Apple', 'Beagle', 'lib/images/beagle.jpeg', 95],
    ['Apple', 'German', 'lib/images/german.jpeg', 95],
  ];

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  _selectImage(BuildContext parentContext) async {
    Uint8List? selectedFile;

    // Open the PostScreen to select an image
    selectedFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(),
      ),
    );

    if (mounted && selectedFile != null) {
      setState(() {
        _file = selectedFile;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Changed to pop instead of push
          },
        ),
        title: Text(
          'Adopt Animals',
          style: GoogleFonts.barlow(fontSize: 29, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.camera_alt,
              size: 30,
            ),
            onPressed: () => _selectImage(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25),
            child: Text(
              'Explore new pets!',
              style: GoogleFonts.barlow(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            height: 30,
                            color: Colors.grey[200],
                            child: Image.asset('lib/images/search.jpeg'),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(color: Colors.black),
                            onChanged: (query) {
                              setState(() {
                                _searchQuery = query;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black),
                              hintText: "Search for a new pet.",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'lib/images/optimization.jpeg',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              'For You',
              style: GoogleFonts.barlow(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 160,
            child: Expanded(
              child: ListView.builder(
                itemCount: jobsForYou.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return JobCard(
                    dogName: jobsForYou[index][1],
                    logoImagePath: jobsForYou[index][2],
                    price: jobsForYou[index][3],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text('All  Pets',
                style: GoogleFonts.barlow(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('dogs').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final dogPosts = snapshot.data!.docs;

                // Debug: Print the number of documents received
                print('Number of documents: ${dogPosts.length}');

                // Filter dogPosts based on the search query
                final filteredDogPosts = _searchQuery.isEmpty
                    ? dogPosts
                    : dogPosts.where((doc) {
                        final dogPost = doc.data() as Map<String, dynamic>;
                        final dogName =
                            dogPost['dogName'].toString().toLowerCase();
                        final breed = dogPost['breed'].toString().toLowerCase();
                        return dogName.contains(_searchQuery.toLowerCase()) ||
                            breed.contains(_searchQuery.toLowerCase());
                      }).toList();

                return ListView.builder(
                  itemCount: filteredDogPosts.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final dogPost =
                        filteredDogPosts[index].data() as Map<String, dynamic>;

                    return DogPostCard(
                      dogName: dogPost['dogName'],
                      breed: dogPost['breed'],
                      imageUrl: dogPost['imageUrl'],
                      age: dogPost['age'] ?? 0,
                      gender: dogPost['gender'],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
