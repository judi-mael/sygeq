// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, use_build_context_synchronously, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong_to_osgrid/latlong_to_osgrid.dart';
import 'package:sygeq/Models/CamioPosition.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Pages/B2B/B2bConfirmBl.dart';
import 'package:sygeq/Services/SationRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class B2BStartDechargement extends StatefulWidget {
  const B2BStartDechargement({Key? key}) : super(key: key);

  @override
  State<B2BStartDechargement> createState() => _B2BStartDechargementState();
}

class _B2BStartDechargementState extends State<B2BStartDechargement> {
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

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
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

  recapFunction() async {
    setState(() {
      animate = true;
    });
    var data = await RemoteStationService.stationGetBL(code: id_bl);
    var result = json.decode(data['data'].toString());
    var _detailBL = result['data'];

    await Future.delayed(Duration(seconds: 5));
    setState(() {
      animate = false;
    });
    if (result['data']['station']['id'] == prefUserInfo['b2bId']) {
      List<DetailLivraison> detailB2B =
          (result['data']['produits'] as List)
              .map((i) => DetailLivraison.fromJson(i))
              .toList();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => B2bConfirmBL(bl: id_bl, detail: detailB2B)),
        ),
      );
    } else {
      erroDestination(
        "Ce BL n'est pas pour votre B2B. Contactez la société pétrolière",
      );
    }
  }

  @override
  void initState() {
    super.initState();
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
        // automaticallyImplyLeading: false,
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
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
                  Expanded(child: Text(""), flex: 2),
                  Expanded(
                    flex: _size.width > _size.height ? 20 : 3,
                    child: Padding(
                      padding:
                          _size.width > _size.height
                              ? EdgeInsets.only(left: 270, right: 270)
                              : EdgeInsets.only(left: 50, right: 50),
                      child:
                          animate == true
                              ? Container(child: animateScannageQrcode())
                              : _buildQrView(context),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: blue,
        overlayColor: Color.fromARGB(255, 52, 75, 52),
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

        // if (result!.code!.isNotEmpty &&
        //     positionLat.toString().isNotEmpty &&
        //     positionLog.toString().isNotEmpty) {
        //   setState(() {
        //     //id du camion
        //     id = int.parse(result!.code!.toString().split('/')[1]);
        //     //id du bl
        //     id_bl = int.parse(result!.code!.toString().split('/')[0]);
        //   });
        //   // vehiculePosition();

        //   recapFunction();
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Vérifier les autorisations et réessayer ')),
        //   );
        // }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('no Permission')));
    }
  }
}
