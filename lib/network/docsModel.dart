class DocsResponse {
  List<DocsFile> files;
  List<DocsFolder> folders;

  DocsResponse({this.files, this.folders});
  factory DocsResponse.fromJson(Map<String, dynamic> json) {
    var result = DocsResponse(
      files: (json['files'] as List).map((i) => DocsFile.fromJson(i)).toList(),
      folders:
          (json['folders'] as List).map((i) => DocsFolder.fromJson(i)).toList(),
      // startIndex: json['startIndex'],
      // count: json['count'],
      // total: json['total']
    );

    return result;
  }
}

class DocsFile {
  int folderId;
  String title;
  String fileExst;

  DocsFile({this.folderId, this.title, this.fileExst});

  factory DocsFile.fromJson(Map<String, dynamic> json) {
    return DocsFile(
        folderId: json['folderId'],
        title: json['title'],
        fileExst: json['fileExst']);
  }
}

class DocsFolder {
  int id;
  String title;

  DocsFolder({this.id, this.title});

  factory DocsFolder.fromJson(Map<String, dynamic> json) {
    return DocsFolder(id: json['id'], title: json['title']);
  }
}

class PathParts {
  String key;
  String path;

  PathParts({this.key, this.path});

  factory PathParts.fromJson(Map<String, dynamic> json) {
    return PathParts(key: json['key'], path: json['path']);
  }
}
