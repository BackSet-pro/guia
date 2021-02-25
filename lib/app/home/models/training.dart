// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class ListTrainings {
  ListTrainings({
    this.trainings,
  });

  final List<Training> trainings;

  ListTrainings copyWith({
    List<Training> trainings,
  }) =>
      ListTrainings(
        trainings: trainings ?? this.trainings,
      );

  factory ListTrainings.fromRawJson(String str) =>
      ListTrainings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListTrainings.fromJson(Map<String, dynamic> json) => ListTrainings(
        trainings: json["trainings"] == null
            ? null
            : List<Training>.from(
                json["trainings"].map((x) => Training.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trainings": trainings == null
            ? null
            : List<dynamic>.from(trainings.map((x) => x.toJson())),
      };
}

class Training {
  Training({
    this.idtraining,
    this.type,
    this.image,
    this.name,
    this.style,
    this.description,
    this.distance,
    this.pausa,
    this.repetitions,
    this.intensity,
    this.time,
    this.numberSeries,
  });

  final int idtraining;
  final String type;
  final String image;
  final String name;
  final String style;
  final String description;
  final int distance;
  final int pausa;
  final int repetitions;
  final int intensity;
  final int time;
  final dynamic numberSeries;

  Training copyWith({
    int idtraining,
    String type,
    String image,
    String name,
    String style,
    String description,
    int distance,
    int pausa,
    int repetitions,
    int intensity,
    int time,
    dynamic numberSeries,
  }) =>
      Training(
        idtraining: idtraining ?? this.idtraining,
        type: type ?? this.type,
        image: image ?? this.image,
        name: name ?? this.name,
        style: style ?? this.style,
        description: description ?? this.description,
        distance: distance ?? this.distance,
        pausa: pausa ?? this.pausa,
        repetitions: repetitions ?? this.repetitions,
        intensity: intensity ?? this.intensity,
        time: time ?? this.time,
        numberSeries: numberSeries ?? this.numberSeries,
      );

  factory Training.fromRawJson(String str) =>
      Training.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Training.fromJson(Map<String, dynamic> json) => Training(
        idtraining: json["idtraining"],
        type: json["type"],
        image: json["image"],
        name: json["name"],
        description: json["description"],
        style: json["style"] == null ? null : json["style"],
        distance: json["distance"] == null ? null : json["distance"],
        pausa: json["pausa"] == null ? null : json["pausa"],
        repetitions: json["repetitions"] == null ? null : json["repetitions"],
        intensity: json["intensity"] == null ? null : json["intensity"],
        time: json["time"] == null ? null : json["time"],
        numberSeries:
            json["number_series"] == null ? null : json["number_series"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "image": image,
        "name": name,
        "description": description,
        "style": style == null ? null : style.toString(),
        "distance": distance == null ? null : distance.toString(),
        "pausa": pausa == null ? null : pausa.toString(),
        "repetitions": repetitions == null ? null : repetitions.toString(),
        "intensity": intensity == null ? null : intensity.toString(),
        "time": time == null ? null : time.toString(),
        "number_series": numberSeries == null ? null : numberSeries.toString(),
      };

}
