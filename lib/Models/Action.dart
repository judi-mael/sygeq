// To parse this JSON data, do
//
//     final action = actionFromJson(jsonString);

import 'dart:convert';

Action actionFromJson(String str) => Action.fromJson(json.decode(str));

String actionToJson(Action data) => json.encode(data.toJson());

class Action {
    Action({
      required  this.id,
      required  this.nom,
      required   this.etat,
      required  this.reatedBy,
      // required  this.createdBy,
      // required   this.updatedBy,
      // required  this.createdAt,
      // required  this.updatedAt,
      // required this.deletedAt,
    });

    int id;
    String nom;
    int etat;
    int reatedBy;
    // int createdBy;
    // int updatedBy;
    // String createdAt;
    // String updatedAt;
    // String deletedAt;

    factory Action.fromJson(Map<String, dynamic> json) => Action(
        id: int.parse(json["id"]),
        nom: json["nom"] ?? "",
       etat: json["etat"]== null?0:int.parse(json["etat"]),
        reatedBy: json["reated_by"]??0,
        // createdBy: json["created_by "],
        // updatedBy: json["updated_by"],
        // createdAt: json["createdAt"] ?? "",
        // updatedAt: json["updatedAt"] ?? "",
        // deletedAt: json["deletedAt"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "etat": etat,
        "reated_by": reatedBy,
        // "created_by ": createdBy,
        // "updated_by": updatedBy,
        // "createdAt": createdAt,
        // "updatedAt": updatedAt,
        // "deletedAt": deletedAt,
    };
}
