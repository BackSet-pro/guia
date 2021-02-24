import 'package:flutter/foundation.dart';
import 'package:guia_entrenamiento/app/home/models/training.dart';
import 'package:http/http.dart' as http;

import 'api_path.dart';

class TrainingApi with ChangeNotifier {
  Future<void> setTraining(Training training) async {
    await http.post(APIPath.source('training/'), body: training.toJson());
    notifyListeners();
  }

  Future<void> updateTraining(int id, Training training) async {
    await http.put(APIPath.source('training/$id'), body: training.toJson());
    notifyListeners();
  }

  Future<void> deleteTraining(int idTraining) async {
    await http.delete(APIPath.source('training/$idTraining'));
    notifyListeners();
  }

  Stream<List<Training>> trainingStream() async* {
    final http.Response response = await http.get(APIPath.source('training/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> trainingByIdSession(int id) async* {
    final http.Response response =
        await http.get(APIPath.source('query/training_by_session_id/+$id'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  /*
  *
  * Tables
  *
  * */

  Stream<List<Training>> crossfitStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/crossfit/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> personalizedStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/personalized/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> warmUpStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/warm_up/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> stretchingStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/stretching/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> forKmStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/for_km/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> forTimeStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/for_time/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> repetitionStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/repetition/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> stairStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/stair/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> fartlekStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/fartlek/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> raceStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/race/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> swimmingStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/swimming/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> militarySkillStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/military_skill/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }

  Stream<List<Training>> recreationalActivityStream() async* {
    final http.Response response =
        await http.get(APIPath.source('training/recreational_activity/'));
    yield ListTrainings.fromRawJson(response.body).trainings;
  }
}
