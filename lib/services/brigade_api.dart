import 'package:guia_entrenamiento/app/home/models/brigade.dart';
import 'package:guia_entrenamiento/services/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BrigadeApi with ChangeNotifier {
  Future<void> setBrigade(Brigade brigade) async {
    await http.post(APIPath.source('brigade'), body: brigade.toJson());
    notifyListeners();
  }

  Future<void> deleteBrigade(Brigade brigade) async {
    await http.delete(APIPath.source('brigade/${brigade.idbrigade}'));
  }

  Future<void> updateBrigade(int id, Brigade brigade) async {
    await http.put(APIPath.source('brigade/$id'), body: brigade.toJson());
    notifyListeners();
  }

  Stream<List<Brigade>> brigadeStream() async* {
    final http.Response response = await http.get(APIPath.source('brigade'));
    yield ListBrigades.fromRawJson(response.body).brigades;
    notifyListeners();
  }

  Stream<Brigade> brigadeByIdSessionStream(int id) async* {
    final http.Response response =
        await http.get(APIPath.source('brigade_by_id_session/$id'));
    yield Brigade.fromRawJson(response.body);
    notifyListeners();
  }
}
