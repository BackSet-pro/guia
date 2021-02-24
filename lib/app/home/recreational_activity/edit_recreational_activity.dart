import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditRecreationalActivityPage extends StatefulWidget {
  EditRecreationalActivityPage(
      {Key key, @required this.trainingApi, this.training})
      : super(key: key);
  final TrainingApi trainingApi;
  final Training training;

  static Future<void> show(BuildContext context, {Training training}) async {
    final trainingApi = context.read<TrainingApi>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditRecreationalActivityPage(
          trainingApi: trainingApi,
          training: training,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditRecreationalActivityPageState createState() =>
      _EditRecreationalActivityPageState();
}

class _EditRecreationalActivityPageState
    extends State<EditRecreationalActivityPage> {
  final _formKey = GlobalKey<FormState>();

  File _selectedFile;
  bool _inProcess = false;

  String _image;
  String _name;
  String _description;
  String _repetitions;

  @override
  void initState() {
    super.initState();
    if (widget.training != null) {
      _image = widget.training.image;
      _name = widget.training.name;
      _description = widget.training.description;
      _repetitions = widget.training.repetitions.toString();
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
        final brigades = await widget.trainingApi.repetitionStream().first;
        final allNames = brigades.map((brigade) => brigade.name).toList();
        if (widget.training != null) {
          allNames.remove(widget.training.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Nombre ya usado',
            content: 'Elija un nombre de trabajo diferente',
            defaultActionText: 'OK',
          );
        } else {
          final Training training = new Training().copyWith(
            type: 'recreational_activity',
            image: _image,
            name: _name,
            description: _description,
            repetitions: int.parse(_repetitions),
          );
          if (widget.training == null) {
            await widget.trainingApi.setTraining(training);
            Navigator.of(context).pop();
          } else {
            await widget.trainingApi
                .updateTraining(widget.training.idtraining, training);
            Navigator.of(context).pop();
          }
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2.0,
        title: Text(widget.training == null
            ? 'Nueva Act. Recreativa'
            : 'Editar Act. Recreativa'),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => _submit(),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_photo_alternate),
        onPressed: () {
          getImage(ImageSource.gallery);
        },
      ),
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
      Stack(
        children: [
          if (widget.training == null)
            (_selectedFile == null)
                ? Image.asset('assets/images/no-image.png')
                : Image.file(_selectedFile)
          else
            (_selectedFile != null)
                ? Image.file(_selectedFile)
                : FadeInImage(
                    image: NetworkImage(_image),
                    placeholder: AssetImage('assets/images/jar-loading.gif'),
                    height: 200.00,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          (_inProcess)
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Center()
        ],
      ),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Nombre'),
        initialValue: _name,
        validator: (value) =>
            value.isNotEmpty ? null : 'El campo no puede estar vacío',
        onSaved: (value) => _name = value,
        textInputAction: TextInputAction.next,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'descripción'),
        initialValue: _description,
        validator: (value) =>
            value.isNotEmpty ? null : 'El campo no puede estar vacío',
        onSaved: (value) => _description = value,
        textInputAction: TextInputAction.next,
        maxLines: null,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'repeticiones'),
        initialValue: _repetitions,
        validator: (value) =>
            value.isNotEmpty ? null : 'El nombre no puede estar vacío',
        onSaved: (value) => _repetitions = value,
        keyboardType: TextInputType.number,
        onEditingComplete: _submit,
      ),
    ];
  }

  uploadImageToFirebase() {
    final String path =
        'recreational_activity/recreational_activity_${DateTime.now().toString()}.jpg';
    final Reference postImageRef = FirebaseStorage.instance.ref().child(path);
    final UploadTask uploadTask = postImageRef.putFile(_selectedFile);
    uploadTask.whenComplete(() async {
      _image = await postImageRef.getDownloadURL();
    }).catchError((onError) {
      showAssertionAlertDialog(
        context,
        title: 'Operación fallida',
        exception: onError,
      );
    });
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    await ImagePicker().getImage(source: source).then((image) async {
      image.path;
      if (image != null) {
        File cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.red,
              toolbarTitle: "Guía digital AFM",
              statusBarColor: Colors.red.shade900,
              backgroundColor: Colors.white,
            ));

        this.setState(() {
          _selectedFile = cropped;
          _inProcess = false;
        });
      } else {
        this.setState(() {
          _inProcess = false;
        });
      }
    });
    await uploadImageToFirebase();
  }
}
