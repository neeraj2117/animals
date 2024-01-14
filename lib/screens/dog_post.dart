import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animals_details.dart';

class DogPostCard extends StatelessWidget {
  final String dogName;
  final String breed;
  final String imageUrl;
  final String age;
  final String gender;

  DogPostCard({
    required this.dogName,
    required this.breed,
    required this.imageUrl,
    required this.age,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DogDetailsPage(
              dogName: dogName,
              breed: breed,
              imageUrl: imageUrl,
              age: age,
              gender: gender,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 11.0, right: 11),
        child: Card(
          color: Colors.grey[200],
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use CachedNetworkImage to load images from the network
              CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
              const SizedBox(
                width: 18,
              ), // Add some spacing between the image and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: Row(
                      children: [
                        Text(
                          dogName,
                          style: GoogleFonts.courgette(
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Icon(
                          gender == 'male' ? Icons.male : Icons.female,
                          color: Colors.pink,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 40), // Add spacing between text elements
                  Text(
                    breed,
                    style: GoogleFonts.comfortaa(
                        fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    age,
                    style: GoogleFonts.comfortaa(
                        fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
