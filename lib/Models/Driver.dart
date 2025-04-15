// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  Driver({
    required this.id,
    required this.agrement,
    required this.ifu,
    required this.dateVigeur,
    required this.dateExp,
    required this.nom,
    required this.adresse,
    // required this.marketer,
    required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String agrement;
  String ifu;
  String dateVigeur;
  String dateExp;
  String nom;
  String adresse;
  // Marketer marketer;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"]??0,
        agrement: json["agrement"] ?? "",
        ifu: json["ifu"] ?? "",
        dateVigeur: json["dateVigueur"] ?? "",
        dateExp: json["dateExpiration"] ?? "",
        nom: json["nom"] ?? "",
        adresse: json["adresse"] ?? "",
        // marketer: Marketer.fromJson(json["marketerId"]),
        etat: json["etat"] ?? 0,
        // createdAt: json["createdAt"],
        // createdBy: json["createdBy"],
        // updatedAt: json["updatedAt"],
        // updatedBy: json["updatedBy"],
        deletedAt: json["deletedAt"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agrement": agrement,
        "ifu": ifu,
        "dateVigeur": dateVigeur,
        "dateExp": dateExp,
        "nom": nom,
        "adresse": adresse,
        // "marketer": marketer.toJson(),
        "etat": etat,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
