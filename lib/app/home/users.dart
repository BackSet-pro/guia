import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/models/user.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/user_api.dart';
import 'package:provider/provider.dart';

import 'brigade/list_items_builder.dart';
import 'models/session.dart';

class UsersPage extends StatelessWidget {
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

  Future<void> _delete(BuildContext context, User user) async {
    try {
      final database = Provider.of<UserApi>(context, listen: false);
      await database.deleteUser(user);
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
        title: Text('Principal'),
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
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final sessionProvider = context.read<Session>();
    final userApi = context.watch<UserApi>();
    return StreamBuilder<List<User>>(
      stream: userApi.userByIdSession(sessionProvider.idsession),
      builder: (context, snapshot) {
        return ListItemsBuilder<User>(
          snapshot: snapshot,
          itemBuilder: (context, user) => Dismissible(
            key: Key('brigade-${user.iduser}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, user),
            child: ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
            ),
          ),
        );
      },
    );
  }
}
