import 'dart:io';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppState extends ChangeNotifier {
  void countPrint() {
    print('ok');
    print(Alarm.getAlarms().length);
  }

  int _noOfAccounts = 2;
  int _dmReqPerDay = 10;
  int _followReqPerDay = 30;
  int _warmupTime = 5; // in minutes
  List<DateTime> _sessions = [];
  var days = [true, true, true, true, true, true, true];

  

  static const String _sessionsKey = 'sessions';

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

  void updateSessionsAndSort(List<DateTime> sessions) { // set new dates and sort them
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    final newSessions =  sessions.map((session) {
      return DateTime(
        currentYear,
        currentMonth,
        session.day,
        session.hour,
        session.minute,
        session.second,
        session.millisecond,
        session.microsecond,
      );
    }).toList();

    _sessions = newSessions;
    _sessions.sort((a, b) => a.compareTo(b));

  }
   
  void _refreshAlarms() async {
    await Alarm.stopAll();
    updateSessionsAndSort(_sessions);
    print("wait");
    Future.delayed(Duration(seconds: 6), () {
    });
    _setAlarms();
    notifyListeners();
  }

  void _setAlarms() {
    for (var session in sessions) {
      _addAlarmsForSession(session);
    }
  }

  void addSession(DateTime session) {
    _sessions.add(session);
    // _sessions.sort((a, b) => a.timeOfDay.compareTo(b.timeOfDay));
    _addAlarmsForSession(session);
    saveSessionsToStorage();
  }

  void updateSession(DateTime oldSession, DateTime newSession) {
    int index = _sessions.indexOf(oldSession);
    if (index != -1) {
      _sessions[index] = newSession;
      // _sessions.sort((a, b) => a.timeOfDay.compareTo(b.timeOfDay));
      _refreshAlarms();
      saveSessionsToStorage();
    }
  }

  void removeSession(DateTime session) {
    _sessions.remove(session);
    _refreshAlarms();
    saveSessionsToStorage();
  }

  void _addAlarmsForSession(DateTime session) {
    for (int i = 0; i < noOfAccounts; i++) {
      int add = 1;
      // if current time is greater than session time alarms starting from next date
      if (session
          .add(Duration(minutes: _warmupTime * i))
          .isAfter(DateTime.now())) {
        add = 0;
      }
      for (int j = 0; j < 2; j++) {
        final alarmSettings = AlarmSettings(
          id: DateTime.now().microsecondsSinceEpoch % 10000 +
              Random().nextInt(10000),
          dateTime:
              session.add(Duration(minutes: _warmupTime * i, days: j + add)),
          loopAudio: true,
          vibrate: true,
          volume: 0.8,
          assetAudioPath: "assets/marimba.mp3",
          notificationTitle: 'Out Reach',
          notificationBody: 'Account ${i + 1}',
          enableNotificationOnKill: Platform.isIOS,
        );
        Alarm.set(alarmSettings: alarmSettings);
      }
    }
  }

  Future<void> loadSessionsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString(_sessionsKey);
    if (sessionsJson != null) {
      final sessions = List<DateTime>.from(
        json
            .decode(sessionsJson)
            .map((timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp)),
      );
      _sessions = sessions;
      _refreshAlarms();
      notifyListeners();
    }
  }

  Future<void> saveSessionsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = json.encode(
        _sessions.map((session) => session.millisecondsSinceEpoch).toList());
    await prefs.setString(_sessionsKey, sessionsJson);
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
