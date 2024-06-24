import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function(String) onUpdate;

  EditDialog({
    required this.title,
    required this.initialValue,
    required this.onUpdate,
  });

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onUpdate(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}