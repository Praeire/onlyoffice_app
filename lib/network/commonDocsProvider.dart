import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'docsModel.dart';
import '../SharedPrefs.dart';
// GET api/2.0/files/@common
// Host: yourportal.onlyoffice.com

Future<CommonDocumentsResponse> getCommonDocuments() async {
  final String token = await getStringFromStorage('token');
  final String portalName = await getStringFromStorage('portalName');

  final http.Response response = await http.get(
      'https://$portalName/api/2.0/files/@common',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token
      });
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    CommonDocumentsResponse result =
        CommonDocumentsResponse.fromJson(responseJson);
    return result;
  } else {
    throw Exception('Failed to get data.');
  }
}

class CommonDocumentsResponse {
  int status;
  DocsResponse response;

  CommonDocumentsResponse({this.status, this.response});

  factory CommonDocumentsResponse.fromJson(Map<String, dynamic> parsedJson) {
    return CommonDocumentsResponse(
        status: parsedJson['status'],
        response: DocsResponse.fromJson(parsedJson['response']));
  }
}
