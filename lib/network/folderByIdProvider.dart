import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'docsModel.dart';
import '../SharedPrefs.dart';
// GET api/2.0/files/some+text?userIdOrGroupId=9924256A-739C-462b-AF15-E652A3B1B6EB&filterType=none
// Host: yourportal.onlyoffice.com
// Content-Type: application/json
// Accept: application/json

Future<FolderByIDResponse> getFolderByID(int folderId) async {
  final String token = await getStringFromStorage('token');
  final String portalName = await getStringFromStorage('portalName');

  final http.Response response = await http.get(
      'https://$portalName/api/2.0/files/$folderId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token
      });
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    FolderByIDResponse result = FolderByIDResponse.fromJson(responseJson);
    return result;
  } else {
    throw Exception('Failed to get data.');
  }
}

class FolderByIDResponse {
  int status;
  DocsResponse response;

  FolderByIDResponse({this.status, this.response});

  factory FolderByIDResponse.fromJson(Map<String, dynamic> parsedJson) {
    return FolderByIDResponse(
        status: parsedJson['status'],
        response: DocsResponse.fromJson(parsedJson['response']));
  }
}
