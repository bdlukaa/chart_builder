import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SliderListTile extends StatelessWidget {
  const SliderListTile({
    Key key,
    this.title,
    this.subtitle,
    this.count,
    @required this.value,
    this.onChanged,
    this.onChangeEnd,
    this.min = 0,
    this.max = 100,
  }) : super(key: key);

  final Widget title;
  final Widget subtitle;
  final Widget count;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.caption,
        child: subtitle ?? SizedBox(),
      ),
      subtitle: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle1,
        child: Row(
          children: [
            title ?? SizedBox(),
            Expanded(
              child: SizedBox(
                height: 25,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackShape: title == null ? CustomTrackShape() : null,
                  ),
                  child: Slider(
                    onChanged: onChanged,
                    onChangeEnd: onChangeEnd,
                    value: value,
                    min: min ?? 0,
                    max: max ?? 100,
                  ),
                ),
              ),
            ),
            // if (title == null) SizedBox(width: 16),
            count ?? Text(value.toStringAsPrecision(3)),
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class ColorPickerListTile extends StatelessWidget {
  const ColorPickerListTile({
    Key key,
    this.title,
    @required this.color,
    @required this.onChange,
  }) : super(key: key);

  final String title;
  final Color color;
  final ValueChanged<Color> onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'Color'),
      trailing: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black),
          boxShadow: color == Colors.transparent || color == null
              ? null
              : [
                  BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.black12,
                  )
                ],
        ),
      ),
      onTap: () async {
        onChange(await pickColor(
          context,
          initialColor: color,
        ));
      },
    );
  }
}

Future<Color> pickColor(
  BuildContext context, {
  Color initialColor = Colors.black,
}) {
  Color color = initialColor;
  return showDialog<Color>(
    context: context,
    child: WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(initialColor);
        return false;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: (c) => color = c,
            showLabel: true,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(initialColor),
            color: Colors.redAccent,
          ),
          FlatButton(
            child: const Text('Done', style: TextStyle(color: Colors.green)),
            onPressed: () => Navigator.of(context).pop(color),
          ),
        ],
      ),
    ),
  );
}

class SectionTile extends StatefulWidget {
  SectionTile({
    Key key,
    @required this.section,
    @required this.onEdit,
    @required this.onDismiss,
    @required this.confirmDismiss,
  }) : super(key: key);

  final PieChartSectionData section;
  final Function onEdit;
  final Function(BuildContext context, PieChartSectionData section) onDismiss;
  final Future<bool> Function(DismissDirection) confirmDismiss;

  @override
  _SectionTileState createState() => _SectionTileState();
}

class _SectionTileState extends State<SectionTile>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Duration get duration => Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    controller.forward();
  }

  PieChartSectionData get section => widget.section;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: controller,
      child: Dismissible(
        background: _buildDismissibleBackground(context),
        secondaryBackground: _buildDismissibleBackground(context, false),
        key: ValueKey<PieChartSectionData>(section),
        direction: DismissDirection.horizontal,
        confirmDismiss: widget.confirmDismiss,
        onDismissed: (_) => widget.onDismiss(context, section),
        child: ListTile(
          leading: Container(
            height: 40,
            width: 40,
            color: section.color,
          ),
          title: Text(section.title),
          subtitle: Text('${section.value}'),
          onTap: widget.onEdit,
          trailing: Icon(Icons.edit),
          // trailing: IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: widget.onEdit,
          //   tooltip: 'Edit section',
          // ),
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground(BuildContext context, [bool left = true]) {
    final children = [
      Icon(Icons.delete, color: Colors.white),
      SizedBox(width: 5),
      Text(
        'Delete',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red,
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        mainAxisAlignment:
            left ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: left ? children : children.reversed.toList(),
      ),
    );
  }
}
