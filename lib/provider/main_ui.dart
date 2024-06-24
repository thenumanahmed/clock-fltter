import 'dart:async';

import 'package:alarm_example/provider/alarms_screen.dart';
import 'package:alarm_example/provider/days_row.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';

import './app_provider.dart';
import 'edit_dialog.dart';
import 'notify_screen.dart';
import 'session_screen.dart';

class MainUI extends StatefulWidget {
  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  @override
  void initState() {
    super.initState();
     Provider.of<AppState>(context, listen: false).loadSessionsFromStorage( );
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }

    // Register a listener for the Alarm.ringStream directly
    Alarm.ringStream.stream.listen(navigateToNotifyScreen);
  }

  Future<void> navigateToNotifyScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => NotifyScreen(alarmSettings: alarmSettings),
      ),
    );
    // loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Out Reach Helper'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("No of Accounts: " +
                        Provider.of<AppState>(context, listen: false)
                            .noOfAccounts
                            .toString()),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditDialog(
                              title: 'Edit No of Accounts',
                              initialValue:
                                  Provider.of<AppState>(context, listen: false)
                                      .noOfAccounts
                                      .toString(),
                              onUpdate: (newValue) {
                                Provider.of<AppState>(context, listen: false)
                                    .updateNoOfAccounts(int.parse(newValue));
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
               Row(
                children: [
                  Expanded(
                    child: Text("Warm Up Time in minutes: " +
                        Provider.of<AppState>(context, listen: false)
                            .warmupTime
                            .toString()),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditDialog(
                              title: 'Edit Warm Up Time',
                              initialValue:
                                  Provider.of<AppState>(context, listen: false)
                                      .warmupTime
                                      .toString(),
                              onUpdate: (newValue) {
                                Provider.of<AppState>(context, listen: false)
                                    .updateWarmupTime(int.parse(newValue));
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("DM Per Day: " +
                        Provider.of<AppState>(context, listen: false)
                            .dmReqPerDay
                            .toString()),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditDialog(
                              title: 'DM Per Day',
                              initialValue:
                                  Provider.of<AppState>(context, listen: false)
                                      .dmReqPerDay
                                      .toString(),
                              onUpdate: (newValue) {
                                Provider.of<AppState>(context, listen: false)
                                    .updateDmReqPerDay(int.parse(newValue));
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              DaysRow(),  
              Row(
                children: [
                  Expanded(
                    child: Text("Follow Requests Per Day: " +
                        Provider.of<AppState>(context, listen: true)
                            .followReqPerDay
                            .toString()),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditDialog(
                              title: 'Edit Follow Req Per Day',
                              initialValue:
                                  Provider.of<AppState>(context, listen: false)
                                      .followReqPerDay
                                      .toString(),
                              onUpdate: (newValue) {
                                Provider.of<AppState>(context, listen: false)
                                    .updateFollowReqPerDay(int.parse(newValue));
                                
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionsScreen(),
                    ),
                  );
                },
                child: Text('Show Sessions'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Provider.of<AppState>(context, listen: false)
                  //     .countPrint(); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlarmsScreen(),
                    )
                  );
                },
                child: Text('Show Accounts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SessionsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sessions'),
//       ),
//       body: Consumer<AppState>(
//         builder: (context, appState, child) {
//           return ListView.builder(
//             itemCount: appState.sessions.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(appState.sessions[index].toString()),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class AccountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Center(
            child: Text('Number of Accounts: ${appState.noOfAccounts}'),
          );
        },
      ),
    );
  }
}
