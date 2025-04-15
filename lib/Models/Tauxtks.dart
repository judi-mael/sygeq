// To parse this JSON data, do
//
//     final tauxtks = tauxtksFromJson(jsonString);

import 'dart:convert';

Tauxtks tauxtksFromJson(String str) => Tauxtks.fromJson(json.decode(str));

String tauxtksToJson(Tauxtks data) => json.encode(data.toJson());

class Tauxtks {
  Tauxtks({
    required this.id,
    required this.valeurtk,
    required this.ref,
    // required this.dateVigeur,
    required this.dateDebut,
    required this.dateFin,
    required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String valeurtk;
  String ref;
  // String dateVigeur;
  String dateDebut;
  String dateFin;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory Tauxtks.fromJson(Map<String, dynamic> json) => Tauxtks(
        id: json["id"] ?? 0,
        valeurtk: json["valeurtk"] == null ? "" : json["valeurtk"].toString(),
        ref: json["ref"] ?? "",
        // dateVigeur: json["dateVigeur"],
        dateDebut: json["date_debut"] ?? "",
        dateFin: json["date_fin"] ?? "",
        etat: json["etat"] ?? 0,
        // createdAt: json["createdAt"]?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "valeurtk": valeurtk,
        "ref": ref,
        // "dateVigeur": dateVigeur,
        "date_debut": dateDebut,
        "date_fin": dateFin,
        "etat": etat,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
