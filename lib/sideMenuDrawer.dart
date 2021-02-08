import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';

import 'myDocsContent.dart';
import 'loginRoute.dart';
import 'storageProvider.dart';
import 'commonDocsContent.dart';
import 'network/avatarImageProvider.dart';

class SideMenuDrawer extends StatefulWidget {
  @override
  _SideMenuDrawerState createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  Future<dynamic> futureGetName;
  Future<dynamic> futureGetEmail;
  Future<dynamic> futureGetAvatar;
  @override
  void initState() {
    super.initState();
    futureGetName = getStringFromStorage('displayName');
    futureGetEmail = getStringFromStorage('email');
    futureGetAvatar = getAvatarUrl('avatar');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FutureBuilder<dynamic>(
                        future: futureGetAvatar,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data;
                            // return CachedNetworkImage(
                            //   placeholder: (context, url) =>
                            //       CircularProgressIndicator(
                            //     valueColor: new AlwaysStoppedAnimation<Color>(
                            //         Colors.grey),
                            //   ),
                            //   imageUrl: snapshot.data.toString(),
                            // );
                          } else if (snapshot.hasError) {
                            return Image.asset(
                              'images/default_user_photo.png',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            );
                          }
                          return Image.asset(
                            'images/default_user_photo.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          );
                          // By default, show a loading spinner.
                          // return CircularProgressIndicator();
                        },
                      ),
                      FutureBuilder<dynamic>(
                        future: futureGetName,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                      FutureBuilder<dynamic>(
                        future: futureGetEmail,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Flexible(
                                child: Text(
                              snapshot.data.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.left,
                            ));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
              // leading: Icon(Icons.input),
              title: Text('Мои Документы'),
              onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => MyDocsContent()),
                    )
                  }),
          ListTile(
            // leading: Icon(Icons.verified_user),
            title: Text('Общие файлы'),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => CommonDocsContent()),
              )
            },
          ),
          ListTile(
            // leading: Icon(Icons.exit_to_app),
            title: Text('Выйти'),
            onTap: () => {processLogout()},
          ),
        ],
      ),
    );
  }

  processLogout() {
    removeStringFromStorage("token");
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => LoginRoute()),
      (route) => false,
      // ModalRoute.withName('/'),
    );
  }
}

getAvatarUrl(String key) async {
  String imageUrl = await getStringFromStorage(key);

  if (!imageUrl.contains('http')) {
    String portalName = await getStringFromStorage('portalName');
    imageUrl = 'https://$portalName$imageUrl';
  }

  final Uint8List bytes = await getAvatarImage(imageUrl);
  var image = Image.memory(bytes);

  return image;
}
