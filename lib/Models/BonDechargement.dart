// To parse this JSON data, do
//
//     final bonDechargement = bonDechargementFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Driver.dart';

BonDechargement bonDechargementFromJson(String str) =>
    BonDechargement.fromJson(json.decode(str));

String bonDechargementToJson(BonDechargement data) =>
    json.encode(data.toJson());

class BonDechargement {
  BonDechargement({
    required this.id,
    required this.date,
    // required this.codeQr,
    // required this.gps,
    required this.dateDebut,
    required this.dateFin,
    required this.longitude,
    required this.lagitude,
    required this.etat,
    required this.dateheuredepart,
    required this.camion,
    required this.transporteur,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String date;
  // String codeQr;
  // String gps;
  String longitude;
  String lagitude;
  String dateDebut;
  String dateFin;
  String dateheuredepart;
  Camion camion;
  int etat;
  Driver transporteur;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory BonDechargement.fromJson(Map<String, dynamic> json) =>
      BonDechargement(
        id: json["id"] ?? 0,
        date: json["date"] ?? "",
        // codeQr: json["codeQR"],
        // gps: json["gps"],
        dateDebut: json["dateDebut"] ?? "",
        etat: json["etat"] == null ? 0 : int.parse(json["etat"]),
        dateFin: json["dateFin"] ?? "",
        longitude: json["longitude"] ?? "",
        lagitude: json["lagitude"] ?? "",
        dateheuredepart: json["dateheuredepart"] ?? "",
        camion: Camion.fromJson(json["camion_id"]),
        transporteur: Driver.fromJson(json["transporteur_id"]),
        // createdAt: json["createdAt"] ?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"] ?? "",
        // updatedBy: json["updated_by"],
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    // "codeQR": codeQr,
    // "gps": gps,
    "longitude": longitude,
    'lagitude': lagitude,
    "dateDebut": dateDebut,
    "dateFin": dateFin,
    "etat": etat,
    "dateheuredepart": dateheuredepart,
    "camion": camion.toJson(),
    "transporteur": transporteur.toJson(),
    // "createdAt": createdAt,
    // "createdBy": createdBy,
    // "updatedAt": updatedAt,
    // "updatedBy": updatedBy,
    "deletedAt": deletedAt,
  };
}
