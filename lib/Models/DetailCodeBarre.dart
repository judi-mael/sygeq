// To parse this JSON data, do
//
//     final detailCodeBarre = detailCodeBarreFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Compartiment.dart';

DetailCodeBarre detailCodeBarreFromJson(String str) =>
    DetailCodeBarre.fromJson(json.decode(str));

String detailCodeBarreToJson(DetailCodeBarre data) =>
    json.encode(data.toJson());

class DetailCodeBarre {
  int id;
  String barcode;
  String creuCharger;
  String qty;
  Compartiment compartiment;

  DetailCodeBarre({
    required this.id,
    required this.barcode,
    required this.creuCharger,
    required this.qty,
    required this.compartiment,
  });

  factory DetailCodeBarre.fromJson(Map<String, dynamic> json) =>
      DetailCodeBarre(
        id: json["id"],
        barcode: json["barcode"].toString(),
        creuCharger: json["creu_charger"].toString(),
        qty: json["qty"].toString(),
        compartiment: Compartiment.fromJson(json['compartiment']),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "barcode": barcode,
    "creu_charger": creuCharger,
    "qty": qty,
    "compartiment": compartiment.toJson(),
  };
}
