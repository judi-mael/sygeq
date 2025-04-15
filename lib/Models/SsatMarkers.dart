// To parse this JSON data, do
//
//     final ssatMarkers = ssatMarkersFromJson(jsonString);

import 'dart:convert';
import 'package:sygeq/Models/Center.dart';

SsatMarkers ssatMarkersFromJson(String str) =>
    SsatMarkers.fromJson(json.decode(str));

String ssatMarkersToJson(SsatMarkers data) => json.encode(data.toJson());

class SsatMarkers {
  SsatMarkers({
    required this.id,
    required this.center,
    required this.nom,
    // required this.address,
  });

  int id;
  Center center;
  String nom;
  // Address address;

  factory SsatMarkers.fromJson(Map<String, dynamic> json) => SsatMarkers(
    id: json["id"] ?? 0,
    center: Center.fromJson(json["center"]),
    // address: Address.fromJson(json["address"]),
    nom: json["label"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "center": center.toJson(),
    // "address": address.toJson(),
    "nom": nom,
  };
}
