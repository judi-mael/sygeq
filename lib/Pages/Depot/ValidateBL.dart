// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class ValidateBL extends StatefulWidget {
  int car;
  var capacite;
  ValidateBL({Key? key, required this.car, required this.capacite})
    : super(key: key);

  @override
  State<ValidateBL> createState() => _ValidateBLState();
}

class _ValidateBLState extends State<ValidateBL> {
  late TextEditingController txtCommentaire;
  List<BonL> nbon = [];
  List<BonL> filterList = [];
  final formKey = GlobalKey<FormState>();
  final _searchview = TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  int id = 0;
  int _niveauBonCharger = 0;
  bool isExpand = false;
  String statut = "";
  // int qtyTotal = 0;
  String commentaire = "";
  bool _animate = true;
  _ValidateBLState() {
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
  getbl() async {
    var data = await RemoteDepotService.allGetListeDepot(
      id: widget.car,
      state: "Approuvé",
    );
    // if (!mounted) return null;
    setState(() {
      _niveauBonCharger = 0;
      nbon = data;
    });
    // qtyTotal = 0;
    for (var element in nbon) {
      if (element.statut == "Approuvé" || element.statut == "Bon à Charger") {
        if (element.statut == "Bon à Charger") {
          setState(() {
            _niveauBonCharger += element.qty;
          });
        }
        // setState(() {
        //   qtyTotal = qtyTotal + element.qty;
        // });
      }
    }
    setState(() {
      _animate = false;
    });
    return data;
  }

  rejetBl() async {
    var data = await RemoteDepotService.updateBlDepot(
      id: id,
      state: statut,
      commentaire: commentaire,
    );
    return data;
  }

  confirmeBl() async {
    var data = await RemoteDepotService.updateBlDepot(
      id: id,
      state: statut,
      commentaire: commentaire,
    );
    return data;
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getbl);
  }

