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
          final sessions = List.from(appState.sessions)..sort((a, b) => a.compareTo(b));
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      title: Text(DateFormat('hh:mm a').format(session)),
                      subtitle: Text(DateFormat('EEE, MMM d').format(session)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showTimePicker(context, session)
                                .then((newTime) {
                              if (newTime != null) {
                                appState.updateSession(session, newTime);
                                setState(() {}); // Update the screen
                              }
                            }),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              appState.removeSession(session);
                              setState(() {}); // Update the screen
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
                        onPressed: () => _showTimePicker(context,
                                DateTime.now().add(Duration(minutes: 1)))
                            .then((newTime) {
                          if (newTime != null) {
                            appState.addSession(newTime);
                            setState(() {}); // Update the screen
                          }
                        }),
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
      return DateTime(
        initialTime.year,
        initialTime.month,
        initialTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
    return null;
  }
}