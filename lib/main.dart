import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/provider/alarms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'provider/main_ui.dart';
import 'provider/app_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: AlarmsScreen(),
        // home: const ExampleAlarmHomeScreen(),
      ),
    ),
  );
}




