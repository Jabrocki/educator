import 'package:flutter/material.dart';

//SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class MainState extends ChangeNotifier {
  //SharedPrefernces
  SharedPreferences? _prefs;

  //Settings
  bool _rememberUser = false;

  //User info
  int? _userId;
  String? _userName;

  //Choosen subject in menu card
  late int _subjectId;

  set subjectId(int subjectId) {
    _subjectId = subjectId;
    notifyListeners();
  }

  int get subjectId => _subjectId;

  //Init of SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _rememberUser = _prefs?.getBool('rememberUser') ?? false;
    _userId = _prefs?.getInt("userId");
    _userName = _prefs?.getString("userName");
    notifyListeners();
  }
  //Setters
  set userId(int? userId){
    _userId = userId;
    _prefs?.setInt("userId", userId!);
    notifyListeners();
  }

  set userName(String? userName){
    _userName = userName;
    _prefs?.setString("userName", userName!);
    notifyListeners();
  }

  set rememberUser(bool rememberUser) {
    _rememberUser = rememberUser;
    _prefs?.setBool("rememberUser",rememberUser);
    notifyListeners();
  }

  //Getters
  int? get userId => _userId;
  String? get userName => _userName;
  bool get rememberUser => _rememberUser;
}