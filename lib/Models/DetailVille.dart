// To parse this JSON data, do
//
//     final detailVille = detailVilleFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Ville.dart';

DetailVille detailVilleFromJson(String str) =>
    DetailVille.fromJson(json.decode(str));

String detailVilleToJson(DetailVille data) => json.encode(data.toJson());

class DetailVille {
  DetailVille({
    required this.id,
    required this.ville,
    required this.depot,
    required this.distance,
    required this.etat,
    //  required this.createdBy,
    //  required this.updatedBy,
    //  required this.createdAt,
    //  required this.updatedAt,
    //  required this.deletedAt,
  });

  int id;
  Ville ville;
  String depot;
  String distance;
  int etat;
  // int createdBy;
  // int updatedBy;
  // String createdAt;
  // String updatedAt;
  // String deletedAt;

  factory DetailVille.fromJson(Map<String, dynamic> json) => DetailVille(
    id: json["id"] ?? 0,
    ville: Ville.fromJson(json["ville_id"]),
    depot: json["depot"] ?? "",
    distance: json["distance"] ?? "",
    etat: json["etat"] ?? 0,
    // createdBy: json["created_by "],
    // updatedBy: json["updated_by"],
    // createdAt: json["createdAt"] ?? "",
    // updatedAt: json["updatedAt"] ?? "",
    // deletedAt: json["deletedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ville": ville.toJson(),
    "depot": depot,
    "distance": distance,
    "etat": etat,
    // "created_by ": createdBy,
    // "updated_by": updatedBy,
    // "createdAt": createdAt,
    // "updatedAt": updatedAt,
    // "deletedAt": deletedAt,
  };
}
