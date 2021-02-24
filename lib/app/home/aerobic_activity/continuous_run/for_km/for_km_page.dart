import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/aerobic_activity/continuous_run/for_km/edit_for_km.dart';
import 'package:guia_entrenamiento/app/home/brigade/list_items_builder.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/common_widgets/Common_list_tile.dart';
import 'package:guia_entrenamiento/common_widgets/common_draw.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:provider/provider.dart';

class ForKmPage extends StatelessWidget {
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
        MaterialPageRoute(
          builder: (context) => LandingPage(),
        ),
      );
    }
  }

  Future<void> _delete(BuildContext context, Training training) async {
    try {
      final database = Provider.of<TrainingApi>(context, listen: false);
      await database.deleteTraining(training.idtraining);
    } on AssertionError catch (e) {
      showAssertionAlertDialog(
        context,
        title: 'Operación fallida',
        exception: e,
      );
    } catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operación fallida',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('POR KM'),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      drawer: CommonDraw(),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditForKmPage.show(context),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildContents(BuildContext bodyContext) {
    final trainingApi = bodyContext.watch<TrainingApi>();
    return StreamBuilder<List<Training>>(
      stream: trainingApi.forKmStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Training>(
          snapshot: snapshot,
          itemBuilder: (context, training) => Dismissible(
            key: Key('for_km-${training.idtraining}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, training),
            child: Card(
              child: FlatButton(
                child: Column(
                  children: [
                    Text(
                      '${training.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.00),
                    ),
                    training.image == null
                        ? Image(image: AssetImage('assets/images/no-image.png'))
                        : FadeInImage(
                            image: NetworkImage(training.image),
                            placeholder:
                                AssetImage('assets/images/jar-loading.gif'),
                            height: 200.00,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ],
                ),
                onPressed: () =>
                    EditForKmPage.show(context, training: training),
              ),
            ),
          ),
        );
      },
    );
  }
}
