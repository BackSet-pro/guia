import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/final_user/pdf_generator.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FinalPage extends StatelessWidget {
  FinalPage({Key key, this.trainingApi, this.session}) : super(key: key);
  final Session session;
  final TrainingApi trainingApi;
  final pdf = pw.Document();

  static Future<void> show(BuildContext context, {Session session}) async {
    final trainingApi = context.read<TrainingApi>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FinalPage(
          trainingApi: trainingApi,
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
      appBar: AppBar(
        title: Text('${session.name}'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Cerrar sesión',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) {
              return PdfGenerator(
                session: session,
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Training>>(
      stream: trainingApi.trainingByIdSession(session.idsession),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              if (snapshot.data.length != 0) {
                final Training training = snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              training.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          if (training.image != null)
                            FadeInImage(
                              image: NetworkImage(training.image),
                              placeholder:
                                  AssetImage('assets/images/jar-loading.gif'),
                              height: 200.00,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          if (training.description != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Descripción:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.description),
                              ],
                            ),
                          if (training.distance != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Distancia:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.distance.toString()),
                              ],
                            ),
                          if (training.pausa != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pausa::",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.pausa.toString()),
                              ],
                            ),
                          if (training.style != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estilo:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.style),
                              ],
                            ),
                          if (training.numberSeries != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Número de Series:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.numberSeries.toString()),
                              ],
                            ),
                          if (training.repetitions != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Número de Repeticiones:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.repetitions.toString()),
                              ],
                            ),
                          if (training.intensity != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Intensidad:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.intensity.toString()),
                              ],
                            ),
                          if (training.time != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tiempo:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.time.toString()),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          if (training.macroPause != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Macro Pausa:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.macroPause.toString()),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          if (training.microPause != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Micro Pausa:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(training.microPause.toString()),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Card(child: Text('No hay Entrenameintos')),
                );
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  writeOnPdf(List<Training> trainings) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.ListView.builder(
                itemBuilder: (_, i) {
                  return pw.Column(children: [
                    pw.Header(
                      title: trainings[i].name,
                    ),
                    // pw.Image()
                    pw.Column(children: [
                      pw.Header(title: 'Descripción: '),
                      pw.Paragraph(text: trainings[i].description),
                    ]),
                    if (trainings[i].distance != null)
                      pw.Column(children: [
                        pw.Header(title: 'Distancia: '),
                        pw.Text(trainings[i].distance.toString()),
                      ]),
                    if (trainings[i].pausa != null)
                      pw.Column(children: [
                        pw.Header(title: 'Pausa: '),
                        pw.Text(trainings[i].pausa.toString()),
                      ]),
                    if (trainings[i].style != null)
                      pw.Column(children: [
                        pw.Header(title: 'Stilo: '),
                        pw.Text(trainings[i].style),
                      ]),
                    if (trainings[i].numberSeries != null)
                      pw.Column(children: [
                        pw.Header(title: 'Número de Series: '),
                        pw.Text(trainings[i].numberSeries.toString()),
                      ]),
                    if (trainings[i].repetitions != null)
                      pw.Column(children: [
                        pw.Header(title: 'Repeticiones: '),
                        pw.Text(trainings[i].repetitions.toString()),
                      ]),
                    if (trainings[i].intensity != null)
                      pw.Column(children: [
                        pw.Header(title: 'Intesisdad: '),
                        pw.Text(trainings[i].intensity.toString()),
                      ]),
                    if (trainings[i].time != null)
                      pw.Column(children: [
                        pw.Header(title: 'Tiempo: '),
                        pw.Text(trainings[i].time.toString()),
                      ]),
                    if (trainings[i].macroPause != null)
                      pw.Column(children: [
                        pw.Header(title: 'Macro Pausa: '),
                        pw.Text(trainings[i].macroPause.toString()),
                      ]),
                    if (trainings[i].microPause != null)
                      pw.Column(children: [
                        pw.Header(title: 'Micro Pausa: '),
                        pw.Text(trainings[i].microPause.toString()),
                      ]),
                  ]);
                },
                itemCount: trainings.length),
          ];
        },
      ),
    );
  }
}
