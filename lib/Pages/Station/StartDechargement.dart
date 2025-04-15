// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, use_build_context_synchronously, await_only_futures, unused_local_variable, prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong_to_osgrid/latlong_to_osgrid.dart';
import 'package:sygeq/Models/CamioPosition.dart';
import 'package:sygeq/Pages/Station/ComfirmBL.dart';
import 'package:sygeq/Pages/Station/HomeStation.dart';
import 'package:sygeq/Services/SationRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class StartDechargement extends StatefulWidget {
  final int camion_id, bl_id;
  StartDechargement({Key? key, required this.camion_id, required this.bl_id})
    : super(key: key);

  @override
  State<StartDechargement> createState() => _StartDechargementState();
}

class _StartDechargementState extends State<StartDechargement> {
  int _counter = 5;
  List<CamionPosition>? listVehiculposition = [];
  bool animate = false;
  double comparaison = 1.5;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  LatLongConverter converter = LatLongConverter();
  void _getCurrentPosition() async {
    //Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _getCurrentPosition();
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position currentPosotion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        positionLat = currentPosotion.latitude;
        positionLog = currentPosotion.longitude;
      });
    }
  }

  void getStationPosition(double lat, double long) async {
    OSRef result = await converter.getOSGBfromDec(lat, long);
    var latDms = await converter.getDegreeFromDecimal(lat);
    var longDms = await converter.getDegreeFromDecimal(long);
    setState(() {
      potStationLat = "${latDms[0].toString()}${latDms[1].toString()}";
      potStationLong = "${longDms[0].toString()}${longDms[1].toString()}";
      posStationCompLat = latDms[2];
      posStationCompLong = longDms[2];
    });
  }

  void getUserPosition(double lat, double long) async {
    OSRef result = await converter.getOSGBfromDec(lat, long);
    var latDms = await converter.getDegreeFromDecimal(lat);
    var longDms = await converter.getDegreeFromDecimal(long);
    setState(() {
      potUserLat = "${latDms[0].toString()}${latDms[1].toString()}";
      potUserLong = "${longDms[0].toString()}${longDms[1].toString()}";
      posUserCompLat = latDms[2];
      posUserCompLong = longDms[2];
    });
  }

  getOneStation() async {
    var data = await RemoteStationService.allOneStation(
      stationId: prefUserInfo['stationId'].toString(),
    );
    setState(() {
      listOneStation = data;
    });
    return data;
  }

  erroDestination(String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Container(
            child: Column(
              children: [
                Icon(Icons.dangerous, color: red, size: 30),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    message,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: styleG,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: blue),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => super.widget,
                  ),
                );
              },
              child: Text(
                "Réessayer",
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styleG,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: gry),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "Annuler",
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styleG,
              ),
            ),
          ],
        );
      },
    );
  }

  recapFunction() async {
    setState(() {
      animate = true;
    });
    var data = await RemoteStationService.stationGetBL(code: widget.bl_id);
    try {
      var result = json.decode(data['data'].toString());
      var _detailBL = result['data'];
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        animate = false;
      });
      if (result['data']['station']['id'] == prefUserInfo['stationId']) {
        if (potUserLat != potStationLat ||
            potUserLong != potStationLong ||
            (posStationCompLat - posUserCompLat).abs() > comparaison ||
            (posStationCompLong - posUserCompLong).abs() > comparaison ||
            (posStationCompLat - posCamionCompLat).abs() > comparaison ||
            potCamionLat != potStationLat ||
            potCamionLong != potStationLong ||
            (posStationCompLong - posCamionCompLong).abs() > comparaison) {
          erroDestination(
            "L'utilisateur ou le camion n'est pas à la bonne adresse",
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  ((context) => ConfirmBL(bl: widget.bl_id, data: _detailBL)),
            ),
          );
        }
      } else if (result['data']['station']['id'] == "0" ||
          result['data']['station']['id'] == null ||
          result['data']['station']['id'] == "") {
        erroDestination(
          "La destination n'est pas attribuée. Contactez la société pétrolière",
        );
      } else if (result['data']['station']['id'] != prefUserInfo['stationId']) {
        erroDestination(
          "Ce BL est pour la station : ${result['data']['station']['nom']}",
        );
      } else {
        erroDestination("Une erreur c'est produite veuillez réessayer");
      }
    } catch (e) {
      erroDestination(
        "La destination n'est pas attribuée. Contactez la société pétrolière",
      );
    }
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void initState() {
    super.initState();
    recapFunction();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        backgroundColor: white,
        title: Text(
          "Vérification",
          style: styleAppBar,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        centerTitle: true,
      ),

      // drawer: Container(
      //   width: _size.width / 2,
      //   color: Colors.red,
      // ),
      body:
          animate == true
              ? Container(child: veuillezPatienter("Veuillez patienter"))
              : Container(child: veuillezPatienter("Waiting...")),
    );
  }
}
