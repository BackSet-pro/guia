import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/models/brigade.dart';
import 'package:guia_entrenamiento/services/brigade_api.dart';
import 'package:provider/provider.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';

class EditBrigadePage extends StatefulWidget {
  EditBrigadePage({Key key, @required this.brigadeApi, this.brigade})
      : super(key: key);
  final BrigadeApi brigadeApi;
  final Brigade brigade;

  static Future<void> show(BuildContext context, {Brigade brigade}) async {
    final brigadeApi = Provider.of<BrigadeApi>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditBrigadePage(
          brigadeApi: brigadeApi,
          brigade: brigade,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditBrigadePageState createState() => _EditBrigadePageState();
}

class _EditBrigadePageState extends State<EditBrigadePage> {
  final _formKey = GlobalKey<FormState>();

  String _name;

  @override
  void initState() {
    super.initState();
    if (widget.brigade != null) {
      _name = widget.brigade.name;
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
    if (_validateAndSaveForm()) {
      try {
        final brigades = await widget.brigadeApi.brigadeStream().first;
        final allNames = brigades.map((brigade) => brigade.name).toList();
        if (widget.brigade != null) {
          allNames.remove(widget.brigade.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Nombre ya usado',
            content: 'Elija un nombre de trabajo diferente',
            defaultActionText: 'OK',
          );
        } else {
          final Brigade brigade = new Brigade().copyWith(name: _name);
          if (widget.brigade == null) {
            await widget.brigadeApi.setBrigade(brigade);
            Navigator.of(context).pop();
          } else {
            await widget.brigadeApi
                .updateBrigade(widget.brigade.idbrigade, brigade);
            Navigator.of(context).pop();
          }
        }
      } on AssertionError catch (e) {
        showAssertionAlertDialog(
          context,
          title: 'Operación fallida',
          exception: e,
        );
      } on NoSuchMethodError catch (e) {
        print(e.toString());
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
        title: Text(widget.brigade == null
            ? 'Nueva brigada'.toUpperCase()
            : 'Editar brigada'.toUpperCase()),
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
        onEditingComplete: _submit,
        // textInputAction: TextInputAction.,
      ),
    ];
  }
}
