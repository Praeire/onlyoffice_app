import 'package:flutter/material.dart';

import 'sideMenuDrawer.dart';
import 'folderContent.dart';
import 'network/commonDocsProvider.dart';

class CommonDocsContent extends StatefulWidget {
  @override
  _CommonDocsContentState createState() => _CommonDocsContentState();
}

class _CommonDocsContentState extends State<CommonDocsContent> {
  Future<CommonDocumentsResponse> futureCommonDocuments;

  @override
  void initState() {
    super.initState();
    futureCommonDocuments = getCommonDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenuDrawer(),
      appBar: AppBar(
        title: Text("Общие файлы"),
      ),
      //backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: FutureBuilder<CommonDocumentsResponse>(
          future: futureCommonDocuments,
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
