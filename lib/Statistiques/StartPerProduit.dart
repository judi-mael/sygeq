// To parse this JSON data, do
//
//     final sartProduit = sartProduitFromJson(jsonString);

import 'dart:convert';

SartProduit sartProduitFromJson(String str) =>
    SartProduit.fromJson(json.decode(str));

String sartProduitToJson(SartProduit data) => json.encode(data.toJson());

class SartProduit {
  String produit;
  int total;

  SartProduit({
    required this.produit,
    required this.total,
  });

  factory SartProduit.fromJson(Map<String, dynamic> json) => SartProduit(
        produit: json["produit"] ?? 'null',
        total: json["total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "produit": produit,
        "total": total,
      };
}
