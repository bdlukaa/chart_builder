import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

import '../../langs/lang.dart';

showLanguage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.7,
      builder: (_, controller) => PickLanguage(controller: controller),
    ),
  );
}

class PickLanguage extends StatelessWidget {
  const PickLanguage({Key key, @required this.controller}) : super(key: key);

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final BaseLocalization loc = Localization.currentLocalization;
    final List<Localization> locs = Localization.localizations.toList();
    locs.remove(loc);
    locs.insert(0, loc);
    return ListView(
      controller: controller,
      children: [
        ListTile(
          title: Text(
            loc.language,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Divider(),
        ...List.generate(Localization.localizations.length, (index) {
          BaseLocalization localization = locs[index];
          return ListTile(
            selected: loc == localization,
            title: Text(localization.name),
            subtitle: Text(localization.code),
            onTap: () {
              if (Localization.currentLocalization == localization) return;
              Localization.currentLocalization = localization;
            },
            trailing: LocalizationFlag(loc: localization),
          );
        }),
      ],
    );
  }
}

class LocalizationFlag extends StatelessWidget {
  const LocalizationFlag({Key key, this.loc}) : super(key: key);

  final BaseLocalization loc;

  @override
  Widget build(BuildContext context) {
    final BaseLocalization localization =
        loc ?? Localization.currentLocalization;
    return SizedBox(
      width: 50,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Flag(localization.flag),
      ),
    );
  }
}
