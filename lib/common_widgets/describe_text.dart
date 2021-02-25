import 'package:flutter/material.dart';

class DescribeText extends StatelessWidget {
  const DescribeText({Key key, this.title, this.text, this.unit})
      : super(key: key);
  final String title;
  final String text;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Text('$text$unit'),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
