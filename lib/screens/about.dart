import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.blue,
        title: Text('Our Team',
            style:
                GoogleFonts.barlow(fontSize: 30, fontWeight: FontWeight.w500)),
      ),
      body: Column(
        children: [
          _buildImageWithText(
              imageAsset: 'lib/images/levi.jpeg',
              heading: 'NEERAJ MEHTA',
              description:
                  'RD and SH National College and SWA Science College'),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 18.0),
          //   child: Divider(
          //     color: Colors.black,
          //   ),
          // ),
          _buildImageWithText(
              imageAsset: 'lib/images/pushpa.jpeg',
              heading: 'NILESH SAHANI',
              description:
                  'RD and SH National College and SWA Science College'),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                const Expanded(
                  child: Divider(
                    thickness: .3,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Built with',
                    style: TextStyle(color: Colors.grey[700], fontSize: 20),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    thickness: .3,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              // Image on the left
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Image.asset(
                  'lib/images/flutter.jpeg',
                  height: 50,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 160),

              Expanded(
                child: Text(
                  'STRAYBUD ©',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget _buildImageWithText(
    {required String imageAsset,
    required String heading,
    required String description}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imageAsset,
            height: 300,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text(
                  heading,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
