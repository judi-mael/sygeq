// To parse this JSON data, do
//
//     final contrat = contratFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';

Contrat contratFromJson(String str) => Contrat.fromJson(json.decode(str));

String contratToJson(Contrat data) => json.encode(data.toJson());

class Contrat {
  Contrat({
    required this.id,
    required this.marketer,
    required this.driver,
    required this.statut,
    required this.etat,
    required this.deletedAt,
  });

  int id;
  Marketer marketer;
  Driver driver;
  String statut;
  int etat;
  String deletedAt;

  factory Contrat.fromJson(Map<String, dynamic> json) => Contrat(
    id: json["id"] ?? 0,
    marketer: Marketer.fromJson(json["marketer"]),
    driver: Driver.fromJson(json["transporteur"]),
    statut: json["statut"] ?? '',
    etat: json["etat"] ?? 0,
    deletedAt: json["deletedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "marketer": marketer.toJson(),
    "driver": driver.toString(),
    "statut": statut,
    "etat": etat,
    "deletedAt": deletedAt,
  };
}
