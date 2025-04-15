// To parse this JSON data, do
//
//     final vehicule = vehiculeFromJson(jsonString);

import 'dart:convert';

Vehicule vehiculeFromJson(String str) => Vehicule.fromJson(json.decode(str));

String vehiculeToJson(Vehicule data) => json.encode(data.toJson());

class Vehicule {
  Vehicule({
    required this.id,
    required this.immatricul,
    required this.marque,
  });

  int id;
  String immatricul;
  String marque;

  factory Vehicule.fromJson(Map<String, dynamic> json) => Vehicule(
        id: json["id"] ?? 0,
        immatricul: json["plateNumber"] ?? "",
        marque: json["brand"] == '' ? "Inconnu" : json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "immatricul": immatricul,
        "marque": marque,
      };
}
