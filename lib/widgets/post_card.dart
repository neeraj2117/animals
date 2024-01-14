import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:straybud/models/user.dart' as model;
import 'package:straybud/providers/user_provider.dart';
import 'package:straybud/resources/firestore_methods.dart';
import 'package:straybud/screens/comments_screen.dart';
import 'package:straybud/utils/colors.dart';
import 'package:straybud/utils/global_variable.dart';
import 'package:straybud/utils/utils.dart';
import 'package:straybud/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 15,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: GoogleFonts.barlow(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 13.0),
                            child: buildDateAgo(
                                widget.snap['datePublished'].toDate())),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        color: Colors.black,
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                              onTap: () {
                                                deletePost(
                                                  widget.snap['postId']
                                                      .toString(),
                                                );
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.snap['description'],
                style: GoogleFonts.barlow(
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),

          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            // child: Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     SizedBox(
            //       height: MediaQuery.of(context).size.height * 0.34,
            //       width: MediaQuery.of(context).size.width * 0.95,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(
            //             15.0), // Adjust the radius as needed
            //         child: Image.network(
            //           widget.snap['postUrl'].toString(),
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //     AnimatedOpacity(
            //       duration: const Duration(milliseconds: 200),
            //       opacity: isLikeAnimating ? 1 : 0,
            //       child: LikeAnimation(
            //         isAnimating: isLikeAnimating,
            //         duration: const Duration(
            //           milliseconds: 400,
            //         ),
            //         onEnd: () {
            //           setState(() {
            //             isLikeAnimating = false;
            //           });
            //         },
            //         child: const Icon(
            //           Icons.favorite,
            //           color: Colors.white,
            //           size: 100,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.34,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the radius as needed
                    child: Image.network(
                      widget.snap['postUrl'].toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Image has loaded
                          return child;
                        } else {
                          // Show a circular progress indicator while loading
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ),
                    onPressed: () => FireStoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      user.uid,
                      widget.snap['likes'],
                    ),
                  ),
                ),
              ),
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w800),
                child: Text(
                  'Likes (${widget.snap['likes'].length})',
                  // '${widget.snap['likes'].length} likes',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child:
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => CommentsScreen(
                    //           postId: widget.snap['postId'].toString(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.blue,
                    //     onPrimary: secondaryColor,
                    //     elevation: 0,
                    //   ),
                    //   child: Text(
                    //     'Comments ($commentLen)',
                    //     style: const TextStyle(fontSize: 14, color: Colors.white),
                    //   ),
                    // ),
                    GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    );
                  },
                  child: DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                            width: 5), // Add spacing between icon and text
                        Text(
                          'Comments ($commentLen)',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // DefaultTextStyle(
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleSmall!
                //       .copyWith(fontWeight: FontWeight.w800),
                //   child: Text(
                //     '${widget.snap['likes'].length} likes',
                //     style: const TextStyle(
                //       color: Colors.black,
                //       fontSize: 15,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),

                // InkWell(
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 4),
                //     child: Text(
                //       'View all $commentLen comments',
                //       style: const TextStyle(
                //         fontSize: 14,
                //         color: secondaryColor,
                //       ),
                //     ),
                //   ),
                //   onTap: () => Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => CommentsScreen(
                //         postId: widget.snap['postId'].toString(),
                //       ),
                //     ),
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 135.0),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => CommentsScreen(
                //             postId: widget.snap['postId'].toString(),
                //           ),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.blue,
                //       onPrimary: secondaryColor,
                //       elevation: 0,
                //     ),
                //     child: Text(
                //       'Comments ($commentLen)',
                //       style: const TextStyle(fontSize: 13, color: Colors.white),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildDateAgo(DateTime datePublished) {
  final now = DateTime.now();
  final difference = now.difference(datePublished);

  if (difference.inDays > 0) {
    if (difference.inDays == 1) {
      return const Text(
        '1 day ago',
        style: TextStyle(
          fontSize: 12,
          color: secondaryColor,
        ),
      );
    } else {
      return Text(
        '${difference.inDays} days ago',
        style: const TextStyle(
          fontSize: 12,
          color: secondaryColor,
        ),
      );
    }
  } else if (difference.inHours > 0) {
    if (difference.inHours == 1) {
      return const Text(
        '1 hour ago',
        style: TextStyle(
          fontSize: 12,
          color: secondaryColor,
        ),
      );
    } else {
      return Text(
        '${difference.inHours} hours ago',
        style: const TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      );
    }
  } else {
    return const Text(
      'Just now',
      style: TextStyle(
        fontSize: 12,
        color: secondaryColor,
      ),
    );
  }
}
