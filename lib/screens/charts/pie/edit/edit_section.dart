import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../models/chart.dart';
import '../../../../widgets/count_control.dart';
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
  PieChartSectionData section;

  @override
  Widget build(BuildContext context) {
    section = widget.chart.data.sections[widget.sectionIndex];
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
              labelText: 'Title',
            ),
            validator: (text) {
              if (text == null || text.isEmpty)
                return 'The name can NOT be null';
              return null;
            },
            autovalidateMode: AutovalidateMode.always,
            onFieldSubmitted: (text) {
              if (text == null || text.isEmpty) return;
            },
          ),
        ),
        Divider(),
        CountControl(
          value: section.value,
          onChanged: (v) => incrementValue(v - section.value),
        ),
        ColorPickerListTile(
          title: 'Section color',
          color: section.color,
          onChange: (color) => updateSection(color: color),
        ),
        SliderListTile(
          title: Text('Radius'),
          onChanged: (value) {
            // Use `update: false` to increase performance
            setState(() => updateSection(radius: value, update: false));
          },
          onChangeEnd: (value) => updateSection(radius: value),
          value: section.radius,
        ),
        CheckboxListTile(
          title: Text('Show title'),
          value: section.showTitle,
          onChanged: (value) => updateSection(showTitle: value),
        ),
      ],
    );
  }

  void updateSection({
    double value,
    double radius,
    Color color,
    bool showTitle,
    bool update = true,
  }) {
    final index = widget.chart.data.sections.indexOf(section);
    if (index == null || index.isNegative) return;
    final sections = widget.chart.data.sections
      ..removeAt(index)
      ..insert(
          index,
          section.copyWith(
            value: value,
            radius: radius,
            color: color,
            showTitle: showTitle,
          ));
    widget.chart.data = widget.chart.data.copyWith(sections: sections);
    if (update) {
      widget.onEdit(widget.chart);
      setState(() {});
    }
  }

  void incrementValue(num value) => updateSection(value: section.value + value);
}
