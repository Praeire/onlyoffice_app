import 'package:flutter/material.dart';

import 'folderContent.dart';

Widget docsFolderDetailCard(DocsFolder, context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FolderContent(
                  folderId: DocsFolder.id, folderName: DocsFolder.title)),
        );
      },
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(
                DocsFolder.title,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget docsFileDetailCard(DocsFile) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(DocsFile.title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.left),
            ),
          ],
        ),
      ),
    ),
  );
}
