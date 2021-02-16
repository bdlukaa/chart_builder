import 'dart:io' if (kIsWeb) 'dart:html';
import 'dart:typed_data';

import 'package:chart_builder/utils/toast/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

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
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Image.memory(bytes),
            ),
          ),
          Text(
            'The ouside borders will NOT be saved',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
          // TODO: make this work
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text('Save to device'),
                color: Colors.amber,
                onPressed: () async {
                  final file = await getFile();
                  await file.writeAsBytes(bytes);
                  showTextToast(
                    text: '$name was saved to\n${file.path}',
                    context: context,
                  );
                },
              ),
              SizedBox(width: 4),
              FlatButton(
                child: Text('Share outside'),
                color: Colors.yellow,
                onPressed: () async {
                  final file = await getFile();
                  if (!file.existsSync())
                    showTextToast(
                      text: 'You must save the file to share it',
                      context: context,
                    );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<File> getFile() async {
    final directory = await getExternalStorageDirectory();
    final name = this.name.trim().replaceAll(' ', '_');
    final path = '${directory.path}/$name.png';
    return File(path);
  }
}
