import 'package:flutter/material.dart';

import '../langs/lang.dart';

class DangerZone extends StatelessWidget {
  const DangerZone({Key key, @required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 4.0, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            child: Text(loc.dangerZone),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
          ),
          ...(children ?? []),
        ],
      ),
    );
  }
}
