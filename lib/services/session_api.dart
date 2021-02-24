import 'package:flutter/foundation.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/services/api_path.dart';
import 'package:http/http.dart' as http;

class SessionApi with ChangeNotifier {
  Future<void> setSession(Session session) async {
    await http.post(APIPath.source('session'), body: session.toJson());
    notifyListeners();
  }

  Future<void> deleteSession(Session session) async {
    await http.delete(APIPath.source('session/${session.idsession}'));
  }

  Future<void> updateSession(int id, Session session) async {
    await http.put(APIPath.source('session/$id'), body: session.toJson());
    notifyListeners();
  }

  Stream<List<Session>> sessionStream() async* {
    final http.Response response = await http.get(APIPath.source('session'));
    yield ListSessions.fromRawJson(response.body).sessions;
  }

  Stream<List<Session>> sessionsByIdBrigade(int id) async* {
    final http.Response response =
        await http.get(APIPath.source('query/session_by_id_brigade/+$id'));
    yield ListSessions.fromRawJson(response.body).sessions;
  }

  Stream<Session> sessionsByIdCodeSession(String code) async* {
    final http.Response response =
        await http.get(APIPath.source('query/session_by_code_session/+$code'));
    yield Session.fromRawJson(response.body);
  }
}
