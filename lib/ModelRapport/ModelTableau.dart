import 'package:sygeq/Statistiques/StartPerProduit.dart';

class ModelTableauRapport {
  ModelTableauRapport(
    this.marketer,
    this.numBl,
    this.date,
    this.ftbl,
    this.cbl_tp,
    this.cbl_ttid,
    this.cbl_tdt,
    this.qty,
    this.date_chargement,
    this.date_dechargement,
    this.ville,
    this.distance,
    this.tarif,
    this.station,
    this.dif,
    this.produit,
  );
  final String marketer;
  final String numBl;
  final String date;
  final int ftbl;
  final int cbl_tp;
  final int cbl_ttid;
  final int cbl_tdt;
  final int qty;
  final String date_chargement;
  final String date_dechargement;
  final String ville;
  final String distance;
  final String tarif;
  final String station;
  final int dif;
  final List<SartProduit> produit;
}

class TotalRapportMarketer {
  TotalRapportMarketer(
    this.marketer,
    this.qty,
    this.ftbl,
    this.cbl_tp,
    this.cbl_ttid,
    this.cbl_tdt,
    this.bilan,
    this.caisse,
  );
  final String marketer;
  String qty;
  String ftbl;
  String cbl_tp;
  String cbl_ttid;
  String cbl_tdt;
  String caisse;
  final String bilan;
}

class ModelQtteAvantApres {
  ModelQtteAvantApres(this.productId, this.qteAvant, this.qteApres);
  String productId;
  String qteAvant;
  String qteApres;
}
