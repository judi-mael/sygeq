// To parse this JSON data, do
//
//     final produit = produitFromJson(jsonString);

import 'dart:convert';

Produit produitFromJson(String str) => Produit.fromJson(json.decode(str));

String produitToJson(Produit data) => json.encode(data.toJson());

class Produit {
  Produit({
    required this.id,
    required this.hscode,
    required this.type,
    required this.nom,
    required this.etat,
    required this.unite,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String hscode;
  String type;
  String nom;
  String unite;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory Produit.fromJson(Map<String, dynamic> json) => Produit(
        id: json["id"] ?? 0,
        hscode: json["hscode"] ?? "",
        type: json["type"] ?? "",
        nom: json["nom"] ?? "",
        etat: json["etat"] ?? 0,
        unite: json["unite"] ?? " ",
        // createdAt: json["createdAt"] ?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hscode": hscode,
        "type": type,
        "nom": nom,
        "etat": etat,
        "unite": unite,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
