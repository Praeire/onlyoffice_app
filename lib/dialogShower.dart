import 'package:flutter/material.dart';

showMyDialog(context, String error) {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ошибка'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(error),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ок'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
