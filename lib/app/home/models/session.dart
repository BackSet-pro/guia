// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class ListSessions {
  ListSessions({
    this.sessions,
  });

  final List<Session> sessions;

  ListSessions copyWith({
    List<Session> sessions,
  }) =>
      ListSessions(
        sessions: sessions ?? this.sessions,
      );

  factory ListSessions.fromRawJson(String str) =>
      ListSessions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListSessions.fromJson(Map<String, dynamic> json) => ListSessions(
        sessions: List<Session>.from(
            json["sessions"].map((x) => Session.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sessions": List<dynamic>.from(sessions.map((x) => x.toJson())),
      };
}

class Session {
  Session({
    this.idsession,
    this.name,
    this.sessionCode,
    this.date,
    this.brigadeIdbrigade,
  });

  final int idsession;
  final String name;
  final String sessionCode;
  final DateTime date;
  final int brigadeIdbrigade;

  Session copyWith({
    int idsession,
    String name,
    String sessionCode,
    DateTime date,
    int brigadeIdbrigade,
  }) =>
      Session(
        idsession: idsession ?? this.idsession,
        name: name ?? this.name,
        sessionCode: sessionCode ?? this.sessionCode,
        date: date ?? this.date,
        brigadeIdbrigade: brigadeIdbrigade ?? this.brigadeIdbrigade,
      );

  factory Session.fromRawJson(String str) => Session.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        idsession: json["idsession"],
        name: json["name"],
        sessionCode: json["session_code"],
        date: DateTime.parse(json["date"]),
        brigadeIdbrigade: json["brigade_idbrigade"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "session_code": sessionCode,
        "date": date.toIso8601String(),
        "brigade_idbrigade": brigadeIdbrigade.toString(),
      };

  bool operator ==(dynamic other) =>
      other != null &&
      other is Session &&
      this.idsession == other.idsession &&
      this.name == other.name &&
      this.sessionCode == other.sessionCode &&
      this.date == other.date &&
      this.brigadeIdbrigade == other.brigadeIdbrigade;

  @override
  int get hashCode => super.hashCode;
}
