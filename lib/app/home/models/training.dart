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
    this.numberSeries,
    this.repetitions,
    this.intensity,
    this.time,
    this.macroPause,
    this.microPause,
  });

  final int idtraining;
  final String type;
  final String image;
  final String name;
  final String style;
  final String description;
  final int distance;
  final int pausa;
  final int numberSeries;
  final int repetitions;
  final int intensity;
  final int time;
  final int macroPause;
  final int microPause;

  Training copyWith({
    int idtraining,
    String type,
    String image,
    String name,
    String style,
    String description,
    int distance,
    int pausa,
    int numberSeries,
    int repetitions,
    int intensity,
    int time,
    int macroPause,
    int microPause,
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
        numberSeries: numberSeries ?? this.numberSeries,
        repetitions: repetitions ?? this.repetitions,
        intensity: intensity ?? this.intensity,
        time: time ?? this.time,
        macroPause: macroPause ?? this.macroPause,
        microPause: microPause ?? this.microPause,
      );



  factory Training.fromRawJson(String str) =>
      Training.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Training.fromJson(Map<String, dynamic> json) => Training(
        idtraining: json["idtraining"],
        type: json["type"],
        image: json["image"],
        name: json["name"],
        style: json["style"] == null ? null : json["style"],
        description: json["description"] == null ? null : json["description"],
        distance: json["distance"] == null ? null : json["distance"],
        pausa: json["pausa"] == null ? null : json["pausa"],
        numberSeries:
            json["number_series"] == null ? null : json["number_series"],
        repetitions: json["repetitions"] == null ? null : json["repetitions"],
        intensity: json["intensity"] == null ? null : json["intensity"],
        time: json["time"] == null ? null : json["time"],
        macroPause: json["macro_pause"] == null ? null : json["macro_pause"],
        microPause: json["micro_pause"] == null ? null : json["micro_pause"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "image": image,
        "name": name,
        "description": description,
        if (style != null) "style": style,
        if (distance != null) "distance": distance.toString(),
        if (pausa != null) "pausa": pausa.toString(),
        if (numberSeries != null) "number_series": numberSeries.toString(),
        if (repetitions != null) "repetitions": repetitions.toString(),
        if (intensity != null) "intensity": intensity.toString(),
        if (time != null) "time": time.toString(),
        if (macroPause != null) "macro_pause": macroPause.toString(),
        if (microPause != null) "micro_pause": microPause.toString(),
      };
}
