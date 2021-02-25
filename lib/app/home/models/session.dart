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
        sessions: json["sessions"] == null
            ? null
            : List<Session>.from(
                json["sessions"].map((x) => Session.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sessions": sessions == null
            ? null
            : List<dynamic>.from(sessions.map((x) => x.toJson())),
      };
}

class Session {
  Session({
    this.idsession,
    this.name,
    this.date,
    this.macroPause,
    this.microPause,
    this.numberSeries,
    this.brigadeIdbrigade,
  });

  final int idsession;
  final String name;
  final String date;
  final int macroPause;
  final int microPause;
  final int numberSeries;
  final int brigadeIdbrigade;

  Session copyWith({
    int idsession,
    String name,
    String date,
    int macroPause,
    int microPause,
    int numberSeries,
    int brigadeIdbrigade,
  }) =>
      Session(
        idsession: idsession ?? this.idsession,
        name: name ?? this.name,
        date: date ?? this.date,
        macroPause: macroPause ?? this.macroPause,
        microPause: microPause ?? this.microPause,
        numberSeries: numberSeries ?? this.numberSeries,
        brigadeIdbrigade: brigadeIdbrigade ?? this.brigadeIdbrigade,
      );

  factory Session.fromRawJson(String str) => Session.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        idsession: json["idsession"] == null ? null : json["idsession"],
        name: json["name"] == null ? null : json["name"],
        date: json["date"] == null ? null : json["date"],
        macroPause: json["macro_pause"] == null ? null : json["macro_pause"],
        microPause: json["micro_pause"] == null ? null : json["micro_pause"],
        numberSeries:
            json["number_series"] == null ? null : json["number_series"],
        brigadeIdbrigade: json["brigade_idbrigade"] == null
            ? null
            : json["brigade_idbrigade"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "macro_pause": macroPause.toString(),
        "micro_pause": microPause.toString(),
        "number_series": numberSeries.toString(),
        "brigade_idbrigade": brigadeIdbrigade.toString(),
      };

  bool operator ==(dynamic other) =>
      other != null &&
      other is Session &&
      this.idsession == other.idsession &&
      this.name == other.name &&
      this.numberSeries == other.numberSeries &&
      this.date == other.date &&
      this.microPause == other.microPause &&
      this.macroPause == other.macroPause &&
      this.brigadeIdbrigade == other.brigadeIdbrigade;

  @override
  int get hashCode => super.hashCode;
}
