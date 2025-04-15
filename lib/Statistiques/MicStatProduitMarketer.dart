// To parse this JSON data, do
//
//     final starProduitMarketer = starProduitMarketerFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Statistiques/MicStatProduit.dart';

StarProduitMarketer starProduitMarketerFromJson(String str) =>
    StarProduitMarketer.fromJson(json.decode(str));

String starProduitMarketerToJson(StarProduitMarketer data) =>
    json.encode(data.toJson());

class StarProduitMarketer {
  StarProduitMarketer({required this.marketer, required this.produit});

  String marketer;
  List<StaProduit> produit;
  // StaProduit data;

  factory StarProduitMarketer.fromJson(Map<String, dynamic> json) =>
      StarProduitMarketer(
        marketer: json["marketer"] ?? "",
        // data: StaProduit.fromJson(json["data"]),
        produit:
            json["data"] == null
                ? <StaProduit>[]
                : List<StaProduit>.from(
                  json["data"].map((x) => StaProduit.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "marketer": marketer,
    // "data": data.toJson(),
    "produit": List<dynamic>.from(produit.map((x) => x.toJson())),
  };
}
