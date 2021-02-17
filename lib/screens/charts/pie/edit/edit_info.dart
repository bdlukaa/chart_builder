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
            labelText: loc.name,
          ),
          autovalidateMode: AutovalidateMode.always,
          validator: (text) {
            if (text == null || text.isEmpty) return loc.canNotBeEmpty;
            return null;
          },
          onFieldSubmitted: (text) {
            if (text == null || text.isEmpty) return;
            widget.chart.name = text;
            widget.requestUpdate(widget.chart);
          },
        ),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.rotationDegree),
              Spacer(),
              Text(
                widget.chart.data.startDegreeOffset.toStringAsPrecision(3) +
                    '/360',
              ),
            ],
          ),
          value: widget.chart.data.startDegreeOffset,
          max: 360,
          count: SizedBox(),
          onChanged: (v) {
            widget.chart.data =
                widget.chart.data.copyWith(startDegreeOffset: v);
            widget.requestUpdate(widget.chart);
          },
        ),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.sectionsSpace),
              Spacer(),
              Text(
                widget.chart.data.sectionsSpace.toStringAsPrecision(3) + '/100',
              ),
            ],
          ),
          value: widget.chart.data.sectionsSpace,
          max: 100,
          count: SizedBox(),
          onChanged: (v) {
            widget.chart.data = widget.chart.data.copyWith(sectionsSpace: v);
            widget.requestUpdate(widget.chart);
          },
        ),
        ColorPickerListTile(
          title: loc.backgroundColor,
          color: widget.chart.backgroundColor,
          onChange: (color) {
            widget.chart.backgroundColor = color;
            widget.requestUpdate(widget.chart);
          },
        ),
        _buildTitle(context, Text(loc.center)),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.centerSpaceRadius),
              Spacer(),
              Text(
                widget.chart.data.centerSpaceRadius.toStringAsPrecision(3) +
                    '/100',
              ),
            ],
          ),
          value: widget.chart.data.centerSpaceRadius,
          max: 100,
          count: SizedBox(),
          onChanged: (v) {
            widget.chart.data =
                widget.chart.data.copyWith(centerSpaceRadius: v);
            widget.requestUpdate(widget.chart);
          },
        ),
        ColorPickerListTile(
          title: loc.centerSpaceColor,
          color: widget.chart.data.centerSpaceColor,
          onChange: (color) {
            widget.chart.data =
                widget.chart.data.copyWith(centerSpaceColor: color);
            widget.requestUpdate(widget.chart);
          },
        ),
        _buildTitle(
          context,
          Text(loc.border),
          trailing: Checkbox(
            value: widget.chart.data.borderData.show,
            onChanged: (value) => updateBorder(show: value),
          ),
        ),
        SliderListTile(
          subtitle: Row(
            children: [
              Text(loc.value),
              Spacer(),
              Text(
                widget.chart.data.borderData.border.top.width
                        .toStringAsPrecision(3) +
                    '/100',
              ),
            ],
          ),
          value: widget.chart.data.borderData.border.top.width,
          max: 100,
          count: SizedBox(),
          onChanged: (v) => updateBorder(width: v),
        ),
        ColorPickerListTile(
          title: loc.borderColor,
          color: widget.chart.data.borderData.border.top.color,
          onChange: (color) => updateBorder(color: color),
        ),
        _buildTitle(
          context,
          Text(loc.sections),
          trailing: IconButton(
            tooltip: loc.add,
            icon: Icon(Icons.add),
            onPressed: () {
              widget.chart.data.sections.add(PieChartSectionData(
                title: 'Section ${widget.chart.data.sections.length + 1}',
                radius: 100,
                color: colors.random(),
              ));
              widget.requestUpdate(widget.chart);
            },
            splashRadius: 16,
          ),
        ),
        if (widget.chart.data.sections.isNotEmpty) ...[
          ...List.generate(
            widget.chart.data.sections.length,
            (index) {
              final section = widget.chart.data.sections[index];
              return SectionTile(
                section: section,
                onEdit: () {
                  showEditSection(
                    context,
                    widget.chart,
                    widget.requestUpdate,
                    index,
                  ).then((_) {
                    widget.requestUpdate(widget.chart);
                  });
                },
                confirmDismiss: (_) async {
                  // There must be at least one section
                  return widget.chart.data.sections.length != 1;
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
  }) {
    final border = widget.chart.data.borderData;
    widget.chart.data = widget.chart.data.copyWith(
      borderData: FlBorderData(
        show: show ?? border.show,
        border: Border.all(
          color: color ?? border.border.top.color,
          width: width ?? border.border.top.width,
        ),
      ),
    );
    widget.requestUpdate(widget.chart);
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
