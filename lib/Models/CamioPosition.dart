// To parse this JSON data, do
//
//     final camionPosition = camionPositionFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Position.dart';

CamionPosition camionPositionFromJson(String str) =>
    CamionPosition.fromJson(json.decode(str));

String camionPositionToJson(CamionPosition data) => json.encode(data.toJson());

class CamionPosition {
  CamionPosition({required this.position, required this.lastUpdateTime});

  Positions position;
  String lastUpdateTime;

  factory CamionPosition.fromJson(Map<String, dynamic> json) => CamionPosition(
    position: Positions.fromJson(json["position"]),
    lastUpdateTime: json["lastUpdateTime"].toString(),
  );

  Map<String, dynamic> toJson() => {"position": position.toJson()};
}
