// To parse this JSON data, do
//
//     final detailLivraison = detailLivraisonFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/DetailBarcode.dart';
import 'package:sygeq/Models/Produit.dart';

DetailLivraison detailLivraisonFromJson(String str) =>
    DetailLivraison.fromJson(json.decode(str));

String detailLivraisonToJson(DetailLivraison data) =>
    json.encode(data.toJson());

class DetailLivraison {
  DetailLivraison({
    required this.id,
    required this.bonlivraison,
    required this.produit,
    required this.qtte,
    // required this.compartimentId,
    required this.barecode,
    // required this.etat,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    // required this.deletedAt,
  });

  int id;
  int bonlivraison;
  Produit produit;
  int qtte;
  // int compartimentId;
  List<DetailBarcode> barecode;
  // int etat;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  // String deletedAt;

  factory DetailLivraison.fromJson(Map<String, dynamic> json) =>
      DetailLivraison(
        id: json["id"] ?? 0,
        bonlivraison:
            json["bonlivraison_id"].runtimeType == int
                ? json["bonlivraison_id"]
                : int.parse(json["bonlivraison_id"]),
        produit: Produit.fromJson(json["produit"]),
        qtte: json["qtte"] ?? 0,
        // compartimentId: json["compartiment_id"],
        barecode:
            json["details_barcodes"] == null
                ? <DetailBarcode>[]
                : List<DetailBarcode>.from(
                  json["details_barcodes"].map(
                    (x) => DetailBarcode.fromJson(x),
                  ),
                ),
        // json["barecode"] ?? "",
        // etat: json["etat"],
        // createdAt: json["createdAt"]?? "",
        // createdBy: json["created_by"],
        // updatedAt: json["updatedAt"]?? "",
        // updatedBy: json["updated_by"],
        // deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bonlivraison": bonlivraison,
    "produit": produit.toJson(),
    "qtte": qtte,
    // "compartiment_id": compartimentId,
    "barecode": barecode,
    // "etat": etat,
    // "createdAt": createdAt,
    // "createdBy": createdBy,
    // "updatedAt": updatedAt,
    // "updatedBy": updatedBy,
    // "deletedAt": deletedAt,
  };
}
