// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, unused_field, must_be_immutable, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Pages/Depot/depotUIi/ListBLGPLBouteilleCard.dart';
import 'package:sygeq/Pages/Depot/depotUIi/checkAndValidateBL.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class ChargerGPLBouteille extends StatefulWidget {
  int car;
  var capacite;
  ChargerGPLBouteille({Key? key, required this.car, required this.capacite})
    : super(key: key);

  @override
  State<ChargerGPLBouteille> createState() => _ChargerGPLBouteilleState();
}

class _ChargerGPLBouteilleState extends State<ChargerGPLBouteille> {
  List<BonL> nbon = [];
  List<BonL> filterList = [];
  List<int> listAcharger = [];
  final _searchview = TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  int _niveauBonCharger = 0;

  // int qtyTotal = 0;
  String commentaire = "";
  bool _animate = true;
  _ChargerGPLBouteilleState() {
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
  chargerBlGPLBouteille() async {
    var data = await RemoteDepotService.chargerBlGplBouteille(listAcharger);
    setState(() {
      listAcharger.clear();
    });
    super.widget;
    return data;
  }

  getbl() async {
    var data = await RemoteDepotService.allGetListeDepot_GplBouteille(
      id: widget.car,
      state: "Approuvé",
    );
    setState(() {
      _niveauBonCharger = 0;
      nbon = data;
    });
    for (var element in nbon) {
      if (element.statut == "Approuvé" || element.statut == "Bon à Charger") {
        if (element.statut == "Bon à Charger") {
          setState(() {
            _niveauBonCharger += element.qty;
          });
        }
      }
    }
    setState(() {
      _animate = false;
    });
    return data;
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getbl);
  }

  @override
  void initState() {
    getbl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(color: gryClaie),
        centerTitle: true,
        title: Text(
          "Charger du GPL en bouteille",
          softWrap: true,
          maxLines: 1,
          style: styleAppBar,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (listAcharger.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                chargerBlGPLBouteille();
              },
              child: Text(
                'Charger',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(color: white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
        ],
      ),
      // backgroundColor: gryClaie,
      body:
          _animate == true
              ? animationLoadingData()
              : Container(
                decoration: logoDecoration(),
                child: RefreshIndicator(
                  key: refreshKey,
                  onRefresh: refresh,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
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
                                    size: 30,
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
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Card(elevation: 2, color: Colors.amber[500]),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child:
                                nbon.isEmpty
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          EmptyList(),
                                          EmptyMessage(),
                                          TextButton.icon(
                                            style: TextButton.styleFrom(
                                              backgroundColor: blue,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                getbl();
                                              });
                                            },
                                            icon: Icon(
                                              Icons.refresh,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            label: Text(
                                              'Réessayer',
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : !_firstSearch
                                    ? _performSearch()
                                    : ListView.builder(
                                      itemCount: nbon.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        if ((nbon[index].produits[0].produit.nom
                                            .contains('BOUTEILLE'))) {
                                          return GestureDetector(
                                            onTap: () {
                                              // actionOnTheValidateBL(
                                              //     nbon[index]);
                                            },
                                            child: Card(
                                              color:
                                                  nbon[index].statut ==
                                                          "Bon à Charger"
                                                      ? Colors.white
                                                      : nbon[index].statut ==
                                                          "Chargé"
                                                      ? Colors.green[100]
                                                      : null,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (nbon[index].statut ==
                                                        "Bon à Charger")
                                                      Flexible(
                                                        flex: 1,
                                                        child: Checkbox(
                                                          value:
                                                              listAcharger
                                                                      .contains(
                                                                        nbon[index]
                                                                            .id,
                                                                      )
                                                                  ? true
                                                                  : false,
                                                          activeColor: blue,
                                                          onChanged: (value) {
                                                            if (value == true) {
                                                              setState(() {
                                                                listAcharger.add(
                                                                  nbon[index]
                                                                      .id,
                                                                );
                                                              });
                                                            } else {
                                                              setState(() {
                                                                listAcharger
                                                                    .removeWhere(
                                                                      (item) =>
                                                                          item ==
                                                                          nbon[index]
                                                                              .id,
                                                                    );
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    SizedBox(width: 15),
                                                    ListBLGPLBouteilleCard(
                                                      bonBl: nbon[index],
                                                    ),
                                                    //
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _performSearch() {
    filterList.clear();
    for (int i = 0; i < nbon.length; i++) {
      var item = nbon[i];

      if (item.numeroBl.toLowerCase().contains(_query.toLowerCase()) ||
          item.marketer.nom.toLowerCase().contains(_query.toLowerCase()) ||
          item.station.nom.toLowerCase().contains(_query.toLowerCase())) {
        filterList.add(item);
      }
    }
    return _filterlist();
  }

  Widget _filterlist() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: filterList.length,
      itemBuilder: (context, int index) {
        if (filterList[index].produits[0].produit.nom.contains('BOUTEILLE')) {
          return GestureDetector(
            onTap: () {
              // actionOnTheValidateBL(filterList[index]);
            },
            child: Card(
              color:
                  filterList[index].statut == "Bon à Charger"
                      ? Colors.white
                      : filterList[index].statut == "Chargé"
                      ? Colors.green[100]
                      : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    if (filterList[index].statut == "Bon à Charger")
                      Flexible(
                        flex: 1,
                        child: Checkbox(
                          value:
                              listAcharger.contains(filterList[index].id)
                                  ? true
                                  : false,
                          activeColor: blue,
                          onChanged: (value) {
                            if (value == true) {
                              setState(() {
                                listAcharger.add(filterList[index].id);
                              });
                            } else {
                              setState(() {
                                listAcharger.removeWhere(
                                  (item) => item == filterList[index].id,
                                );
                              });
                            }
                          },
                        ),
                      ),
                    SizedBox(width: 15),
                    ListBLGPLBouteilleCard(bonBl: filterList[index]),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  actionOnTheValidateBL(BonL detailBL) {
    bool visible = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            insetPadding: EdgeInsets.all(5),
            // scrollable: true,
            child: CheckAndValidateBl(bonBl: detailBL),
          ),
        );
      },
    ).then((value) {
      setState(() {
        getbl();
      });
    });
  }
}
