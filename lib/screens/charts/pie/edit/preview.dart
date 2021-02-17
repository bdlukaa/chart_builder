import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/chart.dart';
import '../../../../langs/lang.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/screenshot.dart';
import 'edit_section.dart';

class Preview extends StatefulWidget {
  const Preview({
    Key key,
    @required this.chart,
    @required this.requestUpdate,
  }) : super(key: key);

  final Chart<PieChartData> chart;
  final ValueChanged<Chart> requestUpdate;

  @override
  PreviewState createState() => PreviewState();
}

class PreviewState extends State<Preview> {
  final GlobalKey previewContainer = GlobalKey();

  Future<Uint8List> takeScreenshot() async {
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    return (await image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return Column(
      children: [
        Expanded(
          child: Container(
            color: AppTheme.isDark(context) ? Colors.white : Colors.grey[900],
            child: Card(
              color: widget.chart.backgroundColor,
              margin: EdgeInsets.all(8),
              child: LayoutBuilder(builder: (context, consts) {
                return RepaintBoundary(
                  key: previewContainer,
                  child: AnimatedContainer(
                    alignment: Alignment.center,
                    duration: Duration(milliseconds: 250),
                    padding: EdgeInsets.all(4),
                    height: double.infinity,
                    width: double.infinity,
                    color: widget.chart.backgroundColor,
                    child: Container(
                      decoration: BoxDecoration(
                        border: widget.chart.data.borderData.show
                            ? widget.chart.data.borderData.border
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: Hero(
                        tag: widget.chart,
                        child: PieChart(widget.chart.data.copyWith(
                          centerSpaceRadius: consts.biggest.longestSide *
                              (widget.chart.data.centerSpaceRadius / 800),
                          borderData: FlBorderData(show: false),
                          pieTouchData: PieTouchData(touchCallback: (r) {
                            if (r.touchInput.runtimeType == FlLongPressStart &&
                                r.touchedSectionIndex != null) {
                              Feedback.forLongPress(context);
                              showEditSection(
                                context,
                                widget.chart,
                                widget.requestUpdate,
                                r.touchedSectionIndex,
                              ).then((_) {
                                widget.requestUpdate(widget.chart);
                              });
                            }
                          }),
                        )),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Divider(),
        Text(
          loc.longPressSectionToEdit,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(loc.takeScreenshot),
              onPressed: () async => ScreenshotDialog(
                bytes: await takeScreenshot(),
                name: widget.chart.name,
              ).show(context),
            ),
            TextButton.icon(
              icon: Icon(Icons.bookmark),
              label: Text(loc.bookmark),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
