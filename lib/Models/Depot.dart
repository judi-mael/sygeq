// To parse this JSON data, do
//
//     final depot = depotFromJson(jsonString);

import 'dart:convert';

Depot depotFromJson(String str) => Depot.fromJson(json.decode(str));

String depotToJson(Depot data) => json.encode(data.toJson());

class Depot {
  Depot({
    required this.id,
    required this.numDepotDouanier,
    required this.agrement,
    required this.ifu,
    // required this.registre,
    required this.dateVigueur,
    required this.dateExpiration,
    required this.nom,
    required this.adresse,
    required this.etat,
    required this.type,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String numDepotDouanier;
  String agrement;
  String ifu;
  // String registre;
  String dateVigueur;
  String dateExpiration;
  String nom;
  String adresse;
  String type;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory Depot.fromJson(Map<String, dynamic> json) => Depot(
        id: json["id"] ?? 0,
        numDepotDouanier: json["numdepotdouanier"] ?? "",
        agrement: json["agrement"] ?? "",
        ifu: json["ifu"] ?? "",
        // registre: json["registre"] ?? "",
        dateVigueur: json["dateVigueur"] ?? "",
        dateExpiration: json["dateExpiration"] ?? "",
        nom: json["nom"] ?? "",
        adresse: json["adresse"] ?? "",
        type: json["type"] ?? "",
        etat: json["etat"] ?? 0,
        // createdAt: json["createdAt"]?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "numDepotDouanier": numDepotDouanier,
        "agrement": agrement,
        "ifu": ifu,
        // "registre": registre,
        "dateVigueur": dateVigueur,
        "dateExpiration": dateExpiration,
        "nom": nom,
        "adresse": adresse,
        "etat": etat,
        "type": type,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
