// To parse this JSON data, do
//
//     final startBls = startBlsFromJson(jsonString);

// ignore_for_file: equal_keys_in_map

import 'dart:convert';

// import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/ModelRapport/DetailLivraisonRapport.dart';
import 'package:sygeq/ModelRapport/StationPerequation.dart';

StartBls startBlsFromJson(String str) => StartBls.fromJson(json.decode(str));

String startBlsToJson(StartBls data) => json.encode(data.toJson());

class StartBls {
  int? id;
  String? numeroBl;
  String? date;
  StationP? station;
  int? marketerId;
  int? transporteurId;
  int? camionId;
  int? depotId;
  String? statut;
  String? date_chargement;
  String? date_dechargement;
  String? commentaire;
  int? statMonth;
  int? statYear;
  int ftbl;
  int cblTp;
  int cblTtid;
  int cblTdt;
  int qty;
  List<DetailsLivraisonsRapport> detailsLivraisonsRappot;
  // int? createdBy;
  // int? updatedBy;
  // dynamic deletedBy;
  // dynamic restoredBy;
  // dynamic suspensionComment;
  String? createdAt;
  // DateTime? updatedAt;
  // dynamic deletedAt;

  StartBls({
    this.id,
    this.numeroBl,
    this.date,
    this.station,
    this.marketerId,
    this.transporteurId,
    this.camionId,
    this.depotId,
    required this.detailsLivraisonsRappot,
    this.statut,
    this.date_chargement,
    this.date_dechargement,
    this.commentaire,
    this.statMonth,
    this.statYear,
    required this.ftbl,
    required this.cblTp,
    required this.cblTtid,
    required this.cblTdt,
    required this.qty,
    // this.createdBy,
    // this.updatedBy,
    // this.deletedBy,
    // this.restoredBy,
    // this.suspensionComment,
    this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
  });

  factory StartBls.fromJson(Map<String, dynamic> json) => StartBls(
    id: json["id"],
    numeroBl: json["numeroBL"],
    date: json["date"] == null ? null : json["date"],
    station: StationP.fromJson(json["Station"]),
    marketerId: json["marketer_id"],
    transporteurId: json["transporteur_id"],
    camionId: json["camion_id"],
    depotId: json["depot_id"],
    detailsLivraisonsRappot:
        json["DetailsLivraisons"] == null
            ? []
            : List<DetailsLivraisonsRapport>.from(
              json["DetailsLivraisons"].map(
                (e) => DetailsLivraisonsRapport.fromJson(e),
              ),
            ),
    statut: json["statut"],
    date_chargement:
        json["date_chargement"] == null ? '' : json["date_chargement"],
    date_dechargement:
        json["date_dechargement"] == null ? '' : json["date_dechargement"],
    commentaire: json["commentaire"] == null ? '' : json["commentaire"],
    statMonth: json["statMonth"],
    statYear: json["statYear"],
    ftbl: json["ftbl"] == null ? 0 : json["ftbl"],
    cblTp: json["cbl_tp"] ?? 0,
    cblTtid: json["cbl_ttid"] ?? 0,
    cblTdt: json["cbl_tdt"] ?? 0,
    qty: json["qty"] ?? 0,
    // createdBy: json["createdBy"],
    // updatedBy: json["updatedBy"],
    // deletedBy: json["deletedBy"],
    // restoredBy: json["restoredBy"],
    // suspensionComment: json["suspensionComment"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    // updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    // deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "numeroBL": numeroBl,
    "date": date,
    "station_id": station,
    "marketer_id": marketerId,
    "transporteur_id": transporteurId,
    "camion_id": camionId,
    "depot_id": depotId,
    "statut": statut,
    "detailLivraisonRapport": List<dynamic>.from(
      detailsLivraisonsRappot.map((x) => x.toJson()),
    ),
    "date_dechargement": date_dechargement,
    "date_dechargement": statut,
    "commentaire": date_dechargement,
    "statMonth": statMonth,
    "statYear": statYear,
    "ftbl": ftbl,
    "cbl_tp": cblTp,
    "cbl_ttid": cblTtid,
    "cbl_tdt": cblTdt,
    "qty": qty,
    // "createdBy": createdBy,
    // "updatedBy": updatedBy,
    // "deletedBy": deletedBy,
    // "restoredBy": restoredBy,
    // "suspensionComment": suspensionComment,
    "createdAt": createdAt,
    // "updatedAt": updatedAt?.toIso8601String(),
    // "deletedAt": deletedAt,
  };
}
