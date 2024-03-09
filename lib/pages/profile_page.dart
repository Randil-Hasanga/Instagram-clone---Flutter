import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instaclone/services/firebase_services.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    print(_firebaseService!.currentUser!["name"]);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.05,
        horizontal: _deviceWidth! * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _profileImage(),
          _postGridview(),
        ],
      ),
    );
  }

  // Widget _profileImage() {
  //   return FutureBuilder(
  //     future: Future.value(_firebaseService!.currentUser!["image"]),
  //     builder: (BuildContext _context, AsyncSnapshot _snapshot) {
  //       if (_snapshot.hasData) {
  //         return Container(
  //           margin: EdgeInsets.only(bottom: _deviceHeight! * 0.02),
  //           height: _deviceHeight! * 0.15,
  //           width: _deviceHeight! * 0.15,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(100),
  //             image: DecorationImage(
  //               fit: BoxFit.cover,
  //               image: NetworkImage(
  //                 _snapshot.data,
  //               ),
  //             ),
  //           ),
  //         );
  //       } else {
  //         return const CircularProgressIndicator(
  //           color: Colors.red,
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _profileImage() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.02),
      height: _deviceHeight! * 0.15,
      width: _deviceHeight! * 0.15,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
          _firebaseService!.currentUser!["image"],
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ),
    );
  }

  Widget _postGridview() {
    return Expanded(
      child: StreamBuilder(
        stream: _firebaseService!.getUserPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _posts = snapshot.data!.docs.map((e) => e.data()).toList();
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  Map _post = _posts[index];
                  return Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        _post['image'],
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
