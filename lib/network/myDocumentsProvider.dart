import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'docsModel.dart';
import '../SharedPrefs.dart';
// GET api/2.0/files/@my
// Host: yourportal.onlyoffice.com

Future<MyDocumentsResponse> getMyDocuments() async {
  final String token = await getStringFromStorage('token');
  final String portalName = await getStringFromStorage('portalName');

  final http.Response response = await http
      .get('https://$portalName/api/2.0/files/@my', headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Authorization': token
  });
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    MyDocumentsResponse result = MyDocumentsResponse.fromJson(responseJson);
    return result;
  } else {
    throw Exception('Failed to get data.');
  }
}

class MyDocumentsResponse {
  int status;
  DocsResponse response;

  MyDocumentsResponse({this.status, this.response});

  factory MyDocumentsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return MyDocumentsResponse(
        status: parsedJson['status'],
        response: DocsResponse.fromJson(parsedJson['response']));
  }
}
