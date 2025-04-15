// To parse this JSON data, do
//
//     final statistiqueMarketer = statistiqueMarketerFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Statistiques/StartPerProduit.dart';

StatistiqueMarketer statistiqueMarketerFromJson(String str) =>
    StatistiqueMarketer.fromJson(json.decode(str));

String statistiqueMarketerToJson(StatistiqueMarketer data) =>
    json.encode(data.toJson());

class StatistiqueMarketer {
  StatistiqueMarketer({
    // required this.year,
    required this.month,
    required this.state,
  });

  // int year;
  String month;
  List<SartProduit> state;

  factory StatistiqueMarketer.fromJson(Map<String, dynamic> json) =>
      StatistiqueMarketer(
        // year: json["year"],
        month: json["month"] ?? "",
        state:
            json["stats"] != null
                ? List<SartProduit>.from(
                  json["stats"].map((e) => SartProduit.fromJson(e)),
                )
                : <SartProduit>[],
      );

  Map<String, dynamic> toJson() => {
    // "year": year,
    "month": month,
    "state": List<dynamic>.from(state.map((e) => e.toJson())),
  };
}
