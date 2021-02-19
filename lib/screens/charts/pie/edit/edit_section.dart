import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../models/chart.dart';
import '../../../../langs/lang.dart';
import '../../../../widgets/tiles.dart';

Future<void> showEditSection(
  BuildContext context,
  Chart<PieChartData> chart,
  OnEditChart<PieChartData> onEdit,
  int sectionIndex,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.8,
        initialChildSize: 0.8,
        builder: (context, controller) {
          return EditSection(
            controller: controller,
            chart: chart,
            onEdit: onEdit,
            sectionIndex: sectionIndex,
          );
        },
      );
    },
  );
}

class EditSection extends StatefulWidget {
  const EditSection({
    Key key,
    this.controller,
    @required this.chart,
    @required this.sectionIndex,
    @required this.onEdit,
  }) : super(key: key);

  final ScrollController controller;
  final Chart<PieChartData> chart;
  final int sectionIndex;
  final OnEditChart<PieChartData> onEdit;

  @override
  _EditSectionState createState() => _EditSectionState();
}

class _EditSectionState extends State<EditSection> {
  Chart<PieChartData> chart;
  PieChartSectionData section;

  @override
  void initState() {
    super.initState();
    chart = widget.chart.createCopy();
  }

  @override
  Widget build(BuildContext context) {
    section = chart.data.sections[widget.sectionIndex];
    BaseLocalization loc = Localization.currentLocalization;
    return ListView(
      controller: widget.controller,
      children: [
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextFormField(
            initialValue: section.title,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: loc.title,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) return loc.canNotBeEmpty;
              return null;
            },
            autovalidateMode: AutovalidateMode.always,
            onFieldSubmitted: (text) {
              if (text == null || text.isEmpty) return;
              updateSection(title: text);
            },
          ),
        ),
        Divider(),
        SliderListTile(
          title: Text(loc.value),
          onChanged: (value) {
            // Use `update: false` to increase performance
            setState(() => updateSection(value: value, update: false));
          },
          onChangeEnd: (value) => updateSection(value: value),
          max: 100,
          value: section.value,
        ),
        ColorPickerListTile(
          title: loc.sectionColor,
          color: section.color,
          onChange: (color) => updateSection(color: color),
        ),
        SliderListTile(
          title: Text(loc.radius),
          onChanged: (value) {
            // Use `update: false` to increase performance
            setState(() => updateSection(radius: value, update: false));
          },
          onChangeEnd: (value) => updateSection(radius: value),
          value: section.radius,
        ),
        Divider(),
        CheckboxListTile(
          title: Text(loc.showTitle),
          value: section.showTitle,
          onChanged: (value) => updateSection(showTitle: value),
        ),
        SliderListTile(
          title: Text(loc.titlePosition),
          onChanged: (value) {
            // Use `update: false` to increase performance
            setState(() => updateSection(
                  titlePositionPercentageOffset: value - 1,
                  update: false,
                ));
          },
          onChangeEnd: (value) => updateSection(
            titlePositionPercentageOffset: value - 1,
          ),
          min: 0,
          max: 2,
          value: section.titlePositionPercentageOffset + 1,
        ),
      ],
    );
  }

  void updateSection({
    String title,
    double value,
    double radius,
    double titlePositionPercentageOffset,
    Color color,
    bool showTitle,
    bool update = true,
  }) {
    final index = chart.data.sections.indexOf(section);
    if (index == null || index.isNegative) return;
    final sections = chart.data.sections
      ..removeAt(index)
      ..insert(
        index,
        section.copyWith(
          title: title,
          value: value,
          radius: radius,
          color: color,
          showTitle: showTitle,
          titlePositionPercentageOffset: titlePositionPercentageOffset,
        ),
      );
    chart.data = chart.data.copyWith(sections: sections);
    if (update) {
      widget.onEdit(chart);
      setState(() {});
    }
  }

  void incrementValue(num value) => updateSection(value: section.value + value);
}
