// import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(key);
    return result;
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<List<String>?> readList(String key) async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString(key);
    if (jsonString != null) {
      final List<dynamic> decodeList = json.decode(jsonString);
      return decodeList.cast<String>();
    }
    return null;
  }

  Future<void> saveList(String key, List<String> value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, json.encode(value));
  }
}
