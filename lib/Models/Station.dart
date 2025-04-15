// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/Ville.dart';

Station stationFromJson(String str) => Station.fromJson(json.decode(str));

String stationToJson(Station data) => json.encode(data.toJson());

class Station {
  Station({
    required this.id,
    required this.nomStation,
    required this.longitude,
    required this.latitude,
    required this.agrement,
    required this.rccm,
    required this.ville,
    required this.ifu,
    required this.type,
    // required this.userId,
    required this.etat,
    required this.adresse,
    required this.marketer,
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
  Ville ville;
  String ifu;
  String type;
  // int userId;
  int etat;
  String adresse;
  Marketer marketer;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    id: json["id"] ?? 0,
    nomStation: json["nom"] ?? "",
    longitude:
        json["longitude"] == null ? 0.0 : double.parse(json["longitude"]),
    latitude: json["latitude"] == null ? 0.0 : double.parse(json["latitude"]),
    agrement: json["agrement"] ?? "",
    rccm: json["rccm"] ?? "",
    ville:
        json["ville"] == null
            ? Ville(id: 0, nom: '')
            : Ville.fromJson(json["ville"]),
    ifu: json["ifu"] ?? '',
    type: json["type"] ?? '',
    // userId: json["userId"],
    etat: json["etat"] ?? 0,
    adresse: json["adresse"] ?? "",
    marketer:
        json["marketer"] == null
            ? Marketer(
              id: 0,
              agrement: '',
              dateVigueur: '',
              dateExpiration: '',
              nom: '',
              type: '',
              adresse: '',
              registre: '',
              ifu: '',
              etat: 0,
              deletedAt: '',
            )
            : Marketer.fromJson(json["marketer"]),
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
    "type": type,
    // "fonction": fonction,
    // "typeUser": typeUser,
    // "userId": userId,
    "etat": etat,
    "adresse": adresse,
    "ville": ville.toJson(),
    "marketerId": marketer.toJson(),
    // "createdAt": createdAt,
    // "createdBy": createdBy,
    // "updatedAt": updatedAt,
    // "updatedBy": updatedBy,
    "deletedAt": deletedAt,
  };
}
