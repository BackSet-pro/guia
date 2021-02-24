// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class ListBrigades {
  ListBrigades({
    this.brigades,
  });

  final List<Brigade> brigades;

  ListBrigades copyWith({
    List<Brigade> brigades,
  }) =>
      ListBrigades(
        brigades: brigades ?? this.brigades,
      );

  factory ListBrigades.fromRawJson(String str) =>
      ListBrigades.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListBrigades.fromJson(Map<String, dynamic> json) => ListBrigades(
        brigades: List<Brigade>.from(
            json["brigades"].map((x) => Brigade.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "brigades": List<dynamic>.from(brigades.map((x) => x.toJson())),
      };
}

class Brigade {
  Brigade({
    this.idbrigade,
    this.name,
  });

  int idbrigade;
  String name;

  Brigade copyWith({
    int idbrigade,
    String name,
  }) =>
      Brigade(
        idbrigade: idbrigade ?? this.idbrigade,
        name: name ?? this.name,
      );

  factory Brigade.fromRawJson(String str) => Brigade.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Brigade.fromJson(Map<String, dynamic> json) => Brigade(
        idbrigade: json["idbrigade"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };

  bool operator ==(dynamic other) =>
      other != null &&
      other is Brigade &&
      this.idbrigade == other.idbrigade &&
      this.name == other.name;

  @override
  int get hashCode => super.hashCode;
}
