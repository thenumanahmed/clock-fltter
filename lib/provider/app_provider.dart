import 'dart:io';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/service/alarm_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppState extends ChangeNotifier {
  int _noOfAccounts = 2;
  int _dmReqPerDay = 10;
  int _followReqPerDay = 30;
  int _warmupTime = 5; // in minutes
  List<DateTime> _sessions = [];

  int get noOfAccounts => _noOfAccounts;
  int get followReqPerDay => _followReqPerDay;
  int get dmReqPerDay => _dmReqPerDay;
  int get warmupTime => _warmupTime;
  List<DateTime> get sessions => _sessions;

  void updateDmReqPerDay(int value) {
    _dmReqPerDay = value;
    _refreshAlarms();
  }

  void updateFollowReqPerDay(int value) {
    _followReqPerDay = value;
    _refreshAlarms();
  }

  void updateNoOfAccounts(int value) {
    _noOfAccounts = value;
    _refreshAlarms();
  }

  void updateWarmupTime(int minutes) {
    _warmupTime = minutes;
    _refreshAlarms();
  }

  void _refreshAlarms() {
    clearAlarms();
    _setAlarms();
    notifyListeners();
  }

  void clearAlarms() {
    Alarm.stopAll();
  }

  void _setAlarms() {
    for (var session in sessions) {
      _addAlarmsForSession(session);
    }
  }

  void addSession(DateTime session) {
    _sessions.add(session);
    _addAlarmsForSession(session);
  }

  void updateSession(DateTime oldSession, DateTime newSession) {
    int index = _sessions.indexOf(oldSession);
    if (index != -1) {
      _sessions[index] = newSession;
      _refreshAlarms();
    }
  }

  void removeSession(DateTime session) {
    _sessions.remove(session);
    _refreshAlarms();
  }

  void _addAlarmsForSession(DateTime session) {
    
    for (int i = 0; i < 4; i++) {
      int add = 1;
      // if current time is greater than session time alarms starting from next date
      if(session.add(Duration(minutes: _warmupTime * i)).isAfter(DateTime.now())){
        add = 0;
      }
      for (int j = 0; j < 7; j++) {
        final alarmSettings = AlarmSettings(
          id: DateTime.now().millisecondsSinceEpoch % 10000 +
              Random().nextInt(1000),
          dateTime: session.add(Duration(minutes: _warmupTime * i, days: j+ add)),
          loopAudio: true,
          vibrate: true,
          volume: 0.3,
          assetAudioPath: "assets/marimba.mp3",
          notificationTitle: 'Out Reach',
          notificationBody: 'Account ${i + 1}',
          enableNotificationOnKill: Platform.isIOS,
        );
        Alarm.set(alarmSettings: alarmSettings);
      }
    }
  }

  // Future<void> loadData() async { // copmlete
  //   final prefs = await SharedPreferences.getInstance();
  //   final sessionsString = prefs.getString('sessions');
  //   final warmupTime = prefs.getInt('warmupTime');
  //   final accounts = prefs.getInt('accou');

  //   if (sessionsString != null) { // copmlete
  //     _sessions = (json.decode(sessionsString) as List<dynamic>)
  //         .map((dateTimeString) => DateTime.parse(dateTimeString))
  //         .toList();
  //   }

  //   if (warmupTime != null) { // copmlete
  //     _warmupTime = warmupTime;
  //   }

  //   notifyListeners();
  // }

  // Future<void> saveData() async { // copmlete
  //   final prefs = await SharedPreferences.getInstance();
  //   final sessionsString = json
  //       .encode(_sessions.map((session) => session.toIso8601String()).toList());
  //   // final alarmsString =
  //   //     json.encode(_alarms.map((alarm) => alarm.toIso8601String()).toList());
  //   await prefs.setString('sessions', sessionsString);
  //   // await prefs.setString('alarms', alarmsString);
  //   await prefs.setInt('warmupTime', _warmupTime);
  // }
}
