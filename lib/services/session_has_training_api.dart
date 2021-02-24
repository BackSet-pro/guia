import 'package:flutter/foundation.dart';
import 'package:guia_entrenamiento/app/home/models/session_has_training.dart';
import 'package:guia_entrenamiento/services/api_path.dart';
import 'package:http/http.dart' as http;

class SessionHasTrainingApi with ChangeNotifier {
  Future<void> setSessionHasTraining(
      SessionHasTraining sessionHasTraining) async {
    await http.post(APIPath.source('session_has_training/'),
        body: sessionHasTraining.toJson());
    notifyListeners();
  }

  Stream<List<SessionHasTraining>> sessionHasTrainingStream() async* {
    final http.Response response =
        await http.get(APIPath.source('session_has_training/'));
    yield SessionHasTrainings.fromRawJson(response.body).sessionHasTrainings;
  }
}
