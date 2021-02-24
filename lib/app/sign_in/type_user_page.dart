import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/final_user/final_page.dart';
import 'package:guia_entrenamiento/app/home/models/brigade.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:guia_entrenamiento/app/ultimate/home_page.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/brigade_api.dart';
import 'package:guia_entrenamiento/services/session_api.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:provider/provider.dart';

class TypeUserPage extends StatefulWidget {
  @override
  _TypeUserPageState createState() => _TypeUserPageState();
}

class _TypeUserPageState extends State<TypeUserPage> {
  final _formKey = GlobalKey<FormState>();

  String _password;
  bool isAdmin = false;

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
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (isAdmin) {
      if (_validateAndSaveForm()) {
        if (_password != 'admin1') {
          showAlertDialog(
            context,
            title: 'Error de contraseña',
            content: 'Introduzca una contraseña válida',
            defaultActionText: 'OK',
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      }
    } else {
      FinalPage.show(
        context,
        session: _selectedSession,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2.0,
        title: Text('Tipo de usuario'),
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
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.navigate_next,
        ),
        backgroundColor: Colors.black87,
        onPressed: () => _submit(),
      ),
    );
  }

  Session _selectedSession;

  Widget _buildContents() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final sessionApi = context.read<SessionApi>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${auth.currentUser.email}',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '¿Eres administrador?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Switch(
              value: isAdmin,
              onChanged: (value) => setState(() => isAdmin = value),
            ),
            (isAdmin)
                ? Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildForm(),
                      ),
                    ),
                  )
                : StreamBuilder<List<Session>>(
                    key: UniqueKey(),
                    stream: sessionApi.sessionStream(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownButton(
                                key: UniqueKey(),
                                disabledHint:
                                    Text('Primero seleccione una brigrada'),
                                hint: Text('Seleccione una sección'),
                                value: _selectedSession,
                                onChanged: (newSession) {
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
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    String text1 = 'Ingrese el código de la sesión';
    String text2 = 'Ingrese la contraseña de administrador';
    return [
      TextFormField(
        decoration: InputDecoration(labelText: (isAdmin) ? text2 : text1),
        obscureText: (isAdmin) ? true : false,
        initialValue: _password,
        validator: (value) =>
            value.isNotEmpty ? null : 'el campo no puede estar vacío',
        onSaved: (value) => _password = value,
        onEditingComplete: _submit,
        // textInputAction: TextInputAction.,
      ),
    ];
  }
}
