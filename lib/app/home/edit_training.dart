import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:guia_entrenamiento/common_widgets/input_text_common.dart';
import 'package:guia_entrenamiento/common_widgets/show_alert_dialog.dart';
import 'package:guia_entrenamiento/common_widgets/show_exception_alert_dialog.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditTrainingPage extends StatefulWidget {
  EditTrainingPage(
      {Key key,
      @required this.trainingApi,
      this.training,
      this.type,
      this.title})
      : super(key: key);
  final TrainingApi trainingApi;
  final Training training;
  final String type;
  final String title;

  static Future<void> show(BuildContext context,
      {Training training, String type, String title}) async {
    final trainingApi = context.read<TrainingApi>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTrainingPage(
          trainingApi: trainingApi,
          training: training,
          title: title,
          type: type,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditTrainingPageState createState() => _EditTrainingPageState();
}

class _EditTrainingPageState extends State<EditTrainingPage> {
  final _formKey = GlobalKey<FormState>();
  File _selectedFile;
  bool _inProcess = false;

  String _image;
  String _name;
  String _description;
  String _distance;
  String _style;
  String _pause;
  String _repetitions;
  String _intensity;
  String _time;
  String _numberSeries;

  @override
  void initState() {
    super.initState();
    if (widget.training != null) {
      _image = widget.training.image == null ? null : widget.training.image;
      _name = widget.training.name == null ? null : widget.training.name;
      _description = widget.training.description == null
          ? null
          : widget.training.description;
      _distance = widget.training.distance == null
          ? null
          : widget.training.distance.toString();
      _style = widget.training.style == null ? null : widget.training.style;
      _pause = widget.training.pausa == null
          ? null
          : widget.training.pausa.toString();

      _repetitions = widget.training.repetitions == null
          ? null
          : widget.training.repetitions.toString();
      _intensity = widget.training.intensity == null
          ? null
          : widget.training.intensity.toString();
      _time =
          widget.training.time == null ? null : widget.training.time.toString();
      _numberSeries = widget.training.numberSeries == null
          ? null
          : widget.training.numberSeries.toString();
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
        List<Training> brigades;
        switch (widget.type) {
          case 'warm_up':
            brigades = await widget.trainingApi.warmUpStream().first;
            break;
          case 'personalized':
            brigades = await widget.trainingApi.personalizedStream().first;
            break;
          case 'crossfit':
            brigades = await widget.trainingApi.crossfitStream().first;
            break;
          case 'stretching':
            brigades = await widget.trainingApi.stretchingStream().first;
            break;
          case 'for_km':
            brigades = await widget.trainingApi.forKmStream().first;
            break;
          case 'for_time':
            brigades = await widget.trainingApi.forTimeStream().first;
            break;
          case 'repetition':
            brigades = await widget.trainingApi.repetitionStream().first;
            break;
          case 'stair':
            brigades = await widget.trainingApi.stairStream().first;
            break;
          case 'fartlek':
            brigades = await widget.trainingApi.fartlekStream().first;
            break;
          case 'race':
            brigades = await widget.trainingApi.raceStream().first;
            break;
          case 'swimming':
            brigades = await widget.trainingApi.swimmingStream().first;
            break;
          case 'military_skill':
            brigades = await widget.trainingApi.militarySkillStream().first;
            break;
          case 'recreational_activity':
            brigades =
                await widget.trainingApi.recreationalActivityStream().first;
            break;
        }
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
            type: widget.type,
            image: _image,
            name: _name,
            description: _description,
            style: _style,
            distance: int.parse(_distance),
            pausa: int.parse(_pause),
            repetitions: int.parse(_repetitions),
            intensity: int.parse(_intensity),
            time: int.parse(_time),
            numberSeries: int.parse(_numberSeries),
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
      } on ArgumentError catch (e) {
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
        backgroundColor: Colors.black,
        elevation: 2.0,
        title: Text(widget.training == null
            ? 'Nuevo ${widget.title}'.toUpperCase()
            : 'Editar ${widget.title}'.toUpperCase()),
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
        onPressed: () async {
          getImage(ImageSource.gallery);
          await uploadImageToFirebase();
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
      InputTextCommon(
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Nombre'),
          initialValue: _name,
          validator: (value) =>
              value.isNotEmpty ? null : 'El campo no puede estar vacío',
          onSaved: (value) => _name = value,
          textInputAction: TextInputAction.next,
        ),
        unit: '',
      ),
      InputTextCommon(
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Descripción'),
          initialValue: _description,
          validator: (value) =>
              value.isNotEmpty ? null : 'El campo no puede estar vacío',
          onSaved: (value) => _description = value,
          textInputAction: TextInputAction.next,
          maxLines: null,
        ),
        unit: '',
      ),
      if (widget.type == 'stair' ||
          widget.type == 'repetition' ||
          widget.type == 'for_km' ||
          widget.type == 'race' ||
          widget.type == 'swimming')
        InputTextCommon(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Distancia'),
            initialValue: _distance,
            validator: (value) =>
                value.isNotEmpty ? null : 'El campo no puede estar vacío',
            onSaved: (value) => _distance = value,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          unit: 'km',
        ),
      if (widget.type == 'swimming')
        InputTextCommon(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Estilo'),
            initialValue: _style,
            validator: (value) =>
                value.isNotEmpty ? null : 'El campo no puede estar vacío',
            onSaved: (value) => _style = value,
            textInputAction: TextInputAction.next,
          ),
          unit: '',
        ),
      if (widget.type == 'stair' ||
          widget.type == 'repetition' ||
          widget.type == 'for_km' ||
          widget.type == 'race' ||
          widget.type == 'swimming')
        InputTextCommon(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Pausa'),
            initialValue: _pause,
            validator: (value) =>
                value.isNotEmpty ? null : 'El campo no puede estar vacío',
            onSaved: (value) => _pause = value,
            keyboardType: TextInputType.number,
          ),
          unit: ' minutos',
        ),
      if (widget.type == 'recreational_activity' ||
          widget.type == 'personalized' ||
          widget.type == 'crossfit')
        InputTextCommon(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Repeticiones'),
            initialValue: _repetitions,
            validator: (value) =>
                value.isNotEmpty ? null : 'El campo no puede estar vacío',
            onSaved: (value) => _repetitions = value,
            keyboardType: TextInputType.number,
          ),
          unit: '',
        ),
      if (widget.type == 'stair' ||
          widget.type == 'repetition' ||
          widget.type == 'fartlek' ||
          widget.type == 'for_km' ||
          widget.type == 'for_time' ||
          widget.type == 'race')
        InputTextCommon(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Intesidad'),
            initialValue: _intensity,
            validator: (value) =>
                value.isNotEmpty ? null : 'El campo no puede estar vacío',
            onSaved: (value) => _intensity = value,
            keyboardType: TextInputType.number,
          ),
          unit: ' %',
        ),
      if (widget.type == 'for_time' ||
          widget.type == 'warm_up' ||
          widget.type == 'stretching')
        InputTextCommon(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Tiempo'),
            initialValue: _time,
            validator: (value) =>
                value.isNotEmpty ? null : 'El campo no puede estar vacío',
            onSaved: (value) => _time = value,
            keyboardType: TextInputType.number,
          ),
          unit: ' minutos',
        ),
      if (widget.type == 'stair' ||
          widget.type == 'repetition' ||
          widget.type == 'military_skill')
        InputTextCommon(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Número de series'),
            initialValue: _numberSeries,
            validator: (value) =>
                value.isNotEmpty ? null : 'El campo no puede estar vacío',
            onSaved: (value) => _numberSeries = value,
            keyboardType: TextInputType.number,
          ),
          unit: ' minutos',
        ),
    ];
  }

  uploadImageToFirebase() async {
    final String path = 'warm_up/warm_up_${Uuid().v1()}.jpg';
    // final StorageReference storageReference = FirebaseStorage().ref().child(path);
    // final StorageUploadTask uploadTask = storageReference.putFile(_selectedFile);
    // if (uploadTask.isSuccessful || uploadTask.isComplete) {
    //   final String url = await storageReference.getDownloadURL();
    //   _image=url;
    //   print("The download URL is " + url);
    // }

    final firebase_storage.Reference postImageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(path);
    final firebase_storage.UploadTask uploadTask =
        postImageRef.putFile(_selectedFile);
    // final StreamSubscription<firebase_storage.TaskState>
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
  }
}
