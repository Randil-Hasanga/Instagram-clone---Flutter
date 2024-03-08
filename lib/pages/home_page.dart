import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instaclone/pages/feed_page.dart';
import 'package:instaclone/pages/profile_page.dart';
import 'package:instaclone/services/firebase_services.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

//appbar
//bottom bar
//navigation

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  final List<Widget> _pages = [
    FeedPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "InstaClone",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _postImage();
            },
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavigation(),
      body: _pages[_currentPage], // show page
    );
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (_index) {
        // getting index from items list
        setState(() {
          _currentPage = _index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Feed',
          icon: Icon(Icons.feed),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.account_box),
        ),
      ],
    );
  }

  void _postImage() async {

    FilePickerResult? _result = await FilePicker.platform.pickFiles(type: FileType.image);
    File _image = File(_result!.files.first.path!);

    await _firebaseService!.postImage(_image);
  }
}
