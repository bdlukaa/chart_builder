import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppTheme>();
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text('Settings')),
          IconButton(
            tooltip: 'Close',
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.invert_colors),
            title: Text('Theme'),
            subtitle: Text(nameThemeMode(theme.mode)),
            onTap: () {
              // TODO: change theme
            },
          ),
          ListTile(
            leading: Icon(Icons.language_sharp),
            title: Text('Language'),
            subtitle: Text('English'),
            onTap: () {
              // TODO: localize
            },
          ),
        ],
      ),
    );
  }
}
