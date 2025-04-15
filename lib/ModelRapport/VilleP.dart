// To parse this JSON data, do
//
//     final ville = villeFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/ModelRapport/DetailsVilleRapport.dart';

VilleP villeFromJson(String str) => VilleP.fromJson(json.decode(str));

String villeToJson(VilleP data) => json.encode(data.toJson());

class VilleP {
  VilleP({
    required this.id,
    // required this.dep,
    required this.nom,
    this.detailVille,
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
  List<DetailsVilles>? detailVille;
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

  factory VilleP.fromJson(Map<String, dynamic> json) => VilleP(
    id: json["id"] ?? 0,
    // dep: json["dep"] ?? "",
    nom: json["nom"] ?? '',
    detailVille: List<DetailsVilles>.from(
      json["DetailsVilles"].map((e) => DetailsVilles.fromJson(e)),
    ),
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
    "detailVille": List<dynamic>.from(detailVille!.map((e) => e.toJson())),
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
