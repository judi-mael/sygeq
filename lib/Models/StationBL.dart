// To parse this JSON data, do
//
//     final stationBl = stationBlFromJson(jsonString);

import 'dart:convert';

StationBl stationBlFromJson(String str) => StationBl.fromJson(json.decode(str));

String stationBlToJson(StationBl data) => json.encode(data.toJson());

class StationBl {
  StationBl({
    required this.id,
    required this.poiId,
    required this.longitude,
    required this.latitude,
    required this.ifu,
    required this.rccm,
    required this.nom,
    required this.villeId,
    required this.adresse,
    required this.marketerId,
    required this.etat,
  });

  int id;
  String poiId;
  String longitude;
  String latitude;
  String ifu;
  String rccm;
  String nom;
  int villeId;
  String adresse;
  int marketerId;
  int etat;

  factory StationBl.fromJson(Map<String, dynamic> json) => StationBl(
        id: json["id"] ?? 0,
        poiId: json["poi_id"] ?? "",
        longitude: json["longitude"] ?? "",
        latitude: json["latitude"] ?? "",
        ifu: json["ifu"] ?? "",
        rccm: json["rccm"] ?? "",
        nom: json["nom"] ?? "",
        villeId: json["ville_id"] ?? 0,
        adresse: json["adresse"] ?? "",
        marketerId: json["marketer_id"] ?? 0,
        etat: json["etat"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poi_id": poiId,
        "longitude": longitude,
        "latitude": latitude,
        "ifu": ifu,
        "rccm": rccm,
        "nom": nom,
        "ville_id": villeId,
        "adresse": adresse,
        "marketer_id": marketerId,
        "etat": etat,
      };
}
