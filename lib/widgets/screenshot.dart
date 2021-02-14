import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';

class ScreenshotDialog extends StatelessWidget {
  const ScreenshotDialog({
    Key key,
    @required this.bytes,
    this.name,
  }) : super(key: key);

  final Uint8List bytes;
  final String name;

  void show(BuildContext context) {
    showDialog(
      context: context,
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Screenshot taken'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(child: Image.memory(bytes)),
          Text(
            'The ouside borders will NOT be saved',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('Save to device'),
          color: Colors.pink,
          onPressed: () => ImageGallerySaver.saveImage(bytes, name: name),
        ),
        FlatButton(
          child: Text('Share outside'),
          color: Colors.indigo,
          onPressed: () {
            // TODO: share outside
          },
        ),
      ],
    );
  }
}
