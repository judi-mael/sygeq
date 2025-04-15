// To parse this JSON data, do
//
//     final camion = camionFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/Driver.dart';

Camion camionFromJson(String str) => Camion.fromJson(json.decode(str));

String camionToJson(Camion data) => json.encode(data.toJson());

class Camion {
  Camion({
    required this.id,
    required this.imat,
    required this.nbreVanne,
    required this.vannes,
    required this.annee,
    required this.capacity,
    required this.filling_level,
    required this.type,
    required this.isActive,
    required this.marque,
    required this.etat,
    required this.marketer_id,
    required this.transporteur,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    required this.deletedAt,
  });

  int id;
  String imat;
  int nbreVanne;
  List<Compartiment> vannes;
  String annee;
  int capacity;
  int filling_level;
  String type;
  bool isActive;
  String marque;
  int etat;
  String marketer_id;
  Driver transporteur;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  String deletedAt;

  factory Camion.fromJson(Map<String, dynamic> json) => Camion(
    id: json["id"] ?? 0,
    imat: json["imat"] ?? '',
    nbreVanne: json["nbrVanne"] ?? 0,
    vannes:
        json["vannes"] == null
            ? []
            : List<Compartiment>.from(
              json["vannes"].map((x) => Compartiment.fromJson(x)),
            ),
    annee: json["annee"] ?? "",
    capacity: json["capacity"] ?? 0,
    filling_level: json["filling_level"] ?? 0,
    type: json["type"] ?? "",
    isActive: json["isactive"] ?? false,
    marque: json["marque"] ?? "",
    etat: json["etat"] ?? 0,
    marketer_id: json["marketer_id"] ?? "",
    transporteur: json["transporteur"]==null? Driver(
      nom: 'Transporteur suspendu',ifu: '',id: 0,etat: 0,adresse: '',agrement: '',dateExp: "",dateVigeur: "",deletedAt: '',
    ) : Driver.fromJson(json["transporteur"]),
    // createdAt: json["createdAt"]?? "",
    // createdBy: json["created_by"],
    // updatedAt: json["updatedAt"]?? "",
    // updatedBy: json["updated_by"],
    deletedAt: json["deletedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imat": imat,
    "nbreVanne": nbreVanne,
    "vannes": List<dynamic>.from(vannes.map((x) => x.toJson())),
    "annee": annee,
    "filling_level": filling_level,
    "capacity": capacity,
    "type": type,
    "isActive": isActive,
    "marque": marque,
    "etat": etat,
    "marketer_id": marketer_id,
    "transporteur": transporteur.toJson(),
    // "createdAt": createdAt,
    // "createdBy": createdBy,
    // "updatedAt": updatedAt,
    // "updatedBy": updatedBy,
    "deletedAt": deletedAt,
  };
}
