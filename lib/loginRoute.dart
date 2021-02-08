import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';

import 'network/authorizationProvider.dart';
import 'myDocsContent.dart';
import 'network/selfProvider.dart';
import 'storageProvider.dart';

class LoginRoute extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onlyoffice test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(title: 'Onlyoffice test App'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController portalController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<dynamic> futureIsTokenExpired;
  @override
  void initState() {
    super.initState();
    futureIsTokenExpired = isTokenExpired('expires');
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        new ProgressDialog(context, isDismissible: false);

    final emailField = TextFormField(
      controller: emailController,
      validator: emailValidator,
      autofillHints: [AutofillHints.email],
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Регистрационный email",
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final passwordField = TextFormField(
      validator: passValidator,
      controller: passController,
      autofillHints: [AutofillHints.password],
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Пароль",
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final portalField = TextFormField(
      validator: portalValidator,
      controller: portalController,
      autofillHints: [AutofillHints.url],
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        prefixIcon: Text(
          'https://',
          style: style,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Адрес портала",
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            progressDialog.show();

            authorize(emailController.value.text, passController.value.text,
                    portalController.value.text, context, progressDialog)
                .then((value) {
              if (value.status == 0) {
                progressDialog.hide();
                processLogin(value, context);
              }
            });
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final String assetName = 'images/logo_new.svg';
    final Widget svg =
        SvgPicture.asset(assetName, semanticsLabel: 'images/logo_new.svg');

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: FutureBuilder<dynamic>(
              future: futureIsTokenExpired.then((value) => {
                    if (!value) {processBypassLogin(context)}
                  }),
              builder: (context, snapshot) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      svg,
                      SizedBox(height: 45.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(height: 25.0),
                      portalField,
                      SizedBox(
                        height: 35.0,
                      ),
                      loginButon,
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                );
                // By default, show a loading spinner.
                //  return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

  String emailValidator(value) {
    if (value.isEmpty) return 'Введите корректный email';

    /// regex pattern to validate email inputs.
    final Pattern _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]";

    if (RegExp(_emailPattern).hasMatch(value)) return null;

    return 'Введите корректный email';
  }

  String passValidator(value) {
    if (!value.isEmpty) return null;
    return 'Введите пароль';
  }

  String portalValidator(value) {
    if (value.isEmpty) return 'Введите корректный адрес портала';

    final Pattern _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.onlyoffice+\.[a-zA-Z]";

    if (RegExp(_emailPattern).hasMatch(value)) return null;
    return 'Введите корректный адрес портала';
  }

  void processLogin(AuthResponse value, BuildContext context) {
    String portalName = portalController.value.text;
    addStringToStorage('token', value.response.token);
    addStringToStorage('expires', value.response.expires);
    addStringToStorage('portalName', '$portalName');
    getSelfInfo().then((value) => {
          if (value.status == 0)
            {
              addStringToStorage('userName', value.response.userName),
              addStringToStorage('email', value.response.email),
              addStringToStorage('avatar', value.response.avatar),
              addStringToStorage('displayName', value.response.displayName),
            }
        });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyDocsContent()));
  }

  void processBypassLogin(BuildContext context) {
    getSelfInfo().then((value) => {
          if (value.status == 0)
            {
              addStringToStorage('userName', value.response.userName),
              addStringToStorage('email', value.response.email),
              addStringToStorage('avatar', value.response.avatar),
              addStringToStorage('displayName', value.response.displayName),
            }
        });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyDocsContent()));
  }

  void onError() {}
}

Future<bool> isTokenExpired(String key) async {
  String expirationDate = await getStringFromStorage('expires');
  String token = await getStringFromStorage('token');
  String portalName = await getStringFromStorage('portalName');

  if (expirationDate == null ||
      expirationDate.isEmpty ||
      token == null ||
      token.isEmpty ||
      portalName == null ||
      portalName.isEmpty) return true;

  DateTime expiration = DateTime.parse(expirationDate);
  if (expiration.isBefore(DateTime.now())) return true;

  return false;
}
