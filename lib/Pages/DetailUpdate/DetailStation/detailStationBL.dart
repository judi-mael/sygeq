// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/StationBL.dart';
import 'package:sygeq/Pages/Station/StartDechargement.dart';
import 'package:sygeq/main.dart';

class DetailStationBL extends StatefulWidget {
  var data;
  Depot depot;
  Marketer marketer;
  Camion camion;
  StationBl station;
  Driver driver;
  List<DetailLivraison> listDetailLivraison = [];
  DetailStationBL({
    super.key,
    required this.data,
    required this.listDetailLivraison,
    required this.camion,
    required this.depot,
    required this.driver,
    required this.marketer,
    required this.station,
  });

  @override
  State<DetailStationBL> createState() => _DetailStationBLState();
}

class _DetailStationBLState extends State<DetailStationBL> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          "Numero BL : ",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: styleG,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          "${widget.data['numBL']}",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // style: styleG,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          "Marketer : ",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: styleG,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          widget.marketer.nom,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // style: styleG,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          "Dépôt : ",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: styleG,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          widget.depot.nom,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // style: styleG,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          "Station : ",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: styleG,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          widget.station.nom,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // style: styleG,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Détails du Bl",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Column(
                  children: [
                    for (int i = 0; widget.listDetailLivraison.length > i; i++)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "${i + 1} - ${widget.listDetailLivraison[i].produit.nom} ",
                                  softWrap: true,
                                  maxLines: 2,
                                  // style: styleG,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "quantités   ${widget.listDetailLivraison[i].qtte}",
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.data['statut'] == 'Chargé')
                ElevatedButton(
                  onPressed: () {
                    _getCurrentPosition();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    backgroundColor: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Démarrer le déchargement",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(fontSize: 15, color: white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      serviceEnabled = await Geolocator.openAppSettings();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            content: Text(
              "Les services de localisation sont nécessaires pour utiliser cette fonctionnalité.",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        );
      }
    }
    if (!mounted) return null;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // LocationPermission asked = await Geolocator.requestPermission();
    } else if (serviceEnabled == true &&
        (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse)) {
      Position currentPosotion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        localisation = "$currentPosotion";
        positionLat = currentPosotion.latitude;
        positionLog = currentPosotion.longitude;
      });
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => StartDechargement(
                camion_id: widget.camion.id,
                bl_id: widget.data['id'],
              ),
        ),
      );
    }
  }
}
