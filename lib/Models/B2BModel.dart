// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/B2BMarketers.dart';
import 'package:sygeq/Models/Ville.dart';

B2BModel stationFromJson(String str) => B2BModel.fromJson(json.decode(str));

String stationToJson(B2BModel data) => json.encode(data.toJson());

class B2BModel {
  B2BModel({
    required this.id,
    required this.nomStation,
    // required this.longitude,
    // required this.latitude,
    required this.agrement,
    required this.rccm,
    required this.ville,
    required this.ifu,
    required this.type,
    // required this.userId,
    required this.etat,
    required this.adresse,
    required this.b2bMarketers,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String nomStation;
  // double longitude;
  // double latitude;
  String agrement;
  String rccm;
  Ville ville;
  String ifu;
  String type;
  // int userId;
  int etat;
  String adresse;
  List<B2BMarketers> b2bMarketers;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory B2BModel.fromJson(Map<String, dynamic> json) => B2BModel(
    id: json["id"] ?? 0,
    nomStation: json["nom"] ?? "",
    // longitude: double.parse(json["longitude"]),
    // latitude: double.parse(json["latitude"]),
    agrement: json["agrement"] ?? "",
    rccm: json["rccm"] ?? "",
    ville: Ville.fromJson(json["Ville"]),
    ifu: json["ifu"] ?? '',

    // userId: json["userId"],
    etat: json["etat"] ?? 0,
    adresse: json["adresse"] ?? "",
    b2bMarketers: List<B2BMarketers>.from(
      json['B2BMarketers'].map((x) => B2BMarketers.fromJson(x)),
    ),
    // createdAt: json["createdAt"] ?? "",
    // createdBy: json["created_by"],
    // updatedAt: json["updatedAt"] ?? "",
    // updatedBy: json["updated_by"],
    deletedAt: json["deletedAt"] ?? "",
    type: json['type'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nomStation": nomStation,
    // "longitude": longitude,
    // "latitude": latitude,
    "agrement": agrement,
    "rccm": rccm,

    "etat": etat,
    "adresse": adresse,
    "ville": ville.toJson(),
    'type': type,
    "b2bMarketers": List<dynamic>.from(b2bMarketers.map((e) => e.toJson())),

    "deletedAt": deletedAt,
  };
}
