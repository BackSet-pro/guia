import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:provider/provider.dart';

import '../../landing_page.dart';

class FinalPage extends StatefulWidget {
  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
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
        title: Text('Final Page'),
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
      ),
      body: Container(
        child: Text('Final'),
      ),
    );
  }
  // Widget _buildContents(BuildContext context) {
  //
  //   final sessionProvider = context.read<Session>();
  //   final swimmingApi = context.watch<SwimmingApi>();
  //   return StreamBuilder<List<Swimming>>(
  //     stream: swimmingApi.swimmingByIdSession(sessionProvider.idsession),
  //     builder: (context, snapshot) {
  //       // if (snapshot.hasData) {
  //       return ListItemsBuilder<Swimming>(
  //         snapshot: snapshot,
  //         itemBuilder: (context, swimming) => Dismissible(
  //           key: Key('brigade-${swimming.idswimming}'),
  //           background: Container(color: Colors.red),
  //           direction: DismissDirection.endToStart,
  //           onDismissed: (direction) => _delete(context, swimming),
  //           child: CommonListTile(
  //             text: swimming.name,
  //             trailing: FlatButton(
  //               child: Icon(Icons.edit),
  //               onPressed: () =>
  //                   EditSwimmingPage.show(context, swimming: swimming),
  //             ),
  //           ),
  //         ),
  //       );
  //       // } else {
  //       //   return Center(child: CircularProgressIndicator());
  //       // }
  //     },
  //   );
  // }
}
