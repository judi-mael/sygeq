// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_types_as_parameter_names, non_constant_identifier_names, unused_field, must_be_immutable, unused_local_variable

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/TotalModel.dart';
import 'package:sygeq/Pages/Depot/DetailBC.dart';
import 'package:sygeq/Pages/Depot/treatment.dart';
import 'package:sygeq/Pages/Depot/updateBLCharge.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:flutter/material.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

List<TotalModel>? total = [];
// List total = [];
List<int> listIdCompartiment = [];

class ValidationBC extends StatefulWidget {
  int car;
  var capacite;
  String imat;
  ValidationBC({
    Key? key,
    required this.car,
    required this.capacite,
    required this.imat,
  }) : super(key: key);

  @override
  State<ValidationBC> createState() => _ValidationBCState();
}

class _ValidationBCState extends State<ValidationBC> {
  List<BonL> nbon = [];
  List<Compartiment> c = [];
  List? listcom = [];
  List? listcap = [];
  List? listcod = [];
  List? listpro = [];
  List? listg = [];
  List ctr_list_detail_bl = [];
  String valu = "";
  int po = 0;
  int qtyTotal = 0;
  String toast_string = " ";
  bool _firstSearch = true;
  bool scaffoldStatut = false;
  String _query = "";
  Widget toast = Container(
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: defautlCardColors,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: green, size: 20),
        SizedBox(width: 12.0),
        Text(
          "BL Chargé avec succès",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
      ],
    ),
  );
  List listElement = [];
  _ValidationBCState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }
  getElement() {
    setState(() {
      listElement.clear();
    });
    for (var list_id in total!) {
      listElement.add(list_id.toString().split(';')[0]);
    }
  }

  Widget erroAddBarreCode = Container(
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: defautlCardColors,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(flex: 1, child: Icon(Icons.error, color: red, size: 20)),
        SizedBox(width: 12.0),
        Flexible(
          flex: 5,
          child: Text(
            "Ce produit a déjà faire l'objet de répartition ",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
            style: GoogleFonts.montserrat(color: red),
          ),
        ),
      ],
    ),
  );
  final _searchview = TextEditingController();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  int id = 0;
  Future<void> startBarcodeScanStream() async {
    // FlutterBarcodeScanner.getBarcodeStreamReceiver(
    //         '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
    //     .listen((barcode) {
    //   setState(() {
    //     valu = barcode.toString();
    //     Navigator.pop(context);
    //   });
    // });
  }

  depAddBC() async {
    var data = await RemoteDepotService.depotCreatBC(total!);
    return data;
  }

  alertBlCharge(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: white,
        // behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.only(bottom: 5),
        duration: Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.all(
          // Radius.circular(20),
          //     ),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, size: 20, color: Colors.red),
              SizedBox(width: 12.0),
              Flexible(
                child: Text(
                  message,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: GoogleFonts.montserrat(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    Future.delayed(Duration(seconds: 5));
    setState(() {
      scaffoldStatut = false;
    });
  }

  getCompartiement() async {
    var data = await RemoteServices.getOneCompartiment(widget.car);
    setState(() {
      c = data;
    });
    return data;
  }

  bool _animate = true;
  getbl() async {
    var data = await RemoteDepotService.allGetListeDepot(
      id: widget.car,
      state: "Approuvé",
    );

    setState(() {
      nbon = data;
    });
    qtyTotal = 0;
    for (var element in nbon) {
      if (element.statut == "Bon à Charger" || element.statut == "Chargé") {
        setState(() {
          qtyTotal = qtyTotal + element.qty;
        });
      }
    }
    setState(() {
      _animate = false;
    });
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getbl);
  }

  @override
  void initState() {
    super.initState();
    listIdCompartiment = [];
    getbl();
    getCompartiement();
    finaL!.clear();
    total!.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Vérification du BC",
          softWrap: true,
          style: styleAppBar,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : RefreshIndicator(
                  key: refreshKey,
                  onRefresh: refresh,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: SizedBox(
                              height:
                                  _size.height < _size.width
                                      ? _size.width / 17
                                      : _size.height / 17,
                              child: TextFormField(
                                controller: _searchview,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Le champs est obligatoir'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: (() {}),
                                    icon: Icon(
                                      Icons.search,
                                      color: green,
                                      size: 35,
                                    ),
                                  ),
                                  label: Text(
                                    "Rechercher ",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                    style: styleG,
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 245, 246, 247),
                                  hintText: "BL",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                right: 5,
                                left: 5,
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: nbon.length,
                                itemBuilder: ((context, index) {
                                  if (nbon[index].statut == "Bon à Charger" ||
                                      nbon[index].statut == "Chargé") {
                                    return GestureDetector(
                                      onTap:
                                          nbon[index].statut == "Chargé"
                                              ? () {
                                                setState(() {
                                                  scaffoldStatut = true;
                                                });

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            UpdateBLCharge(
                                                              bonLivraison:
                                                                  nbon[index],
                                                            ),
                                                  ),
                                                ).then((value) {
                                                  setState(() async {
                                                    await getbl();
                                                  });
                                                });
                                              }
                                              : () {
                                                for (var element
                                                    in nbon[index].produits) {
                                                  setState(() {
                                                    ctr_list_detail_bl.add(
                                                      element.id,
                                                    );
                                                  });
                                                }
                                                total!.clear();
                                                setState(() {
                                                  listTotalChargementBl = [];
                                                  listIdProduit = [];
                                                });

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) => DetailBC(
                                                          list: nbon[index],
                                                          car:
                                                              nbon[index]
                                                                  .camion
                                                                  .id,
                                                          imat:
                                                              nbon[index]
                                                                  .camion
                                                                  .imat,
                                                        ),
                                                  ),
                                                ).then((value) {
                                                  setState(() async {
                                                    await getbl();
                                                  });
                                                });
                                              },
                                      child: Card(
                                        color:
                                            nbon[index].statut ==
                                                    "Bon à Charger"
                                                ? null
                                                : nbon[index].statut == "Chargé"
                                                ? Colors.green[100]
                                                : null,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 3,
                                            left: 5,
                                            right: 5,
                                            bottom: 5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Image.asset(
                                                  'assets/icons/bc.png',
                                                  color:
                                                      nbon[index].statut ==
                                                              "Bon à Charger"
                                                          ? Color.fromARGB(
                                                            255,
                                                            103,
                                                            181,
                                                            245,
                                                          )
                                                          : nbon[index]
                                                                  .statut ==
                                                              "Chargé"
                                                          ? green
                                                          : null,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 8,
                                                fit: FlexFit.tight,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 5,
                                                    bottom: 5,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        nbon[index].numeroBl,
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        maxLines: 2,
                                                        style: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              nbon[index].statut ==
                                                                      "Bon à Charger"
                                                                  ? Colors.blue
                                                                  : nbon[index]
                                                                          .statut ==
                                                                      "Chargé"
                                                                  ? Color.fromARGB(
                                                                    255,
                                                                    56,
                                                                    131,
                                                                    81,
                                                                  )
                                                                  : null,
                                                        ),
                                                      ),
                                                      Text(
                                                        nbon[index]
                                                            .marketer
                                                            .nom,
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
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
                                                                  child: Icon(
                                                                    Icons
                                                                        .airport_shuttle_outlined,
                                                                    size: 15,
                                                                    color:
                                                                        nbon[index].statut ==
                                                                                "Bon à Charger"
                                                                            ? Color.fromARGB(
                                                                              255,
                                                                              103,
                                                                              181,
                                                                              245,
                                                                            )
                                                                            : nbon[index].statut ==
                                                                                "Chargé"
                                                                            ? green
                                                                            : null,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Flexible(
                                                                  flex: 5,
                                                                  child: Text(
                                                                    nbon[index]
                                                                        .transporteur
                                                                        .nom,
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                    style: GoogleFonts.montserrat(
                                                                      fontSize:
                                                                          10,
                                                                      color:
                                                                          nbon[index].statut ==
                                                                                  "Bon à Charger"
                                                                              ? Color.fromARGB(
                                                                                255,
                                                                                103,
                                                                                181,
                                                                                245,
                                                                              )
                                                                              : nbon[index].statut ==
                                                                                  "Chargé"
                                                                              ? green
                                                                              : null,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          VerticalDivider(
                                                            color: Colors.black,
                                                            width: 2,
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            fit: FlexFit.tight,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child: Icon(
                                                                    Icons
                                                                        .local_gas_station,
                                                                    size: 15,
                                                                    color:
                                                                        nbon[index].statut ==
                                                                                "Bon à Charger"
                                                                            ? Color.fromARGB(
                                                                              255,
                                                                              103,
                                                                              181,
                                                                              245,
                                                                            )
                                                                            : nbon[index].statut ==
                                                                                "Chargé"
                                                                            ? green
                                                                            : null,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Flexible(
                                                                  flex: 5,
                                                                  child: Text(
                                                                    nbon[index]
                                                                        .station
                                                                        .nom,
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                    style: GoogleFonts.montserrat(
                                                                      fontSize:
                                                                          10,
                                                                      color:
                                                                          nbon[index].statut ==
                                                                                  "Bon à Charger"
                                                                              ? Color.fromARGB(
                                                                                255,
                                                                                103,
                                                                                181,
                                                                                245,
                                                                              )
                                                                              : nbon[index].statut ==
                                                                                  "Chargé"
                                                                              ? green
                                                                              : null,
                                                                    ),
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
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Icon(
                                                  Icons.navigate_next,
                                                  size: 50,
                                                  color:
                                                      nbon[index].statut ==
                                                              "Bon à Charger"
                                                          ? Color.fromARGB(
                                                            255,
                                                            103,
                                                            181,
                                                            245,
                                                          )
                                                          : nbon[index]
                                                                  .statut ==
                                                              "Chargé"
                                                          ? green
                                                          : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget barreCodeLecteur(list) {
    var lts = list as BonL;

    return Scaffold(
      backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text(
          "Détail du BC",
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleG,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: logoDecoration(),
        child: Column(
          children: [
            HeaderMic(),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Icon(Icons.file_present, color: red, size: 30),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    flex: 3,
                    child: Text(
                      list.numeroBl,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (int m = 0; list.produits.length > m; m++) ...{
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: GestureDetector(
                  onTap: () {
                    if (total!.isNotEmpty) {
                      var _statut = false;
                      for (var list_id in total!) {
                        var ligne_id = list_id.toString().split(';')[0];
                        if (ligne_id == list.produits[m].id.toString()) {
                          setState(() {
                            _statut = true;
                          });
                          fToast.showToast(
                            child: erroAddBarreCode,
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 5),
                          );
                        }
                      }
                      if (_statut == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Traitement(
                                  listprodu: list.produits[m].produit,
                                  car: widget.car,
                                  qte: list.produits[m].qtte,
                                  position: m,
                                  id: list.produits[m].id,
                                  imat: widget.imat,
                                ),
                          ),
                        ).then((value) {
                          setState(() {
                            getElement();
                          });
                          setState(() {});
                        });
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Traitement(
                                listprodu: list.produits[m].produit,
                                car: widget.car,
                                qte: list.produits[m].qtte,
                                position: m,
                                id: list.produits[m].id,
                                imat: widget.imat,
                              ),
                        ),
                      ).then((value) {
                        setState(() {
                          getElement();
                        });
                        setState(() {});
                      });
                    }
                  },
                  child: Card(
                    // elevation: ,
                    color: defautlCardColors.withOpacity(0.5),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                        left: 10,
                        right: 10,
                        bottom: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  list.produits[m].produit.nom,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    // color: blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: Text(
                                  "${list.produits[m].qtte} ${list.produits[m].produit.unite}",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color: blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible:
                                listElement.contains(list.produits[m].id)
                                    ? true
                                    : false,
                            child: Icon(Icons.check_circle, color: green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            },
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            backgroundColor: blue,
            onPressed: () {
              if (total!.length == 0) {
                alertBlCharge(
                  'Veuillez repartir le(s) produit(s) dans le(s) compartiment(s) en y ajoutant les codes barre(s)',
                );
              } else {
                var _statu = false;
                if (_statu == false) {
                  List _final_list = [];
                  for (var list_id in total!) {
                    _final_list.add(list_id.toString().split(';')[0]);
                  }
                  for (var element in ctr_list_detail_bl) {
                    if (_final_list.contains(element)) {
                    } else {
                      setState(() {
                        _statu = true;
                      });
                    }
                  }
                  if (_statu == false) {
                    alertBlCharge(
                      'Impossible de passer au chargement!!!\n Vous n\'avez pas terminé de repartir tout les produits du BL',
                    );
                  }
                }
                if (_statu == true) {
                  depAddBC();

                  total!.clear();
                  Navigator.pop(context);
                  // }
                }
              }
            },
            label: Text(
              'Valider le chargement',
              softWrap: true,
              maxLines: 1,
              style: btnTxtCOlor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
