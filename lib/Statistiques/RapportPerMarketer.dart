// To parse this JSON data, do
//
//     final rapportPerMarketer = rapportPerMarketerFromJson(jsonString);

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:sygeq/Statistiques/RapportBLS.dart';

RapportPerMarketer rapportPerMarketerFromJson(String str) =>
    RapportPerMarketer.fromJson(json.decode(str));

String rapportPerMarketerToJson(RapportPerMarketer data) =>
    json.encode(data.toJson());

class RapportPerMarketer {
  String? marketer;
  String? qty;
  String? ftbl;
  String? cblTp;
  String? cblTtid;
  String? cblTdt;
  String? caisse;
  String? bilan;
  List<StartBls> bls;

  RapportPerMarketer({
    this.marketer,
    this.qty,
    this.ftbl,
    this.cblTp,
    this.cblTtid,
    this.cblTdt,
    this.caisse,
    this.bilan,
    required this.bls,
  });

  factory RapportPerMarketer.fromJson(Map<String, dynamic> json) =>
      RapportPerMarketer(
        marketer: json["marketer"] == null ? '-' : json["marketer"],
        qty: json["qty"] == null ? '0' : json["qty"].toString(),
        ftbl: json["ftbl"] == null ? '0' : json["ftbl"].toString(),
        cblTp: json["cbl_tp"] == null ? '0' : json["cbl_tp"].toString(),
        cblTtid: json["cbl_ttid"] == null ? '0' : json["cbl_ttid"].toString(),
        cblTdt: json["cbl_tdt"] == null ? '0' : json["cbl_tdt"].toString(),
        caisse: json["cp"] == null ? '0' : json["cp"].toString(),
        bilan: json["bilan"] == null ? '' : json["bilan"],
        bls:
            json["bls"] == null
                ? []
                : List<StartBls>.from(
                  json["bls"].map((x) => StartBls.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "marketer": marketer,
    "qty": qty,
    "ftbl": ftbl,
    "cbl_tp": cblTp,
    "cbl_ttid": cblTtid,
    "cbl_tdt": cblTdt,
    "caisse": caisse,
    "bilan": bilan,
    "bls": bls == null ? [] : List<StartBls>.from(bls.map((x) => x.toJson())),
  };
}
