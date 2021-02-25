import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/common_widgets/describe_text.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:provider/provider.dart';

class FinalPage extends StatelessWidget {
  FinalPage({Key key, this.trainingApi, this.session}) : super(key: key);
  final Session session;
  final TrainingApi trainingApi;

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
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: _buildContents(context),
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
                          if (session != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (session.name != null)
                                        Center(
                                          child: Text(
                                            "${session.name}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      if (session.numberSeries != null)
                                        DescribeText(
                                          title: 'Número de Series',
                                          text: session.numberSeries.toString(),
                                          unit: '',
                                        ),
                                      if (session.macroPause != null)
                                        DescribeText(
                                          title: 'Macro Pausa',
                                          text: session.macroPause.toString(),
                                          unit: ' minutos',
                                        ),
                                      if (session.microPause != null)
                                        DescribeText(
                                          title: 'Micro Pausa',
                                          text: session.microPause.toString(),
                                          unit: ' minutos',
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 10.0,
                          ),
                          if (training.name != null)
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
                            DescribeText(
                              title: 'Descripción',
                              text: training.description,
                              unit: '',
                            ),
                          if (training.time != null)
                            DescribeText(
                              title: 'Tiempo',
                              text: training.time.toString(),
                              unit: ' minutos',
                            ),
                          if (training.distance != null)
                            DescribeText(
                              title: 'Distancia',
                              text: training.distance.toString(),
                              unit: '',
                            ),
                          if (training.intensity != null)
                            DescribeText(
                              title: 'Intensidad',
                              text: training.intensity.toString(),
                              unit: ' %',
                            ),
                          if (training.style != null)
                            DescribeText(
                              title: 'Estilo',
                              text: training.style,
                              unit: '',
                            ),
                          if (training.pausa != null)
                            DescribeText(
                              title: 'Pausa',
                              text: training.pausa.toString(),
                              unit: ' minutos',
                            ),
                          if (training.repetitions != null)
                            DescribeText(
                              title: 'Repeticiones',
                              text: training.repetitions.toString(),
                              unit: '',
                            ),
                          if (training.numberSeries != null)
                            DescribeText(
                              title: 'Número de series',
                              text: training.numberSeries.toString(),
                              unit: '',
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
}
