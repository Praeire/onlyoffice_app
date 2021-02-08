import 'package:flutter_secure_storage/flutter_secure_storage.dart';

addStringToStorage(String key, String value) async {
  final storage = new FlutterSecureStorage();
  await storage.write(key: key, value: value);
}

getStringFromStorage(String key) async {
  final storage = new FlutterSecureStorage();
  return await storage.read(key: key);
}

removeStringFromStorage(String key) async {
  final storage = new FlutterSecureStorage();
  storage.delete(key: key);
}
