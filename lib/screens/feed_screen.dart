import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:straybud/screens/about.dart';
import 'package:straybud/screens/help.dart';
import 'package:straybud/screens/whyAdopt.dart';
import 'package:straybud/utils/colors.dart';
import 'package:straybud/utils/global_variable.dart';
import 'package:straybud/widgets/post_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feedback.dart';
import 'login_screen.dart';

class FeedScreen extends StatefulWidget {
  final snap;
  const FeedScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<void> openMap(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch map';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : Colors.white,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              elevation: 1,
              backgroundColor: Colors.blue,
              centerTitle: false,
              title: Text(
                'StrayBud 🐶',
                style: GoogleFonts.barlow(
                    fontSize: 29,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      const latitude = 19.064628806556637;
                      const longitude = 72.83570151292847;
                      openMap(latitude, longitude);
                    }),
              ],
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.cog,
                  color: Colors.white,
                  size: 25,
                ),
                title: Text(
                  'More Options',
                  style: GoogleFonts.barlow(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.exclamationCircle,
                  color: Colors.black,
                  size: 24,
                ),
                title: Text(
                  'HELP',
                  style: GoogleFonts.barlow(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HelpScreen(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.black,
                  size: 24,
                ),
                title: Text(
                  'WHY ADOPT ?',
                  style: GoogleFonts.barlow(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WhyAdopt(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.feedback,
                  color: Colors.black,
                  size: 24,
                ),
                title: Text(
                  'FEEDBACK',
                  style: GoogleFonts.barlow(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FeedbackApp(
                          // postId: widget.snap?['postId']?.toString(),
                          ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.paw,
                  color: Colors.black,
                  size: 24,
                ),
                title: Text(
                  'MISSING PETS',
                  style: GoogleFonts.barlow(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.infoCircle,
                  color: Colors.black,
                  size: 24,
                ),
                title: Text(
                  'ABOUT US',
                  style: GoogleFonts.barlow(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutUs(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 190,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: Colors.black,
                  size: 24,
                ),
                title: Text(
                  'LOG OUT',
                  style: GoogleFonts.barlow(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                  height: 1,
                  color: Colors.blue[900],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


