import 'package:flutter/material.dart';
import 'package:onlyofficeapp/network/docsModel.dart';
import 'network/folderByIdProvider.dart';
import 'cardWidgets.dart';

class FolderContent extends StatefulWidget {
  int folderId;
  String folderName;
  FolderContent({this.folderId, this.folderName});

  @override
  _FolderContentState createState() => _FolderContentState();
}

class _FolderContentState extends State<FolderContent> {
  int folderId;
  String folderName;
  _FolderContentState({this.folderId, this.folderName});
  Future<FolderByIDResponse> futureFolderByID;

  @override
  void initState() {
    super.initState();
    futureFolderByID = getFolderByID(widget.folderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: FutureBuilder<FolderByIDResponse>(
          future: futureFolderByID,
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

StatelessWidget fillFoldercontent(DocsResponse response, BuildContext context) {
  if (response.folders.length > 0 || response.files.length > 0) {
    return ListView(
      children: <Widget>[
        Column(
            children: response.folders.map((p) {
          return docsFolderDetailCard(p, context);
        }).toList()),
        Column(
            children: response.files.map((p) {
          return docsFileDetailCard(p);
        }).toList()),
      ],
    );
  } else {
    return Text('Папка пуста');
  }
}
