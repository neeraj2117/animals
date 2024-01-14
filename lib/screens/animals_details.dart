import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class DogDetailsPage extends StatelessWidget {
  final String dogName;
  final String breed;
  final String imageUrl;
  final String age;
  final String gender;

  DogDetailsPage({
    required this.dogName,
    required this.breed,
    required this.imageUrl,
    required this.age,
    required this.gender,
  });

  // Generate a random owner name
  String _generateRandomOwnerName() {
    final List<String> ownerNames = [
      'John Doe',
      'Jane Smith',
      'Alice Johnson',
      'Bob Wilson',
      'Emma Brown',
    ];
    final random = Random();
    return ownerNames[random.nextInt(ownerNames.length)];
  }

  String _generateRandomPhoneNumber() {
    final List<String> phoneNumbers = [
      '+91-9920777536', // Replace with a valid phone number format
      '+91-9962998886',
      '+91-7715949586',
      '+91-9833905020',
      '+91-9594766777',
    ];
    final random = Random();
    return phoneNumbers[random.nextInt(phoneNumbers.length)];
  }

  @override
  Widget build(BuildContext context) {
    final ownerName = _generateRandomOwnerName();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.blue,
        title: Text(
          '$dogName',
          style: GoogleFonts.barlow(fontSize: 31, fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 600,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 23, left: 28, right: 28, bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dog name and gender icon
                          Row(
                            children: [
                              Text(
                                '$dogName',
                                style: GoogleFonts.comfortaa(
                                    fontSize: 55,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 70.0),
                                child: Icon(
                                  gender == 'male' ? Icons.male : Icons.female,
                                  color: gender == 'male'
                                      ? Colors.blue
                                      : Colors.pink,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Breed: $breed',
                          style: GoogleFonts.comfortaa(
                              fontSize: 18,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400)),
                      Text('Age: $age',
                          style: GoogleFonts.comfortaa(
                              fontSize: 18,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 20),

                      const Divider(
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 7,
                      ),

                      // Owner information
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 25,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ownerName,
                                style: GoogleFonts.comfortaa(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$ownerName@gmail.com',
                                style: GoogleFonts.comfortaa(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                _generateRandomPhoneNumber(),
                                style: GoogleFonts.comfortaa(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'This adorable dog is looking for a loving home. He is friendly, well-behaved, and ready to become your new best friend. '
                        'If you are interested in adopting this lovely dog, please click the "Adopt" button below.',
                        style: GoogleFonts.comfortaa(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 75.0),
                        child: Container(
                          height: 50,
                          width: 210,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Adoption',
                              style: GoogleFonts.comfortaa(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
