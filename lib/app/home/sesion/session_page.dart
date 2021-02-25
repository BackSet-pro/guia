import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/brigade/list_items_builder.dart';
import 'package:guia_entrenamiento/app/home/final_user/final_page.dart';
import 'package:guia_entrenamiento/app/home/models/brigade.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/home/sesion/edit_session_page.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/common_widgets/Common_list_tile.dart';
import 'package:guia_entrenamiento/common_widgets/common_draw.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/session_api.dart';
import 'package:provider/provider.dart';

class SessionPage extends StatelessWidget {
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

  Future<void> _delete(BuildContext context, Session session) async {
    try {
      final sessionApi = Provider.of<SessionApi>(context, listen: false);
      await sessionApi.deleteSession(session);
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
    final brigadeProvider = context.read<Brigade>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sesión ( ${brigadeProvider.name})'.toUpperCase()),
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
      drawer: CommonDraw(),
      body: _buildContents(context, brigadeProvider),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditSessionPage.show(context),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildContents(BuildContext bodyContext, Brigade brigade) {
    final sessionApi = bodyContext.watch<SessionApi>();
    return StreamBuilder<List<Session>>(
      stream: sessionApi.sessionsByIdBrigade(brigade.idbrigade),
      builder: (context, snapshot) {
        return ListItemsBuilder<Session>(
          snapshot: snapshot,
          itemBuilder: (context, session) => Dismissible(
            key: Key('session-${session.idsession}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, session),
            child: CommonListTile(
              onTap: () => FinalPage.show(context, session: session),
              text: session.name,
              trailing: FlatButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  EditSessionPage.show(context, session: session);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
