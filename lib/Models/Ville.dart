// To parse this JSON data, do
//
//     final ville = villeFromJson(jsonString);

import 'dart:convert';

Ville villeFromJson(String str) => Ville.fromJson(json.decode(str));

String villeToJson(Ville data) => json.encode(data.toJson());

class Ville {
  Ville({
    required this.id,
    // required this.dep,
    required this.nom,
    // required this.depot,
    // required this.distance,
    // required this.difficulte,
    // required this.prime,
    // required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    // required this.deletedAt,
  });

  int id;
  // String dep;
  String nom;
  // String depot;
  // double distance;
  // double difficulte;
  // double prime;
  // int etat;
  // String createdAt;
  // String createdBy;
  // String updatedAt;
  // int updatedBy;
  // String deletedAt;

  factory Ville.fromJson(Map<String, dynamic> json) => Ville(
        id: json["id"]??0,
        // dep: json["dep"] ?? "",
        nom: json["nom"]??'',
        // depot: json["depot"],
        // distance: json["distance"].toDouble(),
        // difficulte: json["difficulte"].toDouble(),
        // prime: json["prime"].toDouble(),
        // etat: json["etat"],
        // createdAt: json["createdAt"] ?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"] ?? "",
        // updatedBy: json["updated_by"],
        // deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "dep": dep,
        // "depot": depot,
        "nom": nom,
        // "distance": distance,
        // "difficulte": difficulte,
        // "prime": prime,
        // "etat": etat,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        // "deletedAt": deletedAt,
      };
}
