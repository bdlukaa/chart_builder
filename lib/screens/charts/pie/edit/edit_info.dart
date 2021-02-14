import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../models/chart.dart';
import '../../../../widgets/count_control.dart';
import '../../../../widgets/tiles.dart';
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
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10) + EdgeInsets.only(bottom: 60),
      children: [
        TextFormField(
          controller: widget.nameController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: 'Name',
          ),
          autovalidateMode: AutovalidateMode.always,
          validator: (text) {
            if (text == null || text.isEmpty) return 'The name can NOT be null';
            return null;
          },
          onFieldSubmitted: (text) {
            if (text == null || text.isEmpty) return;
            widget.chart.name = text;
            widget.requestUpdate(widget.chart);
          },
        ),
        CountControl(
          title: 'Center Space Radius',
          value: widget.chart.data.centerSpaceRadius,
          max: double.infinity,
          onChanged: (v) {
            widget.chart.data =
                widget.chart.data.copyWith(centerSpaceRadius: v);
            widget.requestUpdate(widget.chart);
          },
        ),
        SliderListTile(
          subtitle: Row(
            children: [
              Text('Rotation degree'),
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
        ColorPickerListTile(
          title: 'Center space color',
          color: widget.chart.data.centerSpaceColor,
          onChange: (color) {
            widget.chart.data =
                widget.chart.data.copyWith(centerSpaceColor: color);
            widget.requestUpdate(widget.chart);
          },
        ),
        ColorPickerListTile(
          title: 'Background color',
          color: widget.chart.backgroundColor,
          onChange: (color) {
            widget.chart.backgroundColor = color;
            widget.requestUpdate(widget.chart);
          },
        ),
        _buildTitle(
          context,
          Text('Border'),
          trailing: Checkbox(
            value: widget.chart.data.borderData.show,
            onChanged: (value) => updateBorder(show: value),
          ),
        ),
        CountControl(
          value: widget.chart.data.borderData.border.top.width,
          onChanged: (v) => updateBorder(width: v),
        ),
        ColorPickerListTile(
          title: 'Border color',
          color: widget.chart.data.borderData.border.top.color,
          onChange: (color) => updateBorder(color: color),
        ),
        _buildTitle(
          context,
          Text('Sections'),
          trailing: IconButton(
            tooltip: 'Add',
            icon: Icon(Icons.add),
            onPressed: () {
              widget.chart.data.sections.add(PieChartSectionData(
                title: 'Section ${widget.chart.data.sections.length + 1}',
                radius: 100,
                color: colors.random(),
              ));
              widget.requestUpdate(widget.chart);
            },
          ),
        ),
        if (widget.chart.data.sections.isEmpty)
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'You have no data yet.\nPress on + to create a new one',
            ),
          )
        else ...[
          ...List.generate(
            widget.chart.data.sections.length,
            (index) {
              final section = widget.chart.data.sections[index];
              return SectionTile(
                section: section,
                onEdit: () => showEditSection(
                  context,
                  widget.chart,
                  widget.requestUpdate,
                  index,
                ),
                confirmDismiss: (_) async {
                  // There must be at least one section
                  return widget.chart.data.sections.length != 1;
                },
                onDismiss: widget.onDismiss,
              );
            },
          ),
          Text(
            'Slide to any sides to delete a section',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(top: 4.0, left: 10, right: 10),
          child: Column(
            children: [
              _buildTitle(context, Text('Danger Zone')),
              ListTile(
                title: Text('Delete this chart'),
                subtitle: Text(
                  'Once you delete this chart, there is no going back. Please be certain.',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  child: Text('Delete'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((s) {
                      const interactiveStates = <MaterialState>{
                        MaterialState.pressed,
                        MaterialState.hovered,
                        MaterialState.focused,
                      };
                      if (s.any(interactiveStates.contains))
                        return Colors.red.shade300;
                      return Colors.grey.shade200;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith((s) {
                      const interactiveStates = <MaterialState>{
                        MaterialState.pressed,
                        MaterialState.hovered,
                        MaterialState.focused,
                      };
                      if (s.any(interactiveStates.contains))
                        return Colors.grey.shade200;
                      return Colors.grey.shade800;
                    }),
                  ),
                  onPressed: widget.onDelete,
                ),
              ),
            ],
          ),
        ),
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
