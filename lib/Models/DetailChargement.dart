// To parse this JSON data, do
//
//     final detailChargement = detailChargementFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/DetailCodeBarre.dart';
import 'package:sygeq/Models/Produit.dart';

DetailChargement detailChargementFromJson(String str) =>
    DetailChargement.fromJson(json.decode(str));

String detailChargementToJson(DetailChargement data) =>
    json.encode(data.toJson());

class DetailChargement {
  int id;
  int qtte;
  Produit produits;
  List<DetailCodeBarre> detailcodeBarre;

  DetailChargement({
    required this.id,
    required this.qtte,
    required this.produits,
    required this.detailcodeBarre,
  });

  factory DetailChargement.fromJson(Map<String, dynamic> json) =>
      DetailChargement(
        id: json["id"],
        qtte: json["qtte"],
        produits: Produit.fromJson(json['produit']),
        detailcodeBarre: List<DetailCodeBarre>.from(
          json['detailChargement'].map((x) => DetailCodeBarre.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "qtte": qtte,
    "produits": produits.toJson(),
    "detailcodeBarre": List<dynamic>.from(
      detailcodeBarre.map((e) => e.toJson()),
    ),
  };
}
