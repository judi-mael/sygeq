// To parse this JSON data, do
//
//     final startPerRegion = startPerRegionFromJson(jsonString);

import 'dart:convert';

StartPerRegion startPerRegionFromJson(String str) =>
    StartPerRegion.fromJson(json.decode(str));

String startPerRegionToJson(StartPerRegion data) => json.encode(data.toJson());

class StartPerRegion {
  String region;
  List<Product> produits;

  StartPerRegion({
    required this.region,
    required this.produits,
  });

  factory StartPerRegion.fromJson(Map<String, dynamic> json) => StartPerRegion(
        region: json["region"] ?? "",
        produits: json["produits"] == null
            ? []
            : List<Product>.from(
                json["produits"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "region": region,
        "produits": List<dynamic>.from(produits.map((x) => x.toJson())),
      };
}

class Product {
  String produit;
  int qty;

  Product({
    required this.produit,
    required this.qty,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        produit: json["produit"] ?? "",
        qty: json["qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "produit": produit,
        "qty": qty,
      };
}
