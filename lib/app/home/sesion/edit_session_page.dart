import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guia_entrenamiento/app/home/models/brigade.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/common_widgets/input_text_common.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';
import 'package:guia_entrenamiento/services/session_api.dart';
import 'package:provider/provider.dart';

class EditSessionPage extends StatefulWidget {
  const EditSessionPage({Key key, @required this.sessionApi, this.session})
      : super(key: key);
  final SessionApi sessionApi;
  final Session session;

  static Future<void> show(BuildContext context, {Session session}) async {
    final sessionApi = context.read<SessionApi>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditSessionPage(
          sessionApi: sessionApi,
          session: session,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditSessionPageState createState() => _EditSessionPageState();
}

class _EditSessionPageState extends State<EditSessionPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _macroPause;
  String _numberSeries;
  String _microPause;
  String _date;

  // TextEditingController _inputFieldDateController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.session != null) {
      _name = widget.session.name;
      _date = widget.session.date;
      _macroPause = widget.session.macroPause.toString();
      _microPause = widget.session.microPause.toString();
      _numberSeries = widget.session.numberSeries.toString();
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
    final brigadeProvider = context.read<Brigade>();

    if (_validateAndSaveForm()) {
      try {
        final sessions = await widget.sessionApi
            .sessionsByIdBrigade(brigadeProvider.idbrigade)
            .first;
        final allNames = sessions.map((session) => session.name).toList();
        if (widget.session != null) {
          allNames.remove(widget.session.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'sesión ya usada',
            content: 'Elija un nombre de sesión diferente',
            defaultActionText: 'OK',
          );
        } else {
          final Session session = new Session().copyWith(
            name: _name,
            date: _date,
            numberSeries: int.parse(_numberSeries),
            macroPause: int.parse(_macroPause),
            microPause: int.parse(_microPause),
            brigadeIdbrigade: brigadeProvider.idbrigade,
          );
          if (widget.session == null) {
            await widget.sessionApi.setSession(session);
            Navigator.of(context).pop();
          } else {
            await widget.sessionApi
                .updateSession(widget.session.idsession, session);
            Navigator.of(context).pop();
          }
        }
      } on AssertionError catch (e) {
        showAssertionAlertDialog(
          context,
          title: 'Operación fallida',
          exception: e,
        );
      } on NoSuchMethodError catch (a) {
        print(a.toString());
      } catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operación fallida',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.session == null
            ? 'Nueva sesión'.toUpperCase()
            : 'Editar sesión'.toUpperCase()),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => _submit(),
          ),
        ],
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
            child: _buildForm(),
          ),
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
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Nombre'),
        initialValue: _name,
        validator: (value) =>
            value.isNotEmpty ? null : 'El campo no puede estar vacío',
        onSaved: (value) => _name = value,
        textInputAction: TextInputAction.next,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Número de serie'),
        initialValue: _numberSeries,
        validator: (value) =>
            value.isNotEmpty ? null : 'El campo no puede estar vacío',
        onSaved: (value) => _numberSeries = value,
        onEditingComplete: () => _submit(),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
      ),
      InputTextCommon(
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Macro Pausa'),
          initialValue: _macroPause,
          validator: (value) =>
              value.isNotEmpty ? null : 'El campo no puede estar vacío',
          onSaved: (value) => _macroPause = value,
          onEditingComplete: () => _submit(),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
        ),
        unit: 'minutos',
      ),
      InputTextCommon(
        unit: 'minutos',
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Micro Pausa'),
          initialValue: _microPause,
          validator: (value) =>
              value.isNotEmpty ? null : 'El campo no puede estar vacío',
          onSaved: (value) => _microPause = value,
          onEditingComplete: () => _submit(),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
        ),
      ),
      InputTextCommon(
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Fecha'),
          initialValue: _date,
          validator: (value) =>
              value.isNotEmpty ? null : 'El campo no puede estar vacío',
          onSaved: (value) => _date = value,
          onEditingComplete: () => _submit(),
          keyboardType: TextInputType.phone,
        ),
        unit: 'YY-MM-DD',
      ),
      SizedBox(
        height: 15,
      ),
      // _buildDate(context),
    ];
  }
}