  actionOnTheValidateBL(list) {
    var lts = list as BonL;
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
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, size: 40),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        list.numeroBl,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        lts.station.nom,
                        textAlign: TextAlign.start,
                        style: styleG,
                        // style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ExpansionPanelList(
                        elevation: 0,
                        dividerColor: blue,
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            isExpand = !isExpand;
                          });
                          setState(() {});
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (
                              BuildContext context,
                              bool isExpended,
                            ) {
                              return ListTile(
                                title: Text(
                                  "Produits",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            },
                            isExpanded: true,
                            body: ListTile(
                              title: Column(
                                children: [
                                  for (
                                    int i = 0;
                                    lts.produits.length > i;
                                    i++
                                  ) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            lts.produits[i].produit.nom,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.montserrat(
                                              color: Colors.blue[300],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            '${lts.produits[i].qtte} ${lts.produits[i].produit.unite}',
                                            softWrap: true,
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          toolbarOptions: ToolbarOptions(
                            copy: false,
                            cut: false,
                            paste: true,
                            selectAll: false,
                          ),
                          maxLength: 1500,
                          maxLines: 5,

                          decoration: InputDecoration(
                            hintText:
                                "Le champs commentaire est obligatoire si vous voulez rejeter le BL",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              "Commentaire",
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: styleG,
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Ajouter de commentaire'
                                : null;
                          },
                          onChanged: (value) {
                            txtCommentaire.text = value;
                          },
                        ),
                      ),
                    ),
                    lts.statut != "Bon à Charger"
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                onPressed: () {
                                  if (_niveauBonCharger + list.qty >
                                      widget.capacite) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: red,
                                        duration: Duration(seconds: 5),
                                        content: Text(
                                          "La capacité du camion est infeirieur à la somme des quantités de bl que vous voulez charger ",
                                          maxLines: 5,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: styleG,
                                        ),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      id = list.id;
                                      statut = "Bon à Charger";
                                      txtCommentaire.clear();
                                    });
                                    confirmeBl();
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                  }
                                },
                                child: Text(
                                  "Valider",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    id = list.id;
                                    statut = "Rejeté";
                                  });

                                  if (formKey.currentState!.validate()) {
                                    rejetBl();
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                  }
                                },
                                child: Text(
                                  "Rejeter",
                                  softWrap: true,
                                  maxLines: 1,
                                  textScaleFactor: 1.2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                id = list.id;
                                statut = "Rejeté";
                              });

                              if (formKey.currentState!.validate()) {
                                rejetBl();
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              }
                            },
                            child: Text(
                              "Rejeter",
                              softWrap: true,
                              maxLines: 1,
                              textScaleFactor: 1.2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() {
        getbl();
      });
    });
  }

  @override
  void initState() {
    getbl();
    super.initState();
    txtCommentaire = TextEditingController();
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
          "Validation des BL",
          softWrap: true,
          maxLines: 1,
          style: styleAppBar,
          overflow: TextOverflow.ellipsis,
        ),
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
                                        if (nbon[index].statut == "Approuvé" ||
                                            nbon[index].statut ==
                                                "Bon à Charger" ||
                                            nbon[index].statut == "Rejeté") {
                                          return GestureDetector(
                                            onTap: () {
                                              actionOnTheValidateBL(
                                                nbon[index],
                                              );
                                              // }
                                              // setState(() {});
                                              // Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             builder: ((context) =>
                                              //                 updateBl(
                                              //                     nbon[index]))))
                                              //     .then((value) async {
                                              //   await getbl();
                                              // });
                                              // setState(() {});
                                            },
                                            child: Card(
                                              color:
                                                  nbon[index].statut ==
                                                          "Approuvé"
                                                      ? Colors.white
                                                      : nbon[index].statut ==
                                                          "Bon à Charger"
                                                      ? Colors.green[100]
                                                      : nbon[index].statut ==
                                                          "Rejeté"
                                                      ? red.withOpacity(0.5)
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            nbon[index]
                                                                .numeroBl,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: GoogleFonts.montserrat(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  nbon[index].statut ==
                                                                          "Approuvé"
                                                                      ? Colors
                                                                          .blue
                                                                      : nbon[index]
                                                                              .statut ==
                                                                          "Bon à Charger"
                                                                      ? Color.fromARGB(
                                                                        212,
                                                                        26,
                                                                        100,
                                                                        66,
                                                                      )
                                                                      : nbon[index]
                                                                              .statut ==
                                                                          "Rejeté"
                                                                      ? red
                                                                      : null,
                                                            ),
                                                          ),
                                                          Text(
                                                            nbon[index]
                                                                .station
                                                                .nom,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style:
                                                                GoogleFonts.montserrat(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Icon(
                                                        Icons.navigate_next,
                                                        size: 50,
                                                        color:
                                                            nbon[index].statut ==
                                                                    "Approuvé"
                                                                ? Colors.blue
                                                                : nbon[index]
                                                                        .statut ==
                                                                    "Bon à Charger"
                                                                ? Color.fromARGB(
                                                                  212,
                                                                  26,
                                                                  100,
                                                                  66,
                                                                )
                                                                : nbon[index]
                                                                        .statut ==
                                                                    "Rejeté"
                                                                ? red
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
        if (filterList[index].statut == "Approuvé" ||
            filterList[index].statut == "Bon à Charger" ||
            filterList[index].statut == "Rejeté") {
          return GestureDetector(
            onTap: () {
              actionOnTheValidateBL(filterList[index]);
            },
            child: Card(
              color:
                  filterList[index].statut == "Approuvé"
                      ? Colors.white
                      : filterList[index].statut == "Bon à Charger"
                      ? Colors.green[100]
                      : filterList[index].statut == "Rejeté"
                      ? red.withOpacity(0.5)
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filterList[index].numeroBl,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color:
                                  filterList[index].statut == "Approuvé"
                                      ? Colors.blue
                                      : filterList[index].statut ==
                                          "Bon à Charger"
                                      ? Color.fromARGB(212, 26, 100, 66)
                                      : filterList[index].statut == "Rejeté"
                                      ? red
                                      : null,
                            ),
                          ),
                          Text(
                            filterList[index].station.nom,
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
                      child: Icon(
                        Icons.navigate_next,
                        size: 50,
                        color:
                            filterList[index].statut == "Approuvé"
                                ? Colors.blue
                                : filterList[index].statut == "Bon à Charger"
                                ? Color.fromARGB(212, 26, 100, 66)
                                : filterList[index].statut == "Rejeté"
                                ? red
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
      },
    );
  }

  Widget updateBl(list) {
    var lts = list as BonL;
    bool visible = false;
    // var product = list.produits as Produit;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        centerTitle: true,
        title: Text(
          "Vérification du BL",
          softWrap: true,
          maxLines: 1,
          style: styleG,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        decoration: logoDecoration(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Column(
              children: [
                HeaderMic(),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    list.numeroBl,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Icon(
                          Icons.local_gas_station_outlined,
                          color: red,
                          size: 30,
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Text(
                          lts.station.nom,
                          textAlign: TextAlign.start,
                          style: styleG,
                          // style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Produits",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Card(
                  color: Color.fromARGB(255, 87, 92, 99),
                  child: Column(
                    children: [
                      for (int i = 0; lts.produits.length > i; i++)
                        if (lts.statut == "Approuvé" ||
                            lts.statut == "Bon à Charger" ||
                            lts.statut == "Rejeté")
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: 10,
                              right: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      lts.produits[i].produit.nom,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      '${lts.produits[i].qtte} ${lts.produits[i].produit.unite}',
                                      softWrap: true,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      toolbarOptions: ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: true,
                        selectAll: false,
                      ),
                      maxLength: 300,
                      maxLines: 5,

                      decoration: InputDecoration(
                        hintText:
                            "Le champs commentaire est obligatoire si vous voulez rejeter le BL",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: Text(
                          "Commentaire",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleG,
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        return value!.isEmpty ? 'Ajouter de commentaire' : null;
                      },
                      onChanged: (value) {
                        txtCommentaire.text = value;
                      },
                    ),
                  ),
                ),
                lts.statut != "Bon à Charger"
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                id = list.id;
                                statut = "Bon à Charger";
                                txtCommentaire.clear();
                              });
                              confirmeBl();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "Valider",
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // child: Text(
                            //   "A charger",
                            //   softWrap: true,
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: GoogleFonts.montserrat(fontSize: 20),
                            // ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                id = list.id;
                                statut = "Rejeté";
                              });

                              if (formKey.currentState!.validate()) {
                                rejetBl();
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              }
                            },
                            child: Text(
                              "Rejeter",
                              softWrap: true,
                              maxLines: 1,
                              textScaleFactor: 1.2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // child: Text(
                            //   "Rejeter",
                            //   softWrap: true,
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: GoogleFonts.montserrat(fontSize: 20),
                            // ),
                          ),
                        ),
                      ],
                    )
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            id = list.id;
                            statut = "Rejeté";
                          });

                          if (formKey.currentState!.validate()) {
                            rejetBl();
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                        child: Text(
                          "Rejeter",
                          softWrap: true,
                          maxLines: 1,
                          textScaleFactor: 1.2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // child: Text(
                        //   "Rejeter",
                        //   softWrap: true,
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: GoogleFonts.montserrat(fontSize: 20),
                        // ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
