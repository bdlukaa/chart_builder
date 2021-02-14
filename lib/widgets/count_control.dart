import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountControl extends StatelessWidget {
  CountControl({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.title,
    this.min = 0,
    this.max = 100,
  }) : super(key: key);

  final double value;
  final ValueChanged<double> onChanged;
  final String title;

  final double min;
  final double max;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = '$value';
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove),
        onPressed: value == min ? null : () => onChanged(value - 1),
        tooltip: 'Decrease',
      ),
      // title: Text('$value', textAlign: TextAlign.center),
      title: SizedBox(
        height: 15,
        child: TextFormField(
          controller: controller,
          onFieldSubmitted: (text) {
            if (text.isEmpty) {
              controller.text = '${this.value}';
              return;
            }
            final value = double.tryParse(text);
            if (value != null) {
              onChanged(value);
            } else {
              controller.text = '${this.value}';
            }
          },
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          maxLines: 1,
        ),
      ),
      subtitle: Text(title ?? 'Value', textAlign: TextAlign.center),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: value == max ? null : () => onChanged(value + 1),
        tooltip: 'Increase',
      ),
    );
  }
}
