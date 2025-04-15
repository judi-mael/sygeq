// To parse this JSON data, do
//
//     final bonchargement = bonchargementFromJson(jsonString);

import 'dart:convert';

Bonchargement bonchargementFromJson(String str) =>
    Bonchargement.fromJson(json.decode(str));

String bonchargementToJson(Bonchargement data) => json.encode(data.toJson());

class Bonchargement {
  Bonchargement({
    required this.id,
    required this.dateheuredepart,
    // required this.date,
    // required this.codeQr,
    // required this.gps,
    // required this.dateDebut,
    // required this.dateFin,
    // required this.camionId,
    // required this.transporteurId,
    // required this.marketerId,
    required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    // required this.deletedAt,
  });

  int id;
  String dateheuredepart;
  // String date;
  // String codeQr;
  // String gps;
  // String dateDebut;
  // String dateFin;
  // int camionId;
  // int transporteurId;
  // int marketerId;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  // String deletedAt;

  factory Bonchargement.fromJson(Map<String, dynamic> json) => Bonchargement(
        id: json["id"]??0,
        // date: json["date"],
        // codeQr: json["codeQR"],
        // gps: json["gps"],
        // dateDebut: json["dateDebut"],
        // dateFin: json["dateFin"],
        dateheuredepart: json["dateheuredepart"]?? "",
        // camionId: json["camion_id"],
        // transporteurId: json["transporteur_id"],
        // marketerId: json["marketer_id"],
         etat: json["etat"]== null?0:int.parse(json["etat"]),
        // createdAt: json["createdAt"] ?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        // deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "date": date,
        // "codeQR": codeQr,
        // "gps": gps,
        // "dateDebut": dateDebut,
        // "dateFin": dateFin,
         "dateheuredepart": dateheuredepart,
        // "camion_id": camionId,
        // "transporteur_id": transporteurId,
        // "marketer_id": marketerId,
        "etat": etat,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        // "deletedAt": deletedAt,
      };
}
