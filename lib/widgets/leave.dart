import 'package:flutter/material.dart';

class SureWantToLeave extends StatelessWidget {
  const SureWantToLeave({
    Key key,
    @required this.onLeave,
    @required this.onSaveAndLeave,
  }) : super(key: key);

  final Function onLeave;
  final Function onSaveAndLeave;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure?'),
      content: Text(
        'Are you sure you want to leave without saving your progress?',
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      actions: [
        FlatButton(
          child: Text('Leave'),
          color: Colors.redAccent,
          onPressed: onLeave,
        ),
        FlatButton(
          child: Text('Save and Leave', style: TextStyle(color: Colors.white)),
          color: Colors.teal,
          onPressed: onSaveAndLeave,
        ),
        FlatButton(
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
          color: Colors.blue,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
