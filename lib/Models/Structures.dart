// To parse this JSON data, do
//
//     final structure = structureFromJson(jsonString);

import 'dart:convert';

Structure structureFromJson(String str) => Structure.fromJson(json.decode(str));

String structureToJson(Structure data) => json.encode(data.toJson());

class Structure {
  Structure({
    required this.id,
    required this.produitId,
    required this.tauxpereq,
    required this.tauxprovision,
    required this.taux,
    required this.dateAppl,
    required this.dateExp,
    required this.differentiel,
    required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    // required this.deletedAt,
  });

  int id;
  double produitId;
  double tauxpereq;
  double tauxprovision;
  double taux;
  String dateAppl;
  String dateExp;
  String differentiel;
  int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  // String deletedAt;

  factory Structure.fromJson(Map<String, dynamic> json) => Structure(
        id: json["id"]??0,
        produitId: json["produitId"].toDouble(),
        tauxpereq: json["tauxpereq"].toDouble(),
        tauxprovision: json["tauxprovision"].toDouble(),
        taux: json["taux"].toDouble(),
        dateAppl: json["dateAppl"] ?? "",
        dateExp: json["dateExp"] ?? "",
        differentiel: json["differentiel"] ?? "",
       etat: json["etat"]== null?0:int.parse(json["etat"]),
        // createdAt: json["createdAt"] ?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"] ?? "",
        // updatedBy: json["updated_by"],
        // deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "produitId": produitId,
        "tauxpereq": tauxpereq,
        "tauxprovision": tauxprovision,
        "taux": taux,
        "dateAppl": dateAppl,
        "dateExp": dateExp,
        "etat": etat,
        "differentiel": differentiel,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        // "deletedAt": deletedAt,
      };
}
