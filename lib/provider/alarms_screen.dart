// import 'package:alarm/alarm.dart';
// import 'package:alarm/model/alarm_settings.dart';
// import 'package:flutter/material.dart';

// class AlarmsScreen extends StatefulWidget {
//   @override
//   _AlarmsScreenState createState() => _AlarmsScreenState();
// }

// class _AlarmsScreenState extends State<AlarmsScreen> {
//   List<AlarmSettings> _alarms = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadAlarms();
//   }

//   void _loadAlarms() async {
//     List<AlarmSettings> alarms = await Alarm.getAlarms();
//     setState(() {
//       _alarms = alarms;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alarms'),
//       ),
//       body: ListView.builder(
//         itemCount: _alarms.length,
//         itemBuilder: (context, index) {
//           AlarmSettings alarm = _alarms[index];
//           return ListTile(
//             title: Text(
//               '${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')}',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(
//               '${daysOfWeek[alarm.daysOfWeek.indexOf(true)]} - ${alarm.label}',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 color: Colors.grey[600],
//               ),
//             ),
//             trailing: Switch(
//               value: alarm.enabled,
//               onChanged: (value) {
//                 setState(() {
//                   alarm.enabled = value;
//                   alarm.save();
//                 });
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _createNewAlarm,
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _createNewAlarm() {
//     // Navigate to a screen where the user can create a new alarm
//   }
// }

// final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';

class AlarmsScreen extends StatefulWidget {
  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  List<AlarmSettings> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  void _clearAlarms() {
    setState(() {
      _alarms.clear();
      Alarm.stopAll();
    });
  }

  void _loadAlarms() {
    setState(() {
      _alarms = Alarm.getAlarms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarms'),
      ),
      body: ListView.builder(
        itemCount: _alarms.length,
        itemBuilder: (context, index) {
          final alarm = _alarms[index];
          return ListTile(
            title: Text(alarm.notificationTitle),
            subtitle: Text(
              '${alarm.dateTime.hour}:${alarm.dateTime.minute.toString().padLeft(2, '0')}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearAlarms,
        tooltip: 'Clear Alarms',
        child: Icon(Icons.delete),
      ),
    );
  }
}
