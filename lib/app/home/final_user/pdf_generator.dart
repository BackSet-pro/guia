import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfGenerator extends StatelessWidget {
  PdfGenerator({Key key, @required this.session}) : super(key: key);
  final Session session;

  static Future<void> show(BuildContext context, {Session session}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfGenerator(
          session: session,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Cerrar sesión',
      content: '¿Estás seguro de que quieres cerrar sesión?',
      cancelActionText: 'Cancelar',
      defaultActionText: 'Cerrar sesión',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('PDF'),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(context, format),
        canChangePageFormat: false,
      ),
    );
  }

  List<pw.Widget> getBody(List<Training> trainings) {
    List<pw.Widget> aux;
    for (Training training in trainings) {
      aux.add(
        pw.Column(children: [
          pw.Header(
            level: 1,
            title: training.name,
          ),
          pw.Paragraph(
            text: training.description,
          ),
        ]),
      );
    }
    return aux;
  }

  Future<Uint8List> _generatePdf(BuildContext _, PdfPageFormat format) async {
    final pdf = pw.Document();
    final trainingApi = _.read<TrainingApi>();
    List<Training> trainings =
        await trainingApi.trainingByIdSession(session.idsession).first;
    // final pageTheme = await _myPageTheme(format);
    pdf.addPage(
      pw.MultiPage(
          pageFormat: format,
          // pageTheme: pageTheme,
          // build: (pw.Context context) => getBody(trainings),
          build: (pw.Context context) => [
                pw.ListView.builder(
                    itemBuilder: (_, i) {
                      return pw.Column(children: [
                        // if (trainings[i].name != null)
                        //   pw.Header(text: '${trainings[i].name}'),
                        // // pw.Image()
                        if (trainings[i].description != null)
                          pw.Column(children: [
                            pw.Header(text: 'Descripción:'),
                            pw.Paragraph(text: '${trainings[i].description}'),
                          ]),
                        if (trainings[i].distance != null)
                          pw.Column(children: [
                            pw.Header(text: 'Distancia:'),
                            pw.Text('${trainings[i].distance.toString()}'),
                          ]),
                        if (trainings[i].pausa != null)
                          pw.Column(children: [
                            pw.Header(text: 'Pausa:'),
                            pw.Text('${trainings[i].pausa.toString()}'),
                          ]),
                        if (trainings[i].style != null)
                          pw.Column(children: [
                            pw.Header(text: 'Stilo:'),
                            pw.Text('${trainings[i].style}'),
                          ]),
                        if (trainings[i].numberSeries != null)
                          pw.Column(children: [
                            pw.Header(text: 'Número de Series:'),
                            pw.Text('${trainings[i].numberSeries.toString()}'),
                          ]),
                        if (trainings[i].repetitions != null)
                          pw.Column(children: [
                            pw.Header(text: 'Repeticiones:'),
                            pw.Text('${trainings[i].repetitions.toString()}'),
                          ]),
                        if (trainings[i].intensity != null)
                          pw.Column(children: [
                            pw.Header(text: 'Intesisdad:'),
                            pw.Text('${trainings[i].intensity.toString()}'),
                          ]),
                        if (trainings[i].time != null)
                          pw.Column(children: [
                            pw.Header(text: 'Tiempo:'),
                            pw.Text('${trainings[i].time.toString()}'),
                          ]),
                        if (trainings[i].macroPause != null)
                          pw.Column(children: [
                            pw.Header(text: 'Macro Pausa:'),
                            pw.Text('${trainings[i].macroPause.toString()}'),
                          ]),
                        if (trainings[i].microPause != null)
                          pw.Column(children: [
                            pw.Header(text: 'Micro Pausa:'),
                            pw.Text('${trainings[i].microPause.toString()}'),
                          ]),
                      ]);
                    },
                    itemCount: trainings.length),
              ]),
    );
    return pdf.save();
  }

  // Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  //   final bgShape =
  //       await rootBundle.loadString('assets/images/fondo_militar.svg');
  //
  //   format = format.applyMargin(
  //       left: 2.0 * PdfPageFormat.cm,
  //       top: 4.0 * PdfPageFormat.cm,
  //       right: 2.0 * PdfPageFormat.cm,
  //       bottom: 2.0 * PdfPageFormat.cm);
  //   return pw.PageTheme(
  //     pageFormat: format,
  //     theme: pw.ThemeData.withFont(
  //       base: pw.Font.ttf(
  //           await rootBundle.load('assets/open-sans/OpenSans-Regular.ttf')),
  //       bold: pw.Font.ttf(
  //           await rootBundle.load('assets/open-sans/OpenSans-Bold.ttf')),
  //     ),
  //     buildBackground: (pw.Context context) {
  //       return pw.FullPage(
  //         ignoreMargins: true,
  //         child: pw.Stack(
  //           children: [
  //             pw.Positioned(
  //               child: pw.SvgImage(svg: bgShape),
  //               left: 0,
  //               top: 0,
  //             ),
  //             pw.Positioned(
  //               child: pw.Transform.rotate(
  //                   angle: pi, child: pw.SvgImage(svg: bgShape)),
  //               right: 0,
  //               bottom: 0,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
