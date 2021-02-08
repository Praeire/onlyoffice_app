import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../SharedPrefs.dart';

// GET api/2.0/people/@self
// Host: yourportal.onlyoffice.com
// Content-Type: application/json
// Accept: application/json

Future<SelfInfo> getSelfInfo() async {
  final String token = await getStringFromStorage('token');
  final String portalName = await getStringFromStorage('portalName');
  var url = 'https://$portalName/api/2.0/people/@self';
  final http.Response response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Authorization': token
  });
  final responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    SelfInfo result = SelfInfo.fromJson(responseJson);
    return result;
  } else {
    throw Exception('Failed to get data.');
  }
}

class SelfInfo {
  int status;
  SelfInfoResponse response;

  SelfInfo({this.status, this.response});

  factory SelfInfo.fromJson(Map<String, dynamic> parsedJson) {
    return SelfInfo(
        status: parsedJson['status'],
        response: SelfInfoResponse.fromJson(parsedJson['response']));
  }
}

class SelfInfoResponse {
  String userName;
  String email;
  String avatar;
  String displayName;

  SelfInfoResponse({this.userName, this.email, this.avatar, this.displayName});

  factory SelfInfoResponse.fromJson(Map<String, dynamic> json) {
    return SelfInfoResponse(
        userName: json['userName'],
        email: json['email'],
        avatar: json['avatarMedium'],
        displayName: json['displayName']);
  }
}
