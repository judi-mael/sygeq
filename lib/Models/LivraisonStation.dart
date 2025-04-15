// To parse this JSON data, do
//
//     final livraisonStation = livraisonStationFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

import 'dart:convert';

import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/StationBL.dart';

LivraisonStation livraisonStationFromJson(String str) =>
    LivraisonStation.fromJson(json.decode(str));

String livraisonStationToJson(LivraisonStation data) =>
    json.encode(data.toJson());

class LivraisonStation {
  LivraisonStation({
    required this.id,
    required this.numeroBl,
    required this.date,
    required this.station,
    required this.marketer,
    required this.transporteur,
    required this.camion,
    required this.depot,
    required this.details,
    required this.statut,
    required this.commentaire,
    // required this.etat,
    // required this.createdBy,
    // required this.updatedBy,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.deletedAt,
  });

  int id;
  String numeroBl;
  DateTime date;
  StationBl station;
  Marketer marketer;
  Driver transporteur;
  Camion camion;
  Depot depot;
  List<DetailLivraison> details;
  String statut;
  String commentaire;
  // int etat;
  // AtedBy createdBy;
  // AtedBy updatedBy;
  // DateTime createdAt;
  // DateTime updatedAt;
  // dynamic deletedAt;

  factory LivraisonStation.fromJson(Map<String, dynamic> json) =>
      LivraisonStation(
        id: json["id"] ?? 0,
        numeroBl: json["numeroBL"] ?? '',
        date: DateTime.parse(json["date"]),
        station: StationBl.fromJson(json["station"]),
        marketer: Marketer.fromJson(json["marketer"]),
        transporteur: Driver.fromJson(json["transporteur"]),
        camion: Camion.fromJson(json["camion"]),
        depot: Depot.fromJson(json["depot"]),
        details: List<DetailLivraison>.from(
          json["produits"].map((x) => DetailLivraison.fromJson(x)),
        ),
        statut: json["statut"] ?? '',
        commentaire: json["commentaire"] ?? '',
        // etat: json["etat"],
        // createdBy: AtedBy.fromJson(json["created_by"]),
        // updatedBy: AtedBy.fromJson(json["updated_by"]),
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
        // deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "numeroBL": numeroBl,
    "date": date.toIso8601String(),
    "station": station.toJson(),
    "marketer": marketer.toJson(),
    "transporteur": transporteur.toJson(),
    "camion": camion.toJson(),
    "depot": depot.toJson(),
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
    "statut": statut,
    "commentaire": commentaire,
    // "etat": etat,
    // "created_by": createdBy.toJson(),
    // "updated_by": updatedBy.toJson(),
    // "createdAt": createdAt.toIso8601String(),
    // "updatedAt": updatedAt.toIso8601String(),
    // "deletedAt": deletedAt,
  };
}

