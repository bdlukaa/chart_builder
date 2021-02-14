import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/chart.dart';
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
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.only(bottom: 70),
        child: Column(
          children: [
            Expanded(
              child: Card(
                color: widget.chart.backgroundColor,
                child: RepaintBoundary(
                  key: previewContainer,
                  child: Container(
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
                          borderData: FlBorderData(show: false),
                          pieTouchData: PieTouchData(touchCallback: (r) {
                            if ((r.touchInput.runtimeType == FlPanStart) &&
                                (r.touchInput.runtimeType !=
                                    FlLongPressStart) &&
                                (r.touchedSectionIndex != null)) {
                              print(r.touchedSectionIndex);
                              print(r.touchInput);
                              showEditSection(
                                context,
                                widget.chart,
                                widget.requestUpdate,
                                r.touchedSectionIndex,
                              );
                            }
                          }),
                        )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Hint: tap a section to edit it',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
