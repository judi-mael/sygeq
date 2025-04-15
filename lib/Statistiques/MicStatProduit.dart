// To parse this JSON data, do
//
//     final staProduit = staProduitFromJson(jsonString);

import 'dart:convert';

StaProduit staProduitFromJson(String str) =>
    StaProduit.fromJson(json.decode(str));

String staProduitToJson(StaProduit data) => json.encode(data.toJson());

class StaProduit {
  StaProduit({
    required this.produit,
    required this.total,
  });

  String produit;
  int total;

  factory StaProduit.fromJson(Map<String, dynamic> json) => StaProduit(
        produit: json["produit"] ?? 'null',
        total: json["total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "produit": produit,
        "total": total,
      };
}
