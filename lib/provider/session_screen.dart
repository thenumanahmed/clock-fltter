import 'package:alarm_example/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionsScreen extends StatefulWidget {
  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  DateTime? _selectedSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: appState.sessions.length,
                  itemBuilder: (context, index) {
                    final session = appState.sessions[index];
                    return ListTile(
                      title: Text(DateFormat('hh:mm a').format(session)),
                      subtitle: Text(DateFormat('EEE, MMM d').format(session)),
                      // title: Text(session.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _selectedSession = session;
                              _showTimePicker(context, _selectedSession!)
                                  .then((newTime) {
                                if (newTime != null) {
                                  Provider.of<AppState>(context, listen: false)
                                      .updateSession(
                                          _selectedSession!, newTime);
                                  _selectedSession = null;
                                  // Navigator.of(context).pop();
                                }
                              });
                              // _showEditDialog();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              appState.removeSession(session);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // _showAddDialog();
                          _showTimePicker(context,
                                  DateTime.now().add(Duration(minutes: 1)))
                              .then((newTime) {
                            if (newTime != null) {
                              Provider.of<AppState>(context, listen: false)
                                  .addSession(newTime);
                              _selectedSession = null;
                              // Navigator.of(context).pop();
                            }
                          });
                        },
                        child: Text('Add Session'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<DateTime?> _showTimePicker(
      BuildContext context, DateTime initialTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );
    if (pickedTime != null) {
      final newTime = DateTime(
        initialTime.year,
        initialTime.month,
        initialTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      return newTime;
    }
    return null;
  }
}
