// To parse this JSON data, do
//
//     final bonGplBouteille = bonGplBouteilleFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/StationBL.dart';

BonGplBouteille bonGplBouteilleFromJson(String str) =>
    BonGplBouteille.fromJson(json.decode(str));

String bonGplBouteilleToJson(BonGplBouteille data) =>
    json.encode(data.toJson());

class BonGplBouteille {
  BonGplBouteille({
    required this.id,
    required this.numeroBl,
    required this.date,
    required this.statut,
    required this.statYear,
    required this.statMonth,
    required this.commentaire,
    required this.ftbl,
    required this.cp,
    required this.station,
    required this.marketer,
    required this.camion,
    required this.depot,
    required this.produits,
    required this.cblTp,
    required this.cblTtid,
    required this.cblTdt,
    required this.suspensionComment,
  });

  int id;
  String numeroBl;
  String date;
  String statut;
  int statYear;
  int statMonth;
  String commentaire;
  dynamic ftbl;
  int cp;
  StationBl station;
  Marketer marketer;
  Camion camion;
  Depot depot;
  List<DetailLivraison> produits;
  dynamic cblTp;
  dynamic cblTtid;
  dynamic cblTdt;

  dynamic suspensionComment;

  factory BonGplBouteille.fromJson(Map<String, dynamic> json) =>
      BonGplBouteille(
        id: json["id"] ?? 0,
        numeroBl: json["numeroBL"] ?? "",
        date: json["date"],
        statut: json["statut"],
        statYear: json["statYear"],
        statMonth: json["statMonth"],
        commentaire: json["commentaire"],
        station:
            json["station"] == null
                ? StationBl(
                  nom: 'Destination inconnue',
                  id: 0,
                  adresse: '',
                  villeId: 1,
                  ifu: '',
                  marketerId: 0,
                  poiId: '',
                  rccm: '',
                  latitude: '',
                  longitude: '',
                  etat: 0,
                )
                : StationBl.fromJson(json["station"]),
        marketer: Marketer.fromJson(json["marketer"]),
        camion: Camion.fromJson(json["camion"]),
        depot:
            json["depot"] == null
                ? Depot(
                  id: 0,
                  numDepotDouanier: '0',
                  agrement: "0",
                  ifu: "0",
                  dateVigueur: '01/01/2023',
                  dateExpiration: '01/01/2023',
                  nom: 'DPB',
                  adresse: '',
                  type: '',
                  etat: 1,
                  deletedAt: '',
                )
                : Depot.fromJson(json["depot"]),
        produits: List<DetailLivraison>.from(
          json["produits"].map((e) => DetailLivraison.fromJson(e)),
        ),
        ftbl: json["ftbl"],
        cp: json["cp"],
        cblTp: json["cbl_tp"],
        cblTtid: json["cbl_ttid"],
        cblTdt: json["cbl_tdt"],
        suspensionComment: json["suspensionComment"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "numeroBL": numeroBl,
    "date": date,
    "camion": camion.toJson(),
    "depot": depot.toJson(),
    "produits": List<dynamic>.from(produits.map((e) => e.toJson())),
    "station": station.toJson(),
    "marketer": marketer.toJson(),
    "statut": statut,
    "statYear": statYear,
    "statMonth": statMonth,
    "commentaire": commentaire,
    "ftbl": ftbl,
    "cp": cp,
    "cbl_tp": cblTp,
    "cbl_ttid": cblTtid,
    "cbl_tdt": cblTdt,
    "suspensionComment": suspensionComment,
  };
}
