import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:straybud/screens/feed_screen.dart';
import 'package:straybud/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.backward,
                  size: 26,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FeedScreen()));
                },
              ),
              title: const Text(
                'Profile Page',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              centerTitle: false,
            ),
            //
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 100,
                          ),
                          const SizedBox(
                              height:
                                  20), // Add spacing between the image and stats

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     buildStatColumn(postLen, "posts"),
                          //     buildStatColumn(followers, "followers"),
                          //     buildStatColumn(following, "following"),
                          //   ],
                          // ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     FirebaseAuth.instance.currentUser!.uid ==
                          //             widget.uid
                          //         ? FollowButton(
                          //             text: 'Sign Out',
                          //             backgroundColor: mobileBackgroundColor,
                          //             textColor: primaryColor,
                          //             borderColor: Colors.grey,
                          //             function: () async {
                          //               await AuthMethods().signOut();
                          //               if (context.mounted) {
                          //                 Navigator.of(context).pushReplacement(
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         const LoginScreen(),
                          //                   ),
                          //                 );
                          //               }
                          //             },
                          //           )
                          //         : isFollowing
                          //             ? FollowButton(
                          //                 text: 'Unfollow',
                          //                 backgroundColor: Colors.white,
                          //                 textColor: Colors.black,
                          //                 borderColor: Colors.grey,
                          //                 function: () async {
                          //                   await FireStoreMethods().followUser(
                          //                     FirebaseAuth
                          //                         .instance.currentUser!.uid,
                          //                     userData['uid'],
                          //                   );

                          //                   setState(() {
                          //                     isFollowing = false;
                          //                     followers--;
                          //                   });
                          //                 },
                          //               )
                          //             : FollowButton(
                          //                 text: 'Follow',
                          //                 backgroundColor: Colors.blue,
                          //                 textColor: Colors.white,
                          //                 borderColor: Colors.blue,
                          //                 function: () async {
                          //                   await FireStoreMethods().followUser(
                          //                     FirebaseAuth
                          //                         .instance.currentUser!.uid,
                          //                     userData['uid'],
                          //                   );

                          //                   setState(() {
                          //                     isFollowing = true;
                          //                     followers++;
                          //                   });
                          //                 },
                          //               )
                          //   ],
                          // ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     isFollowing
                          //         ? Container(
                          //             width: 130,
                          //             height: 90,
                          //             child: FollowButton(
                          //               text: 'Unfollow',
                          //               backgroundColor: Colors.white,
                          //               textColor: Colors.black,
                          //               borderColor: Colors.grey,
                          //               function: () async {
                          //                 await FireStoreMethods().followUser(
                          //                   FirebaseAuth
                          //                       .instance.currentUser!.uid,
                          //                   userData['uid'],
                          //                 );

                          //                 setState(() {
                          //                   isFollowing = false;
                          //                   followers--;
                          //                 });
                          //               },
                          //             ),
                          //           )
                          //         : Container(
                          //             width: 130,
                          //             height: 100,
                          //             child: FollowButton(
                          //               text: 'Follow',
                          //               backgroundColor: Colors.purple[200]!,
                          //               textColor: Colors.black,
                          //               borderColor: Colors.purple[200]!,
                          //               function: () async {
                          //                 await FireStoreMethods().followUser(
                          //                   FirebaseAuth
                          //                       .instance.currentUser!.uid,
                          //                   userData['uid'],
                          //                 );

                          //                 setState(() {
                          //                   isFollowing = true;
                          //                   followers++;
                          //                 });
                          //               },
                          //             ),
                          //           ),
                          //   ],
                          // )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return SizedBox(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey[800],
          ),
        ),
      ),
    ],
  );
}
