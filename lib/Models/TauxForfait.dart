// To parse this JSON data, do
//
//     final tauxForfait = tauxForfaitFromJson(jsonString);

import 'dart:convert';

TauxForfait tauxForfaitFromJson(String str) =>
    TauxForfait.fromJson(json.decode(str));

String tauxForfaitToJson(TauxForfait data) => json.encode(data.toJson());

class TauxForfait {
  TauxForfait({
    required this.id,
    required this.dateVigeur,
    required this.dateExpiration,
    required this.tauxforfait,
    required this.distance,
    required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String dateVigeur;
  String dateExpiration;
  String tauxforfait;
  String distance;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory TauxForfait.fromJson(Map<String, dynamic> json) => TauxForfait(
        id: json["id"] ?? 0,
        dateVigeur: json["dateVigueur"] ?? "",
        dateExpiration: json["dateExpiration"] ?? "",
        tauxforfait:
            json["tarifforfait"] == null ? "" : json["tarifforfait"].toString(),
        distance: json["distance"] == null ? "" : json["distance"].toString(),
        etat: json["etat"] ?? 0,
        // createdAt: json["createdAt"]?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dateVigeur": dateVigeur,
        "dateExpiration": dateExpiration,
        "tauxforfait": tauxforfait,
        "distance": distance,
        "etat": etat,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        "deletedAt": deletedAt,
      };
}
