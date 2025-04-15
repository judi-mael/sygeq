// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, use_build_context_synchronously, await_only_futures, unused_local_variable, prefer_final_fields, unused_field, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong_to_osgrid/latlong_to_osgrid.dart';
import 'package:sygeq/Models/CamioPosition.dart';
import 'package:sygeq/Pages/Depot/DepotComfirmBT.dart';
import 'package:sygeq/Pages/Depot/HomeDepot.dart';
import 'package:sygeq/Pages/Station/HomeStation.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/Services/SationRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class DepotScannerQR extends StatefulWidget {
  int id = 0;
  int id_bl = 0;
  String type = '';
  DepotScannerQR({
    Key? key,
    required this.id,
    required this.id_bl,
    required this.type,
  }) : super(key: key);

  @override
  State<DepotScannerQR> createState() => _DepotScannerQRState();
}

class _DepotScannerQRState extends State<DepotScannerQR> {
  int _counter = 5;

  late Timer _timer;
  List<CamionPosition>? listVehiculposition = [];
  Barcode? result;
  QRViewController? controller;
  bool animate = false;
  double comparaison = 3.0;
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

  // getLeBT() async {
  //   var data = await RemoteStationService.depotGetBL(code: id_bl);
  //   setState(() {
  //     resultd = json.decode(data['data'].toString());
  //     _detailBL = resultd['data'];
  //   });
  // }

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

  getOneDepot() async {
    var data = await RemoteDepotService.allOneDepot(
      depotId: prefUserInfo['depotId'].toString(),
    );
    setState(() {
      listOneDepot = data;
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

  vehiculePosition() async {
    var data = await RemoteStationService.depotGetVehiculPosition(
      camion: widget.id,
      type: widget.type,
    );
    // var data = await RemoteStationService.staionGetVehiculPosition(camion: id);
    // if (!mounted) return null;
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
    // return data;
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
    var data = await RemoteStationService.depotGetBL(code: widget.id_bl);
    var result = json.decode(data['data'].toString());
    var _detailBL = result['data'];

    await Future.delayed(Duration(seconds: 5));
    setState(() {
      animate = false;
    });
    if (result['data']['station']['id'] == prefUserInfo['depotId']) {
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
                ((context) =>
                    DepotConfirmBT(bl: widget.id_bl, data: _detailBL)),
          ),
        );
      }
    } else {
      erroDestination("Ce BL est pour : ${result['data']['station']['nom']}");
    }
  }

  recapFunctionFalsecommunication() async {
    setState(() {
      animate = true;
    });
    var data = await RemoteStationService.depotGetBL(code: widget.id_bl);
    var result = json.decode(data['data'].toString());
    var _detailBL = result['data'];

    await Future.delayed(Duration(seconds: 5));
    setState(() {
      animate = false;
    });
    if (result['data']['station']['id'] == prefUserInfo['depotId']) {
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
            builder:
                ((context) =>
                    DepotConfirmBT(bl: widget.id_bl, data: _detailBL)),
          ),
        );
      }
    } else if (result['data']['station']['id'] != prefUserInfo['depotId']) {
      erroDestination("Ce BL est pour : ${result['data']['station']['nom']}");
    } else {
      erroDestination("Une erreur c'est produite veuillez réessayer");
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    if (listOneDepot != {}) {
      getStationPosition(
        double.parse(listOneDepot['latitude']),
        double.parse(listOneDepot['longitude']),
      );
    } else {
      getOneDepot();
      getStationPosition(
        double.parse(listOneDepot['latitude']),
        double.parse(listOneDepot['longitude']),
      );
    }
    getUserPosition(positionLat!, positionLog!);
    vehiculePosition();
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
              : Container(child: veuillezPatienter("Waiting...")),
    );
  }

  // Widget _buildQrView(BuildContext context) {
  //   // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
  //   var scanArea = (MediaQuery.of(context).size.width < 400 ||
  //           MediaQuery.of(context).size.height < 400)
  //       ? 150.0
  //       : 300.0;
  //   // To ensure the Scanner view is properly sizes after rotation
  //   // we need to listen for Flutter SizeChanged notification and update controller
  //   return QRView(
  //     key: qrKey,
  //     onQRViewCreated: _onQRViewCreated,
  //     overlay: QrScannerOverlayShape(
  //         borderColor: blue,
  //         overlayColor: Color.fromARGB(255, 52, 75, 52),
  //         borderRadius: 0,
  //         borderLength: 30,
  //         borderWidth: 10,
  //         cutOutSize: scanArea),
  //     onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
  //   );
  // }

  // void _onQRViewCreated(QRViewController controller) async {
  //   // setState(() {
  //   this.controller = controller;
  //   // });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() async {
  //       result = scanData;
  //       controller.dispose();

  //       if (result!.code!.isNotEmpty &&
  //           positionLat.toString().isNotEmpty &&
  //           positionLog.toString().isNotEmpty) {
  //         setState(() {
  //           //id du camion
  //           id = int.parse(result!.code!.toString().split('/')[1]);
  //           //id du bl
  //           id_bl = int.parse(result!.code!.toString().split('/')[0]);
  //         });
  //         getLeBT();
  //         vehiculePosition();
  //         // recapFunction();
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Vérifier les autorisations et réessayer ')),
  //         );
  //       }
  //     });
  //   });
  // }

  // void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
  //   // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
  //   if (!p) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Vérifier les autorisations et réessayer')),
  //     );
  //   }
  // }
}
