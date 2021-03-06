import 'package:flutter/material.dart';

import '../langs/lang.dart';

import 'danger_zone.dart';
import 'tiles.dart';

showOptionsSheet(BuildContext context, Function onDelete, Function onEdit) {
  showModalBottomSheet(
    context: context,
    builder: (_) => CardOptions(
      onDelete: onDelete,
      onEdit: onEdit,
    ),
  );
}

class CardOptions extends StatelessWidget {
  const CardOptions({
    Key key,
    @required this.onDelete,
    @required this.onEdit,
  }) : super(key: key);

  final Function onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return Column(
      children: [
        ListTile(
          title: Text(
            loc.options,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListTile(
          title: Text(loc.editButton, style: TextStyle(color: Colors.blue)),
          trailing: Icon(Icons.edit, color: Colors.blue),
          onTap: onEdit,
        ),
        DangerZone(children: [DeleteChartTile(onDelete: onDelete)]),
      ],
    );
  }
}
