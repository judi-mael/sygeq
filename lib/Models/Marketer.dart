// To parse this JSON data, do
//
//     final marketer = marketerFromJson(jsonString);

import 'dart:convert';

Marketer marketerFromJson(String str) => Marketer.fromJson(json.decode(str));

String marketerToJson(Marketer data) => json.encode(data.toJson());

class Marketer {
  Marketer({
    required this.id,
    required this.agrement,
    required this.dateVigueur,
    required this.dateExpiration,
    required this.nom,
    required this.type,
    required this.adresse,
    required this.registre,
    required this.ifu,
    required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String agrement;
  String dateVigueur;
  String dateExpiration;
  String nom;
  String type;
  String adresse;
  String registre;
  String ifu;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory Marketer.fromJson(Map<String, dynamic> json) => Marketer(
        id: json["id"] ?? 0,
        agrement: json["agrement"] ?? "",
        dateVigueur: json["dateVigueur"] ?? "",
        dateExpiration: json["dateExpiration"] ?? "",
        nom: json["nom"] ?? "",
        type: json["identite"] ?? "",
        adresse: json["adresse"] ?? "",
        registre: json["registre"] ?? "",
        ifu: json["ifu"] ?? "",
        etat: json["etat"] ?? 0,
        // createdAt: json["createdAt"]?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agrement": agrement,
        "dateVigueur": dateVigueur,
        "dateExpiration": dateExpiration,
        "nom": nom,
        "type": type,
        "adresse": adresse,
        "registre": registre,
        "ifu": ifu,
        "etat": etat,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
