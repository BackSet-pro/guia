import 'package:flutter/material.dart';

class InputTextCommon extends StatelessWidget {
  const InputTextCommon({Key key, this.child, this.unit}) : super(key: key);
  final Widget child;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        Text(
          '$unit',
          style: TextStyle(color: Colors.black54, fontSize: 11),
        ),
      ],
    );
  }
}
