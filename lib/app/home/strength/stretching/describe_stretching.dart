import 'package:guia_entrenamiento/app/home/models/brigade.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/home/models/session_has_training.dart';
import 'package:guia_entrenamiento/services/brigade_api.dart';
import 'package:guia_entrenamiento/services/session_api.dart';
import 'package:guia_entrenamiento/services/session_has_training_api.dart';

import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DescribeStretchingPage extends StatefulWidget {
  const DescribeStretchingPage({Key key, this.training, this.trainingApi})
      : super(key: key);
  final Training training;
  final TrainingApi trainingApi;

  static Future<void> show(BuildContext context, {Training training}) async {
    final trainingApi = context.read<TrainingApi>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DescribeStretchingPage(
          trainingApi: trainingApi,
          training: training,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _DescribeStretchingPageState createState() => _DescribeStretchingPageState();
}

class _DescribeStretchingPageState extends State<DescribeStretchingPage> {
  bool select = false;

  Brigade _selectedBrigade;
  Session _selectedSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('${widget.training.name}'.toUpperCase()),
        // actions: <Widget>[
        //   FlatButton(
        //     child: Icon(
        //       Icons.save,
        //       color: Colors.white,
        //     ),
        //     onPressed: () => _submit(),
        //   ),
        // ],
        backgroundColor: Colors.black,
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final brigadeApi = context.read<BrigadeApi>();
    final sessionApi = context.read<SessionApi>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.training.image == null
            ? Image(image: AssetImage('assets/images/no-image.png'))
            : FadeInImage(
                image: NetworkImage(widget.training.image),
                placeholder: AssetImage('assets/images/jar-loading.gif'),
                height: 200.00,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
        SizedBox(
          height: 10.00,
        ),
        Text(
          "Descripción:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Text(widget.training.description),
        SizedBox(
          height: 5.00,
        ),
        Text(
          "Tiempo:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Text(widget.training.time.toString()),
        SizedBox(
          height: 5.00,
        ),
        SizedBox(
          height: 5.00,
        ),
        StreamBuilder<List<Brigade>>(
          key: UniqueKey(),
          stream: brigadeApi.brigadeStream(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return DropdownButton(
                key: UniqueKey(),
                hint: Text('Seleccione una brigada'),
                value: _selectedBrigade,
                onChanged: (newBrigade) {
                  setState(() {
                    select = true;
                    _selectedBrigade = newBrigade;
                    // _sessions = sessionApi
                    //     .sessionsByIdBrigade(_selectedBrigade.idbrigade);
                  });
                },
                items: snapshot.data.map(
                  (brigade) {
                    return DropdownMenuItem(
                      key: UniqueKey(),
                      value: brigade,
                      child: Text(brigade.name),
                    );
                  },
                ).toList(),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        if (_selectedBrigade != null)
          StreamBuilder<List<Session>>(
            key: UniqueKey(),
            stream: sessionApi.sessionsByIdBrigade(_selectedBrigade.idbrigade),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return DropdownButton(
                  key: UniqueKey(),
                  disabledHint: Text('Primero seleccione una brigrada'),
                  hint: Text('Seleccione una sección'),
                  value: _selectedSession,
                  onChanged: _selectedBrigade == null
                      ? null
                      : (newSession) {
                          setState(() {
                            _selectedSession = newSession;
                          });
                        },
                  items: snapshot.data.map(
                    (session) {
                      return DropdownMenuItem(
                        key: UniqueKey(),
                        value: session,
                        child: Text(session.name),
                      );
                    },
                  ).toList(),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        Center(
          child: FlatButton(
            color: Colors.black54,
            onPressed: (_selectedSession != null && _selectedBrigade != null)
                ? () {
                    final sessionHasTrainingApi =
                        context.read<SessionHasTrainingApi>();
                    SessionHasTraining sessionHasTraining = SessionHasTraining(
                        sessionIdsession: _selectedSession.idsession,
                        trainingIdtraining: widget.training.idtraining);
                    sessionHasTrainingApi
                        .setSessionHasTraining(sessionHasTraining);
                    Navigator.pop(context);
                  }
                : null,
            child: Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
