import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/brigade/edit_brigada_page.dart';
import 'package:guia_entrenamiento/app/home/brigade/list_items_builder.dart';
import 'package:guia_entrenamiento/app/home/models/brigade.dart';
import 'package:guia_entrenamiento/app/home/sesion/session_page.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/common_widgets/Common_list_tile.dart';
import 'package:guia_entrenamiento/common_widgets/common_draw.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/brigade_api.dart';
import 'package:provider/provider.dart';

class BrigadePage extends StatelessWidget {
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

  Future<void> _delete(BuildContext context, Brigade brigade) async {
    try {
      final database = Provider.of<BrigadeApi>(context, listen: false);
      await database.deleteBrigade(brigade);
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
        title: Text('Brigadas'.toUpperCase()),
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
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditBrigadePage.show(context),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildContents(BuildContext bodyContext) {
    final brigadeApi = bodyContext.watch<BrigadeApi>();
    final brigadeProvider = bodyContext.read<Brigade>();
    return StreamBuilder<List<Brigade>>(
      stream: brigadeApi.brigadeStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Brigade>(
          snapshot: snapshot,
          itemBuilder: (context, brigade) => Dismissible(
            key: Key('brigade-${brigade.idbrigade}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, brigade),
            child: CommonListTile(
              text: brigade.name,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    brigadeProvider.idbrigade = brigade.idbrigade;
                    brigadeProvider.name = brigade.name;
                    return SessionPage();
                  }),
                );
              },
              trailing: FlatButton(
                child: Icon(Icons.edit),
                onPressed: () =>
                    EditBrigadePage.show(context, brigade: brigade),
              ),
            ),
          ),
        );
      },
    );
  }
}
