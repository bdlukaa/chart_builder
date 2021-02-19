import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../models/chart.dart';
import '../../../../langs/lang.dart';
import '../../../../widgets/tiles.dart';
import '../../../../widgets/danger_zone.dart';
import '../../../../utils/theme.dart';

import 'edit_section.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({
    Key key,
    @required this.chart,
    @required this.requestUpdate,
    @required this.nameController,
    this.onDelete,
    this.onDismiss,
  }) : super(key: key);

  final Chart<PieChartData> chart;
  final OnEditChart<PieChartData> requestUpdate;
  final TextEditingController nameController;
  final Function onDelete;
  final Function(
    BuildContext context,
    PieChartSectionData section,
  ) onDismiss;

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo>
    with AutomaticKeepAliveClientMixin {
  Chart<PieChartData> get chart => widget.chart;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BaseLocalization loc = Localization.currentLocalization;
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10) + EdgeInsets.only(bottom: 60),
      children: [
        TextFormField(
          controller: widget.nameController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: loc.chartName,
          ),
          autovalidateMode: AutovalidateMode.always,
          validator: (text) {
            if (text == null || text.isEmpty) return loc.canNotBeEmpty;
            return null;
          },
          onFieldSubmitted: (text) {
            if (text == null || text.isEmpty) return;
            widget.requestUpdate(chart..name = text);
          },
        ),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.rotationDegree),
              Spacer(),
              Text(
                chart.data.startDegreeOffset.toStringAsPrecision(3) + '/360',
              ),
            ],
          ),
          value: chart.data.startDegreeOffset,
          max: 360,
          title: SizedBox(),
          count: SizedBox(),
          onChanged: (v) {
            chart.data = chart.data.copyWith(startDegreeOffset: v);
            widget.requestUpdate(chart);
          },
        ),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.sectionsSpace),
              Spacer(),
              Text(
                chart.data.sectionsSpace.toStringAsPrecision(3) + '/100',
              ),
            ],
          ),
          value: chart.data.sectionsSpace,
          max: 100,
          title: SizedBox(),
          count: SizedBox(),
          onChanged: (v) {
            chart.data = chart.data.copyWith(sectionsSpace: v);
            widget.requestUpdate(chart);
          },
        ),
        ColorPickerListTile(
          title: loc.backgroundColor,
          color: chart.backgroundColor,
          onChange: (color) {
            chart.backgroundColor = color;
            widget.requestUpdate(chart);
          },
        ),
        _buildTitle(context, Text(loc.center)),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.centerSpaceRadius),
              Spacer(),
              Text(
                chart.data.centerSpaceRadius.toStringAsPrecision(3) + '/100',
              ),
            ],
          ),
          value: chart.data.centerSpaceRadius,
          max: 100,
          title: SizedBox(),
          count: SizedBox(),
          onChanged: (v) {
            chart.data = chart.data.copyWith(centerSpaceRadius: v);
            widget.requestUpdate(chart);
          },
        ),
        ColorPickerListTile(
          title: loc.centerSpaceColor,
          color: chart.data.centerSpaceColor,
          onChange: (color) {
            chart.data = chart.data.copyWith(centerSpaceColor: color);
            widget.requestUpdate(chart);
          },
        ),
        _buildTitle(
          context,
          Text(loc.border),
          trailing: Checkbox(
            value: chart.data.borderData.show,
            onChanged: (value) => updateBorder(show: value),
          ),
        ),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.borderWidth),
              Spacer(),
              Text(
                chart.data.borderData.border.top.width.toStringAsPrecision(3) +
                    '/100',
              ),
            ],
          ),
          value: chart.data.borderData.border.top.width,
          max: 100,
          title: SizedBox(),
          count: SizedBox(),
          onChanged: (v) => updateBorder(width: v, update: false),
          onChangeEnd: (v) => updateBorder(width: v, update: true),
        ),
        ColorPickerListTile(
          title: loc.borderColor,
          color: chart.data.borderData.border.top.color,
          onChange: (color) => updateBorder(color: color),
        ),
        _buildTitle(
          context,
          Text(loc.sections),
          trailing: IconButton(
            tooltip: loc.add,
            icon: Icon(Icons.add),
            onPressed: () {
              chart.data.sections.add(PieChartSectionData(
                title: 'Section ${chart.data.sections.length + 1}',
                radius: 100,
                color: colors.random(),
              ));
              widget.requestUpdate(chart);
            },
            splashRadius: 16,
          ),
        ),
        if (chart.data.sections.isNotEmpty) ...[
          ...List.generate(
            chart.data.sections.length,
            (index) {
              final section = chart.data.sections[index];
              return SectionTile(
                section: section,
                onEdit: () {
                  showEditSection(
                    context,
                    chart,
                    widget.requestUpdate,
                    index,
                  ).then((_) {
                    widget.requestUpdate(chart);
                  });
                },
                confirmDismiss: (_) async {
                  // There must be at least one section
                  return chart.data.sections.length != 1;
                },
                onDismiss: widget.onDismiss,
              );
            },
          ),
          Text(
            loc.slideToSideToDeleteSection,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
        DangerZone(children: [DeleteChartTile(onDelete: widget.onDelete)]),
        Divider(),
      ],
    );
  }

  void updateBorder({
    bool show,
    double width,
    Color color,
    bool update = true,
  }) {
    final border = chart.data.borderData;
    chart.data = chart.data.copyWith(
      borderData: FlBorderData(
        show: show ?? border.show,
        border: Border.all(
          color: color ?? border.border.top.color,
          width: width ?? border.border.top.width,
        ),
      ),
    );
    if (update) widget.requestUpdate(chart);
  }

  Widget _buildTitle(
    BuildContext context,
    Widget title, {
    Widget trailing,
    Color dividerColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DefaultTextStyle(
            child: title,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(width: 4),
          Expanded(child: Divider(color: dividerColor)),
          trailing ?? SizedBox(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
