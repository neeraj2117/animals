import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:straybud/screens/add_post_screen.dart';
import 'package:straybud/screens/adopt.dart';
import 'package:straybud/screens/feed_screen.dart';
import 'package:straybud/screens/profile_screen.dart';
import 'package:straybud/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const AdoptScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
