import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppState extends ChangeNotifier {
  int _noOfAccount = 0;
  List<DateTime> _sessions = [];
  List<DateTime> _alarms = [];
  int _warmupTime = 5; // in minutes

  int get noOfAccount => _noOfAccount;
  List<DateTime> get sessions => _sessions;
  List<DateTime> get alarms => _alarms;
  int get warmupTime => _warmupTime;

  void setNoOfAccount(int value) {
    _noOfAccount = value;
    notifyListeners();
  }

  void setWarmupTime(int minutes) {
    _warmupTime = minutes;
    notifyListeners();
  }

  void addSession(DateTime session) {
    _sessions.add(session);
    _addAlarms(session);
    saveData();
    notifyListeners();
  }

  void removeSession(DateTime session) {
    _sessions.remove(session);
    _removeAlarms(session);
    saveData();
    notifyListeners();
  }

  void addAlarm(DateTime alarm) {
    _alarms.add(alarm);
    saveData();
    notifyListeners();
  }

  void removeAlarm(DateTime alarm) {
    _alarms.remove(alarm);
    saveData();
    notifyListeners();
  }

  void _addAlarms(DateTime session) {
    for (int i = 0; i < _noOfAccount; i++) {
      _alarms.add(session.add(Duration(minutes: _warmupTime * i)));
    }
  }

  void _removeAlarms(DateTime session) {
    _alarms.removeWhere((alarm) =>
        alarm.difference(session).inMinutes >= 0 &&
        alarm.difference(session).inMinutes < _noOfAccount * _warmupTime);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsString = prefs.getString('sessions');
    final alarmsString = prefs.getString('alarms');
    final warmupTime = prefs.getInt('warmupTime');

    if (sessionsString != null) {
      _sessions = (json.decode(sessionsString) as List<dynamic>)
          .map((dateTimeString) => DateTime.parse(dateTimeString))
          .toList();
    }

    if (alarmsString != null) {
      _alarms = (json.decode(alarmsString) as List<dynamic>)
          .map((dateTimeString) => DateTime.parse(dateTimeString))
          .toList();
    }

    if (warmupTime != null) {
      _warmupTime = warmupTime;
    }

    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsString = json.encode(_sessions.map((session) => session.toIso8601String()).toList());
    final alarmsString = json.encode(_alarms.map((alarm) => alarm.toIso8601String()).toList());
    await prefs.setString('sessions', sessionsString);
    await prefs.setString('alarms', alarmsString);
    await prefs.setInt('warmupTime', _warmupTime);
  }
}