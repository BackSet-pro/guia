// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class SessionHasTrainings {
  SessionHasTrainings({
    this.sessionHasTrainings,
  });

  final List<SessionHasTraining> sessionHasTrainings;

  SessionHasTrainings copyWith({
    List<SessionHasTraining> sessionHasTrainings,
  }) =>
      SessionHasTrainings(
        sessionHasTrainings: sessionHasTrainings ?? this.sessionHasTrainings,
      );

  factory SessionHasTrainings.fromRawJson(String str) =>
      SessionHasTrainings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SessionHasTrainings.fromJson(Map<String, dynamic> json) =>
      SessionHasTrainings(
        sessionHasTrainings: List<SessionHasTraining>.from(
            json["session_has_trainings"]
                .map((x) => SessionHasTraining.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "session_has_trainings":
            List<dynamic>.from(sessionHasTrainings.map((x) => x.toJson())),
      };
}

class SessionHasTraining {
  SessionHasTraining({
    this.sessionIdsession,
    this.trainingIdtraining,
  });

  final int sessionIdsession;
  final int trainingIdtraining;

  SessionHasTraining copyWith({
    int sessionIdsession,
    int trainingIdtraining,
  }) =>
      SessionHasTraining(
        sessionIdsession: sessionIdsession ?? this.sessionIdsession,
        trainingIdtraining: trainingIdtraining ?? this.trainingIdtraining,
      );

  factory SessionHasTraining.fromRawJson(String str) =>
      SessionHasTraining.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SessionHasTraining.fromJson(Map<String, dynamic> json) =>
      SessionHasTraining(
        sessionIdsession: json["session_idsession"],
        trainingIdtraining: json["training_idtraining"],
      );

  Map<String, dynamic> toJson() => {
        "session_idsession": sessionIdsession.toString(),
        "training_idtraining": trainingIdtraining.toString(),
      };
}
