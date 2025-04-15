// To parse this JSON data, do
//
//     final detailsLivraisons = detailsLivraisonsFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Statistiques/StartPerProduit.dart';

DetailsLivraisonsRapport detailsLivraisonsFromJson(String str) =>
    DetailsLivraisonsRapport.fromJson(json.decode(str));

String detailsLivraisonsToJson(DetailsLivraisonsRapport data) =>
    json.encode(data.toJson());

class DetailsLivraisonsRapport {
  int id;
  String bonlivraisonId;
  int produitId;
  int qtte;
  int createdBy;
  int updatedBy;
  SartProduit produit;
  // dynamic deletedBy;
  // dynamic restoredBy;
  // dynamic suspensionComment;
  // DateTime createdAt;
  // DateTime updatedAt;
  // dynamic deletedAt;

  DetailsLivraisonsRapport({
    required this.id,
    required this.bonlivraisonId,
    required this.produitId,
    required this.qtte,
    required this.createdBy,
    required this.updatedBy,
    required this.produit,
    // this.deletedBy,
    // this.restoredBy,
    // this.suspensionComment,
    // required this.createdAt,
    // required this.updatedAt,
    // this.deletedAt,
  });

  factory DetailsLivraisonsRapport.fromJson(Map<String, dynamic> json) =>
      DetailsLivraisonsRapport(
        id: json["id"],
        bonlivraisonId: json["bonlivraison_id"],
        produitId: json["produit_id"],
        qtte: json["qtte"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        produit: SartProduit.fromJson(json["Produit"]),
        // deletedBy: json["deletedBy"],
        // restoredBy: json["restoredBy"],
        // suspensionComment: json["suspensionComment"],
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
        // deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bonlivraison_id": bonlivraisonId,
    "produit_id": produitId,
    "qtte": qtte,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "produit": produit.toJson(),
    // "deletedBy": deletedBy,
    // "restoredBy": restoredBy,
    // "suspensionComment": suspensionComment,
    // "createdAt": createdAt.toIso8601String(),
    // "updatedAt": updatedAt.toIso8601String(),
    // "deletedAt": deletedAt,
  };
}
