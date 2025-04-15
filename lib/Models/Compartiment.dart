// To parse this JSON data, do
//
//     final compartiment = compartimentFromJson(jsonString);

import 'dart:convert';


Compartiment compartimentFromJson(String str) =>
    Compartiment.fromJson(json.decode(str));

String compartimentToJson(Compartiment data) => json.encode(data.toJson());

class Compartiment {
  Compartiment({
    required this.id,
    // required this.camion,
    required this.numero,
    required this.capacite,
    // required this.etat,
    required this.isBusy,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    // required this.deletedAt,
  });

  int id;
  // Camion camion;
  String numero;
  int capacite;
  // String createdAt;
  // int etat;
  int isBusy;
  // String updatedAt;
  // int updatedBy;
  // String deletedAt;

  factory Compartiment.fromJson(Map<String, dynamic> json) => Compartiment(
        id: json["id"] == null ? 0 : json["id"],
        // camion: Camion.fromJson(json["camion_id"]),
        numero: json["numero"] ?? "",
        // etat: json["etat"] ?? 0,
        capacite: json["capacite"] ?? 0,
        isBusy: json["is_busy"],
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        // deletedAt: json["deletedAt"]?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        //  "camion": camion.toJson(),
        "numero": numero,
        "capacite": capacite,
        // "etat": etat,
        "isBusy": isBusy,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        // "deletedAt": deletedAt,
      };
}
