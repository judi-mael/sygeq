// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, use_build_context_synchronously, await_only_futures, unused_local_variable, prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerQR extends StatefulWidget {
  const ScannerQR({Key? key}) : super(key: key);

  @override
  State<ScannerQR> createState() => _ScannerQRState();
}

class _ScannerQRState extends State<ScannerQR> {
  int _counter = 5;
  int id = 0;
  int id_bl = 0;
  late Timer _timer;
  List<CamionPosition>? listVehiculposition = [];
  Barcode? result;
  QRViewController? controller;
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
        desiredAccuracy: LocationAccuracy.best,
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

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  recapFunctionFalsecommunication() async {
    setState(() {
      animate = true;
    });
    var data = await RemoteStationService.stationGetBL(code: id_bl);
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
            (posStationCompLong - posUserCompLong).abs() > comparaison) {
          erroDestination(
            "Vous n'êtes pas à la Station ${result['data']['station']['nom']}",
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => ConfirmBL(data: _detailBL, bl: id_bl)),
            ),
          );
        }
      } else if (result['data']['station']['id'] != prefUserInfo['stationId']) {
        erroDestination(
          "Ce BL est pour la station : ${result['data']['station']['nom']}",
        );
      } else {
        erroDestination("Une erreur c'est produite veuillez réessayer");
      }
    } catch (e) {
      erroDestination(
        "La destination n'est pas connue. Contactez la société petrolière",
      );
    }
  }

  vehiculePosition() async {
    var data = await RemoteStationService.staionGetVehiculPosition(camion: id);
    setState(() {
      listVehiculposition = data;
    });
    DateTime date = DateTime.parse(listVehiculposition![0].lastUpdateTime);
    DateTime now = DateTime.now();

    Duration difference = now.difference(date);
    if (difference.inMinutes > 30) {
      if (difference.inDays > 14) {
        showToast(
          "Contactez le support SyGeQ pour assistance.",
          
        );
        getVehiclesPosition(
          listVehiculposition![0].position.latitude,
          listVehiculposition![0].position.longitude,
        );
        recapFunction();
      } else {
        recapFunctionFalsecommunication();
      }
    } else {
      getVehiclesPosition(
        listVehiculposition![0].position.latitude,
        listVehiculposition![0].position.longitude,
      );
      recapFunction();
    }
  }

  erroDestination(String error) {
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
                    error,
                    softWrap: true,
                    maxLines: 4,
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

                _timer.cancel();
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

  refresPosition() async {
    Position currentPosotion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    // if (!mounted) return null;
    setState(() {
      positionLat = currentPosotion.latitude;
      positionLog = currentPosotion.longitude;
    });
  }

  void getVehiclesPosition(double lat, double long) async {
    OSRef result = await converter.getOSGBfromDec(lat, long);
    var latDms = await converter.getDegreeFromDecimal(lat);
    var longDms = await converter.getDegreeFromDecimal(long);
    setState(() {
      potCamionLat = "${latDms[0].toString()}${latDms[1].toString()}";
      potCamionLong = "${longDms[0].toString()}${longDms[1].toString()}";
      posCamionCompLat = latDms[2];
      posCamionCompLong = longDms[2];
    });
  }

  recapFunction() async {
    setState(() {
      animate = true;
    });
    var data = await RemoteStationService.stationGetBL(code: id_bl);
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
              builder: ((context) => ConfirmBL(bl: id_bl, data: _detailBL)),
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
  void initState() {
    super.initState();
    _getCurrentPosition();
    if (listOneStation.isNotEmpty) {
      getStationPosition(
        listOneStation[0].latitude,
        listOneStation[0].longitude,
      );
    } else {
      getOneStation();
      getStationPosition(
        listOneStation[0].latitude,
        listOneStation[0].longitude,
      );
    }
    getUserPosition(positionLat!, positionLog!);
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer.cancel();
    super.dispose();
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
          "Scanner code QR",
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
              : Column(
                children: <Widget>[
                  Text(
                    'Scanner le code QR',
                    softWrap: true,
                    maxLines: 1,
                    textScaleFactor: 2,
                    overflow: TextOverflow.ellipsis,
                    // style: TextStyle(fontSize: 10),
                  ),
                  // Expanded(
                  //   child: Text(""),
                  //   flex: 2,
                  // ),
                  Expanded(
                    flex: _size.width > _size.height ? 20 : 3,
                    child: Padding(
                      padding: EdgeInsets.only(),
                      // padding: _size.width > _size.height
                      //     ? EdgeInsets.only(left: 270, right: 270)
                      //     : EdgeInsets.only(left: 50, right: 50),
                      child:
                          animate == true
                              ? Container(child: animateScannageQrcode())
                              : _buildQrView(context),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: blue,
        // overlayColor: Color.fromARGB(255, 52, 75, 52),
        borderRadius: 0,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    // setState(() {
    this.controller = controller;
    // });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.dispose();

        if (result!.code!.isNotEmpty &&
            positionLat.toString().isNotEmpty &&
            positionLog.toString().isNotEmpty) {
          setState(() {
            //id du camion
            id = int.parse(result!.code!.toString().split('/')[1]);
            //id du bl
            id_bl = int.parse(result!.code!.toString().split('/')[0]);
          });
          vehiculePosition();

          // recapFunction();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vérifier les autorisations et réessayer ')),
          );
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vérifier les autorisations et réessayer')),
      );
    }
  }
}
