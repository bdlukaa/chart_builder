import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/theme.dart';
import '../../langs/lang.dart';

import 'lang.dart';

showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.8,
      initialChildSize: 0.8,
      builder: (_, controller) => SettingsHome(controller: controller),
    ),
  );
}

class SettingsHome extends StatelessWidget {
  const SettingsHome({Key key, @required this.controller}) : super(key: key);

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppTheme>();
    BaseLocalization loc = Localization.currentLocalization;
    return ListView(
      controller: controller,
      children: [
        ListTile(
          title: Text(
            loc.settings,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.invert_colors),
          title: Text(loc.appTheme),
          subtitle: Text(loc.themeName(theme.mode)),
          trailing: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Icon(
              getIconData(theme.mode),
              key: ValueKey<ThemeMode>(theme.mode),
            ),
            transitionBuilder: (child, animation) {
              if (animation.value == 1) return SizedBox();
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
          onTap: () {
            int index = ThemeMode.values.indexOf(theme.mode);
            if (index == 2)
              index = 0;
            else
              index++;
            theme.mode = ThemeMode.values[index];
          },
        ),
        ListTile(
          leading: Icon(Icons.language_sharp),
          title: Text(loc.language),
          subtitle: Text(loc.name),
          trailing: LocalizationFlag(),
          onTap: () => showLanguage(context),
        ),
      ],
    );
  }

  IconData getIconData(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return FontAwesomeIcons.moon;
      case ThemeMode.light:
        return FontAwesomeIcons.sun;
      case ThemeMode.system:
      default:
        return FontAwesomeIcons.circleNotch;
    }
  }
}
