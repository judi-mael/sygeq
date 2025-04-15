// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, deprecated_member_use, void_checks, unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/TotalModel.dart';
import 'package:sygeq/Pages/Depot/ValidationBC.dart';
import 'package:sygeq/Pages/Depot/repartitionCompartiment.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/DefaultToas.dart';

List<TotalModel> listTotalChargementBl = [];
List<int> listIdProduit = [];
List listCompid = [];

// int qtteCharge = 0;

class DetailBC extends StatefulWidget {
  var list;
  int car;
  String imat;
  DetailBC({
    super.key,
    required this.list,
    required this.car,
    required this.imat,
  });

  @override
  State<DetailBC> createState() => _DetailBCState();
}

class _DetailBCState extends State<DetailBC> {
  bool _activeChargement = false;
  bool _retour = false;
  String toast_string = " ";
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late TextEditingController txtBarcode, txtCreuxCharger;
  final formKey = GlobalKey<FormState>();
  List ctr_list_detail_bl = [];
  // int qtteCharge = 0;

  alertBlCharge(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
        duration: Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, size: 20, color: Colors.white),
              SizedBox(width: 12.0),
              Flexible(
                child: Text(
                  message,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  depAddBC() async {
    var data = await RemoteDepotService.depotCreatBC(
      // total!,
      listTotalChargementBl,
    );
    return data;
  }

  List listElement = [];
  getElement() async {
    setState(() {
      listElement.clear();
    });
    for (var list_id in total!) {
      listElement.add(list_id.toString().split(';')[0]);
    }
  }

  abandonnerChargement() {
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
                    "Voulez-vous annuler le processus de chargement en cours?",
                    softWrap: true,
                    maxLines: 5,
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
                setState(() {
                  _retour = true;
                  listIdCompartiment.clear();
                });
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "Oui",
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
              },
              child: Text(
                "Non",
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

  @override
  void initState() {
    listCompid = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_retour == false) {
          setState(() {
            abandonnerChargement();
          });
        }
        return _retour;
      },
      child: Scaffold(
        backgroundColor: gryClaie,
        appBar: AppBar(
          backgroundColor: white,
          iconTheme: IconThemeData(
            color: gryClaie, //change your color here
          ),
          title: Text(
            "Détail du BC",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: styleAppBar,
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: logoDecoration(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(),
                child: Card(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 7,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Image.asset(
                                'assets/icons/bc.png',
                                width:
                                    MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 100),
                                color: blue,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              // fit: FlexFit.loose,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.list.numeroBl,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      color: blue,
                                      // fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.list.station.nom,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Icon(
                                          Icons.airport_shuttle_outlined,
                                          size: 15,
                                          color: blue,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Flexible(
                                        flex: 5,
                                        child: Text(
                                          widget.list.transporteur.nom,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 10,
                                            color: blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 3),
                      Flexible(
                        flex: 1,
                        child: Container(height: 50, width: 2, color: blue),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        flex: 5,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Icon(
                                    Icons.web_asset,
                                    size: 15,
                                    color: blue,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Flexible(
                                  flex: 5,
                                  child: Text(
                                    "Compartiments",
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: GoogleFonts.montserrat(
                                      // fontSize: 12,
                                      color: blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                for (
                                  int i = 0;
                                  widget.list.camion.vannes.length > i;
                                  i++
                                ) ...[
                                  Text(
                                    widget.list.camion.vannes[i].numero +
                                        " : " +
                                        widget.list.camion.vannes[i].capacite
                                            .toString() +
                                        " L   ",
                                    textScaleFactor: 0.9,
                                    style: GoogleFonts.montserrat(
                                      color:
                                          widget.list.camion.vannes[i].isBusy
                                                      .toString() ==
                                                  '0'
                                              ? blue
                                              : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                    left: 5,
                    right: 5,
                    bottom: 50,
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 2,
                      childAspectRatio:
                          _size.height < _size.width
                              ? MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 5)
                              : MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 8),
                    ),
                    itemCount: widget.list.produits.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (listIdProduit.contains(
                            widget.list.produits[index].produit.id,
                          )) {
                            fToast.showToast(
                              child: toastWidget(
                                "Ce produit a déjà fait objet d'une répartition. \n Essayer avec un autre produit",
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 5),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RepartCompartiment(
                                      blDetail: widget.list.produits[index],
                                      list: widget.list,
                                    ),
                              ),
                            ).then((value) {
                              setState(() {
                                super.widget;
                              });
                            });
                          }
                          // showDetailFromBL(widget.list.produits[index]);
                        },
                        child: Card(
                          color:
                              listIdProduit.contains(
                                    widget.list.produits[index].produit.id,
                                  )
                                  ? Colors.green[100]
                                  : Colors.grey[200],
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    _size.height < _size.width
                                        ? EdgeInsets.all(_size.width / 100)
                                        : EdgeInsets.all(_size.height / 100),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: Text(
                                        widget.list.produits[index].produit.nom,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: blue,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child:
                                          listIdProduit.contains(
                                                widget
                                                    .list
                                                    .produits[index]
                                                    .produit
                                                    .id,
                                              )
                                              ? Icon(
                                                Icons.check_circle,
                                                color: green,
                                              )
                                              : Icon(
                                                Icons.article,
                                                color: blue,
                                              ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Icon(
                                      Icons.layers_outlined,
                                      color: blue,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Text(
                                      "${widget.list.produits[index].qtte} " +
                                          widget
                                              .list
                                              .produits[index]
                                              .produit
                                              .unite,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        color: blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                if (listIdProduit.length != widget.list.produits.length) {
                  fToast.showToast(
                    child: toastWidget("Veuillez répartir tout les produits."),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 5),
                  );
                } else {
                  if (listTotalChargementBl.length > 0) {
                    setState(() {
                      _retour = true;
                    });
                    depAddBC();
                    listIdCompartiment.clear();
                    total!.clear();
                    Navigator.of(context, rootNavigator: true).pop();
                    // }
                  } else {
                    fToast.showToast(
                      child: toastWidget(
                        "Veuillez répartir tout les produits.",
                      ),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: Duration(seconds: 5),
                    );
                  }
                }
                // }
              },
              label: Text(
                'Valider le chargements',
                softWrap: true,
                maxLines: 1,
                style: btnTxtCOlor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
