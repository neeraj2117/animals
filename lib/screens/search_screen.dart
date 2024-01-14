import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:straybud/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isAnimationVisible = false;
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.blue,
        title: Text(
          'Search  for  User',
          style: GoogleFonts.barlow(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: TextFormField(
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[800],
                      size: 40,
                    ),
                  ),
                  hintText: 'Search for a user...',
                  hintStyle: const TextStyle(color: Colors.black, fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 23.0,
                    horizontal: 10.0,
                  ),
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (String _) {
                  if (mounted) {
                    setState(() {
                      isShowUsers = true;
                    });
                  }
                },
                onChanged: (String text) {
                  if (mounted) {
                    setState(() {
                      isAnimationVisible = text.isNotEmpty;
                    });
                  }
                },
              ),
            ),
          ),
          if (isShowUsers)
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'username',
                      isGreaterThanOrEqualTo: searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['photoUrl'],
                            ),
                            radius: 16,
                          ),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['username'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 30),
          if (isAnimationVisible)
            Lottie.asset(
              'lib/animations/search.json',
              width: 400,
              height: 400,
            ),
        ],
      ),
    );
  }
}
