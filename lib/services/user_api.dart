import 'package:flutter/foundation.dart';
import 'package:guia_entrenamiento/app/home/models/user.dart';

import 'api_path.dart';
import 'package:http/http.dart' as http;

class UserApi with ChangeNotifier {
  Future<void> setUser(User user) async {
    await http.post(APIPath.source('user/'), body: user.toJson());
    notifyListeners();
  }

  Future<void> deleteUser(User user) async {
    await http.delete(APIPath.source('user/${user.iduser}'));
  }

  Future<void> updateUser(int id, User stair) async {
    await http.put(APIPath.source('user/$id'), body: stair.toJson());
    notifyListeners();
  }

  // Stream<List<Stair>> stairStream() async* {
  //   final http.Response response = await http.get(APIPath.source('aerobic_activity/interval/stair'));
  //   yield ListStairs.fromRawJson(response.body).stairs;
  // }

  Stream<List<User>> userByIdSession(int idSession) async* {
    final http.Response response =
        await http.get(APIPath.source('query/user_by_id_session/+$idSession'));
    yield ListUsers.fromRawJson(response.body).users;
  }
}