class AtedBy {
  AtedBy({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.emailVerifiedAt,
    required this.type,
    required this.role,
    required this.adresse,
    required this.marketerId,
    required this.depotId,
    required this.transporteurId,
    required this.stationId,
    required this.rememberToken,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int id;
  String name;
  String username;
  String email;
  dynamic emailVerifiedAt;
  String type;
  String role;
  Adresse adresse;
  int marketerId;
  int depotId;
  dynamic transporteurId;
  dynamic stationId;
  dynamic rememberToken;
  int createdBy;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory AtedBy.fromJson(Map<String, dynamic> json) => AtedBy(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    type: json["type"],
    role: json["role"],
    adresse: Adresse.fromJson(json["adresse"]),
    marketerId: json["marketer_id"] == null ? null : json["marketer_id"],
    depotId: json["depot_id"] == null ? null : json["depot_id"],
    transporteurId: json["transporteur_id"],
    stationId: json["station_id"],
    rememberToken: json["remember_token"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "type": type,
    "role": role,
    "adresse": adresse.toJson(),
    "marketer_id": marketerId == null ? null : marketerId,
    "depot_id": depotId == null ? null : depotId,
    "transporteur_id": transporteurId,
    "station_id": stationId,
    "remember_token": rememberToken,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

class Adresse {
  Adresse({
    required this.id,
    required this.departement,
    required this.commune,
    required this.ville,
    required this.arrondissement,
    required this.quartier,
    required this.rue,
    required this.ilot,
    required this.indication,
    required this.parcelle,
    required this.proprietaire,
    required this.boitePostale,
    required this.telephone,
    required this.email,
    required this.type,
    required this.relatedId,
    required this.etat,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int id;
  String departement;
  String commune;
  String ville;
  String arrondissement;
  String quartier;
  String rue;
  String ilot;
  String indication;
  String parcelle;
  String proprietaire;
  String boitePostale;
  String telephone;
  String email;
  String type;
  int relatedId;
  int etat;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Adresse.fromJson(Map<String, dynamic> json) => Adresse(
    id: json["id"],
    departement: json["departement"],
    commune: json["commune"],
    ville: json["ville"],
    arrondissement: json["arrondissement"],
    quartier: json["quartier"],
    rue: json["rue"],
    ilot: json["ilot"],
    indication: json["indication"],
    parcelle: json["parcelle"],
    proprietaire: json["proprietaire"],
    boitePostale: json["boite_postale"],
    telephone: json["telephone"],
    email: json["email"],
    type: json["type"],
    relatedId: json["related_id"],
    etat: json["etat"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "departement": departement,
    "commune": commune,
    "ville": ville,
    "arrondissement": arrondissement,
    "quartier": quartier,
    "rue": rue,
    "ilot": ilot,
    "indication": indication,
    "parcelle": parcelle,
    "proprietaire": proprietaire,
    "boite_postale": boitePostale,
    "telephone": telephone,
    "email": email,
    "type": type,
    "related_id": relatedId,
    "etat": etat,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

class Detail {
  Detail({
    required this.id,
    required this.bonlivraisonId,
    required this.produit,
    required this.qtte,
    required this.detailsBarcodes,
    required this.etat,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int id;
  String bonlivraisonId;
  Produit produit;
  int qtte;
  List<DetailsBarcode> detailsBarcodes;
  int etat;
  AtedBy createdBy;
  AtedBy updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    bonlivraisonId: json["bonlivraison_id"],
    produit: Produit.fromJson(json["produit"]),
    qtte: json["qtte"],
    detailsBarcodes: List<DetailsBarcode>.from(
      json["details_barcodes"].map((x) => DetailsBarcode.fromJson(x)),
    ),
    etat: json["etat"],
    createdBy: AtedBy.fromJson(json["created_by"]),
    updatedBy: AtedBy.fromJson(json["updated_by"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bonlivraison_id": bonlivraisonId,
    "produit": produit.toJson(),
    "qtte": qtte,
    "details_barcodes": List<dynamic>.from(
      detailsBarcodes.map((x) => x.toJson()),
    ),
    "etat": etat,
    "created_by": createdBy.toJson(),
    "updated_by": updatedBy.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

class DetailsBarcode {
  DetailsBarcode({
    required this.id,
    required this.detailslivraisonId,
    required this.qty,
    required this.barcode,
    required this.compartimentId,
    required this.etat,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int id;
  int detailslivraisonId;
  int qty;
  String barcode;
  int compartimentId;
  int etat;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory DetailsBarcode.fromJson(Map<String, dynamic> json) => DetailsBarcode(
    id: json["id"],
    detailslivraisonId: json["detailslivraison_id"],
    qty: json["qty"],
    barcode: json["barcode"],
    compartimentId: json["compartiment_id"],
    etat: json["etat"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "detailslivraison_id": detailslivraisonId,
    "qty": qty,
    "barcode": barcode,
    "compartiment_id": compartimentId,
    "etat": etat,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}

class Produit {
  Produit({
    required this.id,
    required this.nom,
    required this.hscode,
    required this.type,
    required this.etat,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int id;
  String nom;
  String hscode;
  String type;
  int etat;
  int createdBy;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Produit.fromJson(Map<String, dynamic> json) => Produit(
    id: json["id"],
    nom: json["nom"],
    hscode: json["hscode"],
    type: json["type"],
    etat: json["etat"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "hscode": hscode,
    "type": type,
    "etat": etat,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}
