// To parse this JSON data, do
//
//     final reseau = reseauFromJson(jsonString);

import 'dart:convert';

Reseau reseauFromJson(String str) => Reseau.fromJson(json.decode(str));

String reseauToJson(Reseau data) => json.encode(data.toJson());

class Reseau {
  Reseau({
    required this.id,
    required this.agrement,
    required this.ifu,
    required this.dateVigueur,
    required this.dateExpiration,
    required this.nom,
    required this.adresse,
    required this.marketerId,
    required this.etat,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String agrement;
  String ifu;
  String dateVigueur;
  String dateExpiration;
  String nom;
  String adresse;
  String marketerId;
  int etat;
  String createdAt;
  int createdBy;
  String updatedAt;
  int updatedBy;
  String deletedAt;

  factory Reseau.fromJson(Map<String, dynamic> json) => Reseau(
        id: json["id"],
        agrement: json["agrement"],
        ifu: json["ifu"],
        dateVigueur: json["dateVigueur"],
        dateExpiration: json["dateExpiration"],
        nom: json["nom"],
        adresse: json["adresse"],
        marketerId: json["marketerId"],
        etat: json["etat"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        updatedAt: json["updatedAt"],
        updatedBy: json["updatedBy"],
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agrement": agrement,
        "ifu": ifu,
        "dateVigueur": dateVigueur,
        "dateExpiration": dateExpiration,
        "nom": nom,
        "adresse": adresse,
        "marketerId": marketerId,
        "etat": etat,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updatedAt": updatedAt,
        "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
