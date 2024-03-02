import 'package:flutter/material.dart';
import 'package:instaclone/pages/feed_page.dart';
import 'package:instaclone/pages/profile_page.dart';

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
            onTap: () {},
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
      body: _pages[_currentPage],
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
}
