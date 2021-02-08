import 'dart:async';
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../dialogShower.dart';

Future<AuthResponse> authorize(String email, String pass, String portalName,
    BuildContext context, ProgressDialog progressDialog) async {
  var url = 'https://$portalName/api/2.0/authentication.json';
  // showMyDialog(context, url);
  try {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{'userName': email, 'password': pass}),
    );

    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 201) {
      AuthResponse result = AuthResponse.fromJson(responseJson);
      if (progressDialog.isShowing()) progressDialog.hide();
      return result;
    } else {
      if (progressDialog.isShowing()) progressDialog.hide();
      ErrorResponse errorResponse = ErrorResponse.fromJson(responseJson);
      showMyDialog(context, errorResponse.error.message);
    }
  } catch (e) {
    if (progressDialog.isShowing()) progressDialog.hide();
    showMyDialog(context, e.toString());
  }
  if (progressDialog.isShowing()) progressDialog.hide();
}

class AuthResponse {
  int status;
  Response response;

  AuthResponse({this.status, this.response});
  factory AuthResponse.fromJson(Map<String, dynamic> parsedJson) {
    return AuthResponse(
        status: parsedJson['status'],
        response: Response.fromJson(parsedJson['response']));
  }
}

class Response {
  String token;
  String expires;

  Response({this.token, this.expires});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(token: json['token'], expires: json['expires']);
  }
}

class ErrorResponse {
  int status;
  Error error;

  ErrorResponse({this.status, this.error});
  factory ErrorResponse.fromJson(Map<String, dynamic> parsedJson) {
    return ErrorResponse(
        status: parsedJson['status'],
        error: Error.fromJson(parsedJson['error']));
  }
}

class Error {
  String message;

  Error({this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(message: json['message']);
  }
}
