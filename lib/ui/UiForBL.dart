// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/BonGPLBouteille.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/BonT.dart';
import 'package:sygeq/main.dart';

cardStationorB2bBL(BonL bonLivraison) {
  // Size size = MediaQuery.of(context).size;
  return Card(
    child: Padding(
      padding: EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset('assets/icons/bc.png', scale: 3),
          ),
          Flexible(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonLivraison.numeroBl,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(color: blue),
                  maxLines: 2,
                ),
                Text(
                  bonLivraison.camion.imat,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: styleG,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      // flex: 2,
                      child: Wrap(
                        children: [
                          for (
                            int i = 0;
                            bonLivraison.produits.length > i;
                            i++
                          ) ...[
                            Text(
                              bonLivraison.produits[i].produit.nom,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              maxLines: 2,
                              textScaleFactor: 0.7,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              bonLivraison.statut == "Approuvé"
                  ? "Relâché"
                  : bonLivraison.statut,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 0.7,
              maxLines: 1,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color:
                    bonLivraison.statut == "Approuvé"
                        ? green
                        : bonLivraison.statut == 'Chargé'
                        ? green
                        : bonLivraison.statut == 'Déchargé'
                        ? Colors.blueGrey
                        : bonLivraison.statut == "Rejeté"
                        ? red
                        : bonLivraison.statut == "Bon à Charger"
                        ? blue
                        : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

cardDepotBT(BonT bonLivraison) {
  // Size size = MediaQuery.of(context).size;
  return Card(
    child: Padding(
      padding: EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset('assets/icons/bc.png', scale: 3),
          ),
          Flexible(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonLivraison.numeroBl,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(color: blue),
                  maxLines: 2,
                ),
                Text(
                  bonLivraison.camion.imat,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: styleG,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      // flex: 2,
                      child: Wrap(
                        children: [
                          for (
                            int i = 0;
                            bonLivraison.produits.length > i;
                            i++
                          ) ...[
                            Text(
                              bonLivraison.produits[i].produit.nom,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              maxLines: 2,
                              textScaleFactor: 0.7,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              bonLivraison.statut == "Approuvé"
                  ? "Relâché"
                  : bonLivraison.statut,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 0.7,
              maxLines: 1,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color:
                    bonLivraison.statut == "Approuvé"
                        ? green
                        : bonLivraison.statut == 'Chargé'
                        ? green
                        : bonLivraison.statut == 'Déchargé'
                        ? Colors.blueGrey
                        : bonLivraison.statut == "Rejeté"
                        ? red
                        : bonLivraison.statut == "Bon à Charger"
                        ? blue
                        : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

cardMarketerBL(BonL bonLivraison) {
  return Card(
    child: Padding(
      padding: EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset(
              'assets/icons/bc.png',
              // color: Colors.blue,
            ),
          ),
          Flexible(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonLivraison.numeroBl,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: blue,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                Text(
                  bonLivraison.station.nom,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: styleG,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Icon(
                              Icons.airport_shuttle_outlined,
                              size: 15,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            flex: 5,
                            child: Text(
                              bonLivraison.camion.imat,
                              textScaleFactor: 0.7,
                              softWrap: true,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 15, width: 2, color: blue),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Icon(
                              Icons.local_gas_station,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            flex: 5,
                            child: Text(
                              bonLivraison.depot.nom,
                              textScaleFactor: 0.7,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Text(
              bonLivraison.statut == "Approuvé"
                  ? "Relâcher"
                  : bonLivraison.statut,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 0.7,
              maxLines: 2,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color:
                    bonLivraison.statut == "Approuvé"
                        ? green
                        : bonLivraison.statut == 'Chargé'
                        ? green
                        : bonLivraison.statut == 'Déchargé'
                        ? Colors.blueGrey
                        : bonLivraison.statut == "Rejeté"
                        ? red
                        : bonLivraison.statut == "Bon à Charger"
                        ? Colors.orange
                        : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

cardMarketerGPL(BonGplBouteille bonLivraison) {
  return Card(
    child: Padding(
      padding: EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset(
              'assets/icons/bc.png',
              // color: Colors.blue,
            ),
          ),
          Flexible(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonLivraison.numeroBl,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: blue,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                Text(
                  bonLivraison.station.nom,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: styleG,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Icon(
                              Icons.airport_shuttle_outlined,
                              size: 15,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            flex: 5,
                            child: Text(
                              bonLivraison.camion.imat,
                              textScaleFactor: 0.7,
                              softWrap: true,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 15, width: 2, color: blue),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Icon(
                              Icons.local_gas_station,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            flex: 5,
                            child: Text(
                              bonLivraison.depot.nom,
                              textScaleFactor: 0.7,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Text(
              bonLivraison.statut == "Approuvé"
                  ? "Relâcher"
                  : bonLivraison.statut,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 0.7,
              maxLines: 2,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color:
                    bonLivraison.statut == "Approuvé"
                        ? green
                        : bonLivraison.statut == 'Chargé'
                        ? green
                        : bonLivraison.statut == 'Déchargé'
                        ? Colors.blueGrey
                        : bonLivraison.statut == "Rejeté"
                        ? red
                        : bonLivraison.statut == "Bon à Charger"
                        ? Colors.orange
                        : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

cardMarketerBT(BonT bonTransfere) {
  return Card(
    child: Padding(
      padding: EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset(
              'assets/icons/bc.png',
              // color: Colors.blue,
            ),
          ),
          Flexible(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonTransfere.numeroBl,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: blue,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                Text(
                  bonTransfere.destination.nom,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: styleG,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Icon(
                              Icons.airport_shuttle_outlined,
                              size: 15,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            flex: 5,
                            child: Text(
                              bonTransfere.camion.imat,
                              textScaleFactor: 0.7,
                              softWrap: true,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 15, width: 2, color: blue),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Icon(
                              Icons.local_gas_station,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            flex: 5,
                            child: Text(
                              bonTransfere.depot.nom,
                              textScaleFactor: 0.7,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(color: Colors.blue),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Text(
              bonTransfere.statut == "Approuvé"
                  ? "Relâcher"
                  : bonTransfere.statut,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 0.7,
              maxLines: 2,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color:
                    bonTransfere.statut == "Approuvé"
                        ? green
                        : bonTransfere.statut == 'Chargé'
                        ? green
                        : bonTransfere.statut == 'Déchargé'
                        ? Colors.blueGrey
                        : bonTransfere.statut == "Rejeté"
                        ? red
                        : bonTransfere.statut == "Bon à Charger"
                        ? blue
                        : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
