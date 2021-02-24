import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  @required String title,
  @required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'OK',
    );

Future<void> showAssertionAlertDialog(
  BuildContext context, {
  @required String title,
  @required AssertionError exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'OK',
    );
