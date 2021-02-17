import 'package:flutter/material.dart';

import '../langs/lang.dart';

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
    BaseLocalization loc = Localization.currentLocalization;
    return AlertDialog(
      title: Text(loc.areYouSure),
      content: Text(loc.areYouSureDescription),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      actions: [
        FlatButton(
          child: Text(loc.leave),
          color: Colors.redAccent,
          onPressed: onLeave,
        ),
        FlatButton(
          child: Text(loc.saveAndLeave, style: TextStyle(color: Colors.white)),
          color: Colors.teal,
          onPressed: onSaveAndLeave,
        ),
        FlatButton(
          child: Text(loc.dismiss, style: TextStyle(color: Colors.white)),
          color: Colors.blue,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
