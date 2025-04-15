// To parse this JSON data, do
//
//     final marketer = marketerFromJson(jsonString);

import 'dart:convert';

MarketerP marketerFromJson(String str) => MarketerP.fromJson(json.decode(str));

String marketerToJson(MarketerP data) => json.encode(data.toJson());

class MarketerP {
  MarketerP({
    required this.id,
    required this.agrement,
    required this.dateVigueur,
    required this.dateExpiration,
    required this.nom,
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
  String adresse;
  String registre;
  String ifu;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory MarketerP.fromJson(Map<String, dynamic> json) => MarketerP(
        id: json["id"]??0,
        agrement: json["agrement"] ?? "",
        dateVigueur: json["dateVigueur"] ?? "",
        dateExpiration: json["dateExpiration"] ?? "",
        nom: json["nom"] ?? "",
        adresse: json["adresse"] ?? "",
        registre: json["registre"] ?? "",
        ifu: json["ifu"] ?? "",
        etat: json["etat"]??0,
        // createdAt: json["createdAt"]?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        deletedAt: json["deletedAt"]?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agrement": agrement,
        "dateVigueur": dateVigueur,
        "dateExpiration": dateExpiration,
        "nom": nom,
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
