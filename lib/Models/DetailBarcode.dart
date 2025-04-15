// To parse this JSON data, do
//
//     final detailBarcode = detailBarcodeFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Compartiment.dart';

DetailBarcode detailBarcodeFromJson(String str) =>
    DetailBarcode.fromJson(json.decode(str));

String detailBarcodeToJson(DetailBarcode data) => json.encode(data.toJson());

class DetailBarcode {
  DetailBarcode({
    required this.id,
    required this.detailsLivraison,
    required this.compartiment,
    required this.qty,
    required this.barcorde,
    required this.etat,
    // required  this.createdBy,
    // required  this.updatedBy,
    // required  this.createdAt,
    // required  this.updatedAt,
    // required  this.deletedAt,
  });

  int id;
  int detailsLivraison;
  Compartiment compartiment;
  int qty;
  String barcorde;
  int etat;
  // int createdBy;
  // int updatedBy;
  // String createdAt;
  // String updatedAt;
  // String deletedAt;

  factory DetailBarcode.fromJson(Map<String, dynamic> json) => DetailBarcode(
    id: json["id"] ?? 0,
    detailsLivraison: json["detailsLivraison_id"] ?? 0,
    compartiment:
        json["Compartiment"] == null
            ? Compartiment(id: 0, numero: 'numero', capacite: 0, isBusy: 0)
            : Compartiment.fromJson(json["Compartiment"]),
    qty: json["qty"] ?? 0,
    barcorde: json["barcode"] ?? "",
    etat: json["etat"] ?? 0,
    // createdBy: json["created_by "],
    // updatedBy: json["updated_by"],
    // createdAt: json["createdAt"] ?? "",
    // updatedAt: json["updatedAt"] ?? "",
    // deletedAt: json["deletedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "detailsLivraison": detailsLivraison,
    "compartiment": compartiment.toJson(),
    "qty": qty,
    "barcorde": barcorde,
    "etat": etat,
    // "created_by ": createdBy,
    // "updated_by": updatedBy,
    // "createdAt": createdAt,
    // "updatedAt": updatedAt,
    // "deletedAt": deletedAt,
  };
}
