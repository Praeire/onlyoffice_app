import 'package:flutter/material.dart';

import 'sideMenuDrawer.dart';
import 'folderContent.dart';
import 'network/myDocumentsProvider.dart';

class MyDocsContent extends StatefulWidget {
  @override
  _MyDocsContentState createState() => _MyDocsContentState();
}

class _MyDocsContentState extends State<MyDocsContent> {
  Future<MyDocumentsResponse> futureMyDocuments;

  @override
  void initState() {
    super.initState();
    futureMyDocuments = getMyDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenuDrawer(),
      appBar: AppBar(
        title: Text("Мои документы"),
      ),
      //backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: FutureBuilder<MyDocumentsResponse>(
          future: futureMyDocuments,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return fillFoldercontent(snapshot.data.response, context);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
