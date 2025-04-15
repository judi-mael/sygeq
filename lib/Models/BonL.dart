// To parse this JSON data, do
//
//     final bonL = bonLFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/StationBL.dart';

BonL bonLFromJson(String str) => BonL.fromJson(json.decode(str));

String bonLToJson(BonL data) => json.encode(data.toJson());

class BonL {
  BonL({
    required this.id,
    required this.numeroBl,
    required this.date,
    required this.info,
    required this.station,
    required this.marketer,
    required this.transporteur,
    required this.camion,
    required this.depot,
    required this.produits,
    required this.statut,
    required this.qty,
    required this.commentaire,
    // required this.etat,
  });

  int id;
  String numeroBl;
  String date;
  String info;
  StationBl station;
  Marketer marketer;
  Driver transporteur;
  Camion camion;
  Depot depot;
  List<DetailLivraison> produits;
  String statut;
  int qty;
  String commentaire;
  // int etat;

  factory BonL.fromJson(Map<String, dynamic> json) => BonL(
    id: json["id"] ?? 0,
    numeroBl: json["numeroBL"] ?? "",
    date: json["date"] ?? "",
    info: json["info"] ?? "",
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
    transporteur: Driver.fromJson(json["transporteur"]),
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
    statut: json["statut"] ?? "",
    qty: json["qty"] ?? 0,
    commentaire: json["commentaire"] ?? "",
    // etat: json["etat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "numeroBL": numeroBl,
    "date": date,
    "info": info,
    "station": station.toJson(),
    "marketer": marketer.toJson(),
    "transporteur": transporteur.toJson(),
    "camion": camion.toJson(),
    "depot": depot.toJson(),
    "produits": List<dynamic>.from(produits.map((e) => e.toJson())),
    "statut": statut,
    "qty": qty,
    "commentaire": commentaire,
    // "etat": etat,
  };
}
