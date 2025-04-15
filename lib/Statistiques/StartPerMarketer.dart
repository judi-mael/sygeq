// To parse this JSON data, do
//
//     final sartPermarketer = sartPermarketerFromJson(jsonString);

import 'dart:convert';

SartPermarketer sartPermarketerFromJson(String str) =>
    SartPermarketer.fromJson(json.decode(str));

String sartPermarketerToJson(SartPermarketer data) =>
    json.encode(data.toJson());

class SartPermarketer {
  String marketer;
  List<int> quantite;

  SartPermarketer({
    required this.marketer,
    required this.quantite,
  });

  factory SartPermarketer.fromJson(Map<String, dynamic> json) =>
      SartPermarketer(
        marketer: json["marketer"],
        quantite: List<int>.from(json["quantite"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "marketer": marketer,
        "quantite": List<dynamic>.from(quantite.map((x) => x)),
      };
}
