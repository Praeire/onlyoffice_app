import 'dart:async';
import 'package:http/http.dart' as http;

import '../SharedPrefs.dart';

// GET api/2.0/people/@self
// Host: yourportal.onlyoffice.com
// Content-Type: application/json
// Accept: application/json

Future<dynamic> getAvatarImage(String url) async {
  final String token = await getStringFromStorage('token');
  final http.Response response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Authorization': token
  });
  if (response.statusCode == 200) {
    var result = response.bodyBytes;
    return result;
  } else {
    throw Exception('Failed to get data.');
  }
}
