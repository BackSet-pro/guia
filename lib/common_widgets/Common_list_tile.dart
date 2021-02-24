import 'package:flutter/material.dart';

class CommonListTile extends StatelessWidget {
  const CommonListTile(
      {Key key, @required this.text, this.onTap, @required this.trailing})
      : super(key: key);
  final String text;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
