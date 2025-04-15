import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/main.dart';

class ListBLGPLBouteilleCard extends StatelessWidget {
  final BonL bonBl;
  ListBLGPLBouteilleCard({Key? key, required this.bonBl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bonBl.numeroBl,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color:
                        bonBl.statut == "Approuvé"
                            ? Colors.blue
                            : bonBl.statut == "Bon à Charger"
                            ? Color.fromARGB(212, 26, 100, 66)
                            : bonBl.statut == "Rejeté"
                            ? red
                            : null,
                  ),
                ),
                Text(
                  bonBl.station.nom,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Card(
              elevation: 3,
              color: blue,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Qtés : ${bonBl.qty} Kg',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
