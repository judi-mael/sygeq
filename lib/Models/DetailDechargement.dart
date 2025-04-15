// To parse this JSON data, do
//
//     final detailDechargement = detailDechargementFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Produit.dart';

DetailDechargement detailDechargementFromJson(String str) =>
    DetailDechargement.fromJson(json.decode(str));

String detailDechargementToJson(DetailDechargement data) =>
    json.encode(data.toJson());

class DetailDechargement {
  DetailDechargement({
    required this.id,
    required this.produit,
    required this.quantite,
    required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    // required this.deletedAt,
  });

  int id;
  Produit produit;
  int quantite;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  // String deletedAt;

  factory DetailDechargement.fromJson(Map<String, dynamic> json) =>
      DetailDechargement(
        id: json["id"] ?? 0,
        produit: Produit.fromJson(json["produit_id"]),
        quantite: json["quantite"] ?? 0,
        etat: json["etat"] == null ? 0 : int.parse(json["etat"]),
        // createdAt: json["createdAt"],
        // createdBy: json["createdBy"],
        // updatedAt: json["updatedAt"],
        // updatedBy: json["updatedBy"],
        // deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "produit": produit.toJson(),
    "quantite": quantite,
    // "createdAt": createdAt,
    // "createdBy": createdBy,
    // "updatedAt": updatedAt,
    // "updatedBy": updatedBy,
    // "deletedAt": deletedAt,
  };
}
