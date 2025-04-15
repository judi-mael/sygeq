// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

// import 'package:sygeq/Models/Ville.dart';
import 'package:sygeq/ModelRapport/VilleP.dart';

StationP stationFromJson(String str) => StationP.fromJson(json.decode(str));

String stationToJson(StationP data) => json.encode(data.toJson());

class StationP {
  StationP({
    required this.id,
    required this.nomStation,
    required this.longitude,
    required this.latitude,
    required this.agrement,
    required this.rccm,
    required this.ville,
    required this.ifu,
    // required this.userId,
    required this.etat,
    required this.adresse,
    // required this.marketer,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String nomStation;
  double longitude;
  double latitude;
  String agrement;
  String rccm;
  VilleP ville;
  String ifu;
  // int userId;
  int etat;
  String adresse;
  // MarketerP marketer;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory StationP.fromJson(Map<String, dynamic> json) => StationP(
    id: json["id"] ?? 0,
    nomStation: json["nom"] ?? "",
    longitude:
        json["longitude"] == null ? 0.0 : double.parse(json["longitude"]),
    latitude: json["latitude"] == null ? 0.0 : double.parse(json["latitude"]),
    agrement: json["agrement"] ?? "",
    rccm: json["rccm"] ?? "",
    ville: VilleP.fromJson(json["Ville"]),
    ifu: json["ifu"] ?? '',
    // userId: json["userId"],
    etat: json["etat"] ?? 0,
    adresse: json["adresse"] ?? "",
    // marketer: MarketerP.fromJson(json["Marketer"]),
    // createdAt: json["createdAt"] ?? "",
    // createdBy: json["created_by"],
    // updatedAt: json["updatedAt"] ?? "",
    // updatedBy: json["updated_by"],
    deletedAt: json["deletedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nomStation": nomStation,
    "longitude": longitude,
    "latitude": latitude,
    "agrement": agrement,
    "rccm": rccm,
    // "fonction": fonction,
    // "typeUser": typeUser,
    // "userId": userId,
    "etat": etat,
    "adresse": adresse,
    "ville": ville.toJson(),
    // "marketerId": marketer.toJson(),
    // "createdAt": createdAt,
    // "createdBy": createdBy,
    // "updatedAt": updatedAt,
    // "updatedBy": updatedBy,
    "deletedAt": deletedAt,
  };
}
