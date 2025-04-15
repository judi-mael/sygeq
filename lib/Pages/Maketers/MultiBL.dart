// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_child_properties_last, deprecated_member_use, unnecessary_null_comparison, dead_code, non_constant_identifier_names, must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/ModelCreateMultiBL.dart';
import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Models/Ville.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

// List<Produit> productList = [];
// List<Depot> depList = [];
// List<Camion> listCar = [];

List<Depot> depList = [];

class MultiBL extends StatefulWidget {
  bool? gazoil;
  MultiBL({Key? key, this.gazoil}) : super(key: key);

  @override
  State<MultiBL> createState() => _MultiBLState();
}

class _MultiBLState extends State<MultiBL> {
  List? mesProduit = [];
  bool _addBl = true;
  bool _blElement = false;
  bool _updateBl = false;
  List<ModelCreateMultiBL> _listMultiBl = [];
  ModelCreateMultiBL? oneMultiBL;
  String prod = "";
  String qt = "";
  int capacity = 0;
  int? _elementposition;
  int lastCapacity = 0;
  int lastFilling = 0;
  bool isExpand = false;
  int filling = 0;
  String? _stationSelect;
  List<Produit> productList = [];
  List<Camion> listCar = [];
  int camionId = 0;
  int nbrElemntBl = 1;
  List<Compartiment>? listCompartomentCamion = [];
  bool _suivant = true;
  List<Compartiment> listCompartiment = [];
  late TextEditingController txtStation, txtTransporteur, txtCamion, txtBl;
  final fromKeySuivant = GlobalKey<FormState>();
  final fromKeyUpdate = GlobalKey<FormState>();
  final fromKey = GlobalKey<FormState>();
  final fromKey1 = GlobalKey<FormState>();
  final fromKey2 = GlobalKey<FormState>();
  String imatCamion = '';
  bool _retour = false;
  String txtProduct = 'Dog';
  markAddBl() async {
    var data = await MarketerRemoteService.manyBls(_listMultiBl);
    return data;
  }

  detailOfBl(ModelCreateMultiBL detailDuBl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            // scrollable: true,
            insetPadding: EdgeInsets.all(10),
            child: Container(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Dépôt : ',
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child:
                                  widget.gazoil == true
                                      ? Text(
                                        '           DPB',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      )
                                      : Text(
                                        depList[depList.indexWhere(
                                              (element) =>
                                                  element.id ==
                                                  detailDuBl.depotId,
                                            )]
                                            .nom,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Station : ',
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Text(
                                listMarkStation[listMarkStation.indexWhere(
                                      (element) =>
                                          element.id == detailDuBl.stationId,
                                    )]
                                    .nomStation,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Camion : ',
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Text(
                                listCar[listCar.indexWhere(
                                      (element) =>
                                          element.id == detailDuBl.camionId,
                                    )]
                                    .imat,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Détails",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(flex: 3, child: Text("Produits")),
                            Flexible(flex: 3, child: Text('Qtées')),
                          ],
                        ),
                      ),
                      for (int u = 0; detailDuBl.detailBl.length > u; u++) ...[
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  productList[productList.indexWhere(
                                        (elts) =>
                                            elts.id ==
                                            detailDuBl.detailBl[u].produitId,
                                      )]
                                      .nom,
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Text('${detailDuBl.detailBl[u].qtte}'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget toast = Container(
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      // color: Colors.redAccent,
    ),
    child: Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, size: 20, color: red),
        SizedBox(width: 12.0),
        Text(
          "Ce camion n'est plus en mésure de prendre un autre produit",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          softWrap: true,
          style: TextStyle(color: red),
        ),
      ],
    ),
  );
  _addProduit() {
    for (int i = 0; mesProduit!.length > i; i++) {
      // var list = mesProduit![i].toString().split(';');
      // return Text("data");
      return Padding(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Text(
                mesProduit![i].toString().split(';')[2],
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styleG,
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                mesProduit![i].toString().split(';')[1],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: styleG,
              ),
            ),
          ],
        ),
      );
    }
  }

  getProduct() async {
    var data = await RemoteServices.allGetListeProduits();
    setState(() {
      productList = data;
    });
    return productList;
  }

  micGetCamion() async {
    var res = await RemoteServices.allGetListeCamions();
    // if (!mounted) return null;
    setState(() {
      listCar = res;
    });
    Future.delayed(Duration(seconds: 2));

    return res;
  }

  getDep() async {
    var data = await RemoteServices.allGetListedepot();
    // if (!mounted) return null;
    setState(() {
      depList = data;
    });
    return data;
  }

  marketerGetStation() async {
    var data = await RemoteServices.allGetListeStation();
    // if (!mounted) return null;
    setState(() {
      listMarkStation = data;
    });
    setState(() {
      listMarkStation.add(
        Station(
          id: 0,
          nomStation: 'Destination inconnue',
          latitude: 0.0,
          longitude: 0.0,
          adresse: '',
          agrement: '',
          ifu: '',
          type: '',
          etat: 1,
          deletedAt: '',
          marketer: Marketer(
            id: 0,
            agrement: '',
            dateVigueur: '',
            dateExpiration: '',
            nom: '',
            type: '',
            adresse: '',
            registre: '',
            ifu: '',
            etat: 0,
            deletedAt: '',
          ),
          rccm: '',
          ville: Ville(id: 0, nom: ''),
        ),
      );
    });
    return data;
  }

  @override
  void initState() {
    super.initState();

    getDep();
    micGetCamion();
    marketerGetStation();
    // marketerGetTransporteurC();
    getProduct();

    // _addProduit();
    txtStation = TextEditingController();
    txtCamion = TextEditingController();
    txtTransporteur = TextEditingController();
    txtBl = TextEditingController();
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
                    "Voulez-vous annuler le processus de création de BL en cours?",
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_retour == true) {
          return true;
        } else {
          setState(() {
            abandonnerChargement();
          });
          return _retour;
        }
      },
      child: Scaffold(
        appBar:
            _suivant
                ? AppBar(
                  backgroundColor: white,
                  centerTitle: true,
                  iconTheme: IconThemeData(color: gryClaie),
                  title: Text(
                    "Création de BL",
                    style: styleAppBar,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
                : _addBl
                ? AppBar(
                  backgroundColor: white,
                  iconTheme: IconThemeData(color: gryClaie),
                  centerTitle: true,
                  title:
                      _listMultiBl.length > 0
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Création de BL",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: styleAppBar,
                              ),
                              Container(
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: red,
                                    foregroundColor: blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _addBl = false;
                                      _updateBl = false;
                                      _blElement = true;
                                    });
                                  },
                                  icon: Icon(Icons.close, color: white),
                                  label: Text(
                                    "Annuler",
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Text(
                            "Création de BL",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: styleAppBar,
                          ),
                )
                : AppBar(
                  backgroundColor: white,
                  iconTheme: IconThemeData(color: gryClaie),
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Création de BL",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: styleAppBar,
                      ),
                      Container(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _addBl = true;
                              _updateBl = false;
                              _blElement = false;
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text(
                            "Ajouter",
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 10, left: 10),
            child:
                _suivant
                    ? Form(
                      key: fromKeySuivant,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Visibility(
                              visible: widget.gazoil == true ? false : true,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right: 5,
                                  left: 5,
                                ),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    fit: FlexFit.loose,
                                    showSearchBox: true,
                                  ),
                                  items:
                                      depList.isEmpty
                                          ? []
                                          : depList.map((e) => e.nom).toList(),
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Choisissez le dépôt douanier'
                                              : null,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      int index = depList.indexWhere(
                                        (element) =>
                                            element.nom == newValue.toString(),
                                      );
                                      txtBl.text = depList[index].id.toString();
                                    });
                                  },
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: 'Dépôt douanier',
                                            ),
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                left: 5,
                                right: 5,
                                bottom: 5,
                              ),
                              child: DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  fit: FlexFit.loose,
                                  showSearchBox: true,
                                ),
                                items:
                                    listCar.isEmpty
                                        ? []
                                        : listCar.map((e) => e.imat).toList(),
                                validator:
                                    (value) =>
                                        value == null
                                            ? 'Choisissez le camion'
                                            : null,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    int index = listCar.indexWhere(
                                      (element) =>
                                          element.imat == newValue.toString(),
                                    );
                                    imatCamion = listCar[index].imat;
                                    txtCamion.text =
                                        listCar[index].id.toString();
                                    listCompartomentCamion =
                                        listCar[index].vannes;
                                    capacity = listCar[index].capacity;
                                    // filling = filling - lastCapacity;
                                    // filling =
                                    //     listCar[index].filling_level + filling;
                                    // lastCapacity = listCar[index].filling_level;
                                  });
                                },
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: 'Camion',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    backgroundColor: blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "Suivant",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (fromKeySuivant.currentState!
                                        .validate()) {
                                      setState(() {
                                        _suivant = false;
                                      });
                                    } else {}
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : _blElement
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; _listMultiBl.length > i; i++) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              onTap: () {
                                detailOfBl(_listMultiBl[i]);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(77, 211, 203, 203),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: -10,
                                        right: -10,
                                        child: IconButton(
                                          color: red,
                                          iconSize: 25,
                                          style: IconButton.styleFrom(),
                                          onPressed: () {
                                            _listMultiBl.removeAt(i);
                                            setState(() {
                                              _listMultiBl;
                                            });
                                          },
                                          icon: Icon(Icons.delete_forever),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: 30,
                                        child: IconButton(
                                          color: blue,
                                          iconSize: 25,
                                          onPressed: () {
                                            List produit = [];
                                            for (var element
                                                in _listMultiBl[i].detailBl) {
                                              String proqt =
                                                  "${element.produitId};${element.qtte};${productList[productList.indexWhere((elts) => elts.id == element.produitId)].nom}";
                                              produit.add(proqt);
                                            }
                                            setState(() {
                                              _elementposition = i;
                                              _stationSelect =
                                                  listMarkStation[listMarkStation
                                                          .indexWhere(
                                                            (element) =>
                                                                element.id ==
                                                                _listMultiBl[i]
                                                                    .stationId,
                                                          )]
                                                      .nomStation;
                                              mesProduit = produit;
                                              txtStation.text =
                                                  _listMultiBl[i].stationId
                                                      .toString();
                                              setState(() {
                                                _updateBl = true;
                                                _addBl = false;
                                                _blElement = false;
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          widget.gazoil == true
                                              ? Text(
                                                "Dépôt : DPB",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.blue,
                                                ),
                                              )
                                              : Text(
                                                "Dépôt : ${depList[depList.indexWhere((element) => element.id == _listMultiBl[i].depotId)].nom}",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                          Text(
                                            "Station : ${listMarkStation[listMarkStation.indexWhere((element) => element.id == _listMultiBl[i].stationId)].nomStation}",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Wrap(
                                            children: [
                                              for (
                                                int b = 0;
                                                _listMultiBl[i]
                                                        .detailBl
                                                        .length >
                                                    b;
                                                b++
                                              ) ...[
                                                Text(
                                                  "${productList[productList.indexWhere((elements) => elements.id == _listMultiBl[i].detailBl[b].produitId)].nom} : ${_listMultiBl[i].detailBl[b].qtte} | ",
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (_listMultiBl.length == 0)
                          Center(
                            heightFactor:
                                _size.height < _size.width
                                    ? _size.height * 0.04
                                    : _size.width * 0.07,
                            child: Container(
                              child: Text(
                                'Veuillez ajouter un BL',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        if (_listMultiBl.length > 0)
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  backgroundColor: blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Soumettre",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  if (_listMultiBl.isNotEmpty) {
                                    markAddBl();
                                    setState(() {
                                      _retour = true;
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        backgroundColor: red,
                                        duration: Duration(seconds: 5),
                                        content: Text(
                                          'Veuillez remplir le camion choisir',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible:
                              _blElement == true || _suivant == true
                                  ? false
                                  : true,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: ExpansionPanelList(
                              elevation: 0,
                              dividerColor: blue,
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  isExpand = !isExpand;
                                });
                              },
                              children: [
                                ExpansionPanel(
                                  backgroundColor: defautlCardColors,
                                  headerBuilder: (
                                    BuildContext context,
                                    bool isExpanded,
                                  ) {
                                    return ListTile(
                                      title: Text(
                                        'Camion $imatCamion',
                                        textScaleFactor: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    );
                                  },
                                  body: ListTile(
                                    title: Text(
                                      'Capacité :   ' + capacity.toString(),
                                      textScaleFactor: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Stack(
                                        // alignment: AlignmentDirectional.,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Les compartiments',
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              for (
                                                int p = 0;
                                                listCompartomentCamion!.length >
                                                    p;
                                                p++
                                              ) ...[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Text(
                                                    "N°${p + 1} - ${listCompartomentCamion![p].numero} - capacité ${listCompartomentCamion![p].capacite}",
                                                    textScaleFactor: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  isExpanded: isExpand,
                                ),
                              ],
                            ),
                          ),
                        ),

                        !_updateBl
                            ? Form(
                              key: fromKey,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                            right: 5,
                                            left: 5,
                                            bottom: 5,
                                          ),
                                          child: DropdownSearch<String>(
                                            popupProps: PopupProps.menu(
                                              showSearchBox: true,
                                              fit: FlexFit.loose,
                                            ),
                                            items:
                                                listMarkStation == null
                                                    ? []
                                                    : listMarkStation
                                                        .map(
                                                          (e) => e.nomStation,
                                                        )
                                                        .toList(),
                                            validator:
                                                (value) =>
                                                    value == null
                                                        ? 'Choisissez la Station'
                                                        : null,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                int index = listMarkStation
                                                    .indexWhere(
                                                      (element) =>
                                                          element.nomStation ==
                                                          newValue.toString(),
                                                    );
                                                // dropdownValue = newValue!;
                                                txtStation.text =
                                                    listMarkStation[index].id
                                                        .toString();
                                              });
                                            },
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        hintText: 'Station',
                                                      ),
                                                ),
                                          ),
                                        ),

                                        // Liste des produits déjà ajouté
                                        if (mesProduit!.isNotEmpty)
                                          for (
                                            int i = 0;
                                            mesProduit!.length > i;
                                            i++
                                          ) ...[
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: Row(
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width:
                                                        _size.height >
                                                                _size.width
                                                            ? MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.25
                                                            : MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.25,
                                                    child: Text(
                                                      mesProduit![i]
                                                          .toString()
                                                          .split(';')[2],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        _size.height >
                                                                _size.width
                                                            ? MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.1
                                                            : MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.1,
                                                    child: Text(
                                                      mesProduit![i]
                                                          .toString()
                                                          .split(';')[1],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  //////////////////////////////////////////////////////
                                                  /// supprission et modification d'un produit déjà ajouter
                                                  /// /////////////////////////////////////////////////
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              txtProduct =
                                                                  mesProduit![i]
                                                                      .toString()
                                                                      .split(
                                                                        ';',
                                                                      )[2];
                                                            });

                                                            showDialog(
                                                              context: context,
                                                              builder: (
                                                                BuildContext
                                                                context,
                                                              ) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                          Radius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  insetPadding:
                                                                      EdgeInsets.all(
                                                                        10,
                                                                      ),
                                                                  child: Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          8.0,
                                                                        ),
                                                                    child: SingleChildScrollView(
                                                                      child: Form(
                                                                        key:
                                                                            fromKey1,
                                                                        child: Column(
                                                                          children: [
                                                                            DropdownSearch<
                                                                              String
                                                                            >(
                                                                              popupProps: PopupProps.menu(
                                                                                showSearchBox:
                                                                                    true,
                                                                                fit:
                                                                                    FlexFit.loose,
                                                                              ),
                                                                              items:
                                                                                  productList.isEmpty
                                                                                      ? []
                                                                                      : productList
                                                                                          .map(
                                                                                            (
                                                                                              e,
                                                                                            ) =>
                                                                                                e.nom,
                                                                                          )
                                                                                          .toList(),
                                                                              validator:
                                                                                  (
                                                                                    value,
                                                                                  ) =>
                                                                                      value ==
                                                                                              null
                                                                                          ? 'Choisissez le produit'
                                                                                          : null,
                                                                              onChanged: (
                                                                                String?
                                                                                newValue,
                                                                              ) {
                                                                                setState(
                                                                                  () {
                                                                                    int index = productList.indexWhere(
                                                                                      (
                                                                                        element,
                                                                                      ) =>
                                                                                          element.nom ==
                                                                                          newValue!,
                                                                                    );
                                                                                    txtProduct =
                                                                                        newValue!;
                                                                                    prod =
                                                                                        productList[index].id.toString();
                                                                                  },
                                                                                );
                                                                              },
                                                                              selectedItem:
                                                                                  txtProduct,
                                                                              dropdownDecoratorProps: DropDownDecoratorProps(
                                                                                dropdownSearchDecoration: InputDecoration(
                                                                                  hintText:
                                                                                      'Produit',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                              ],
                                                                              initialValue:
                                                                                  mesProduit![i].toString().split(
                                                                                    ';',
                                                                                  )[1],
                                                                              toolbarOptions: ToolbarOptions(
                                                                                copy:
                                                                                    false,
                                                                                cut:
                                                                                    false,
                                                                                paste:
                                                                                    false,
                                                                                selectAll:
                                                                                    false,
                                                                              ),
                                                                              maxLength:
                                                                                  10,
                                                                              decoration: InputDecoration(
                                                                                label: Text(
                                                                                  "Quantité",
                                                                                  style: GoogleFonts.montserrat(
                                                                                    color:
                                                                                        green,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              keyboardType:
                                                                                  TextInputType.number,
                                                                              validator: (
                                                                                value,
                                                                              ) {
                                                                                return value!.isEmpty
                                                                                    ? 'Entré la quantité'
                                                                                    : null;
                                                                              },
                                                                              onChanged: (
                                                                                value,
                                                                              ) {
                                                                                qt =
                                                                                    value;
                                                                              },
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(
                                                                                top:
                                                                                    20,
                                                                                right:
                                                                                    10,
                                                                                left:
                                                                                    10,
                                                                              ),
                                                                              child: TextButton(
                                                                                child: Text(
                                                                                  'Ajouter',
                                                                                  overflow:
                                                                                      TextOverflow.ellipsis,
                                                                                  maxLines:
                                                                                      1,
                                                                                  softWrap:
                                                                                      true,
                                                                                  style: TextStyle(
                                                                                    color:
                                                                                        white,
                                                                                  ),
                                                                                ),
                                                                                style: TextButton.styleFrom(
                                                                                  backgroundColor:
                                                                                      blue,
                                                                                ),
                                                                                onPressed: () {
                                                                                  var _proqt =
                                                                                      "";
                                                                                  if (fromKey1.currentState!.validate()) {
                                                                                    setState(
                                                                                      () {
                                                                                        filling =
                                                                                            filling +
                                                                                            int.parse(
                                                                                              qt,
                                                                                            ) -
                                                                                            lastFilling;
                                                                                        _proqt =
                                                                                            "$prod;$qt;$txtProduct";
                                                                                        mesProduit!.remove(
                                                                                          mesProduit![i],
                                                                                        );
                                                                                        mesProduit!.insert(
                                                                                          i,
                                                                                          _proqt,
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                    Navigator.pop(
                                                                                      context,
                                                                                    );
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }),
                                                          icon: Icon(
                                                            Icons.edit_sharp,
                                                            color: blue,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: (() {
                                                            mesProduit!.remove(
                                                              mesProduit![i],
                                                            );
                                                            setState(() {});
                                                          }),
                                                          icon: Icon(
                                                            Icons
                                                                .cancel_rounded,
                                                            color: red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Form(
                              key: fromKeyUpdate,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                            right: 5,
                                            left: 5,
                                            bottom: 5,
                                          ),
                                          child: DropdownSearch<String>(
                                            popupProps: PopupProps.menu(
                                              fit: FlexFit.loose,
                                              showSearchBox: true,
                                            ),
                                            items:
                                                listMarkStation == null
                                                    ? []
                                                    : listMarkStation
                                                        .map(
                                                          (e) => e.nomStation,
                                                        )
                                                        .toList(),
                                            validator:
                                                (value) =>
                                                    value == null
                                                        ? 'Choisissez la Station'
                                                        : null,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                int index = listMarkStation
                                                    .indexWhere(
                                                      (element) =>
                                                          element.nomStation ==
                                                          newValue.toString(),
                                                    );
                                                // dropdownValue = newValue!;
                                                txtStation.text =
                                                    listMarkStation[index].id
                                                        .toString();
                                              });
                                            },

                                            // popupItemDisabled: (String s) => s.startsWith('I'),
                                            selectedItem: _stationSelect,
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        hintText: 'Station',
                                                      ),
                                                ),
                                          ),
                                        ),

                                        // Liste des produits déjà ajouté
                                        if (mesProduit!.isNotEmpty)
                                          for (
                                            int i = 0;
                                            mesProduit!.length > i;
                                            i++
                                          ) ...[
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: Row(
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width:
                                                        _size.height >
                                                                _size.width
                                                            ? MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.25
                                                            : MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.25,
                                                    child: Text(
                                                      mesProduit![i]
                                                          .toString()
                                                          .split(';')[2],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        _size.height >
                                                                _size.width
                                                            ? MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.1
                                                            : MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.1,
                                                    child: Text(
                                                      mesProduit![i]
                                                          .toString()
                                                          .split(';')[1],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  //////////////////////////////////////////////////////
                                                  /// supprission et modification d'un produit déjà ajouter
                                                  /// /////////////////////////////////////////////////
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              // lastFilling = int.parse(mesProduit![i]
                                                              //     .toString()
                                                              //     .split(';')[1]);
                                                              txtProduct =
                                                                  mesProduit![i]
                                                                      .toString()
                                                                      .split(
                                                                        ';',
                                                                      )[2];
                                                            });

                                                            showDialog(
                                                              context: context,
                                                              builder: (
                                                                BuildContext
                                                                context,
                                                              ) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                          Radius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  insetPadding:
                                                                      EdgeInsets.all(
                                                                        10,
                                                                      ),
                                                                  child: Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          10,
                                                                        ),
                                                                    child: SingleChildScrollView(
                                                                      child: Form(
                                                                        key:
                                                                            fromKey1,
                                                                        child: Column(
                                                                          children: [
                                                                            DropdownSearch<
                                                                              String
                                                                            >(
                                                                              popupProps: PopupProps.menu(
                                                                                fit:
                                                                                    FlexFit.loose,
                                                                                showSearchBox:
                                                                                    true,
                                                                              ),
                                                                              items:
                                                                                  productList.isEmpty
                                                                                      ? []
                                                                                      : productList
                                                                                          .map(
                                                                                            (
                                                                                              e,
                                                                                            ) =>
                                                                                                e.nom,
                                                                                          )
                                                                                          .toList(),
                                                                              validator:
                                                                                  (
                                                                                    value,
                                                                                  ) =>
                                                                                      value ==
                                                                                              null
                                                                                          ? 'Choisissez le produit'
                                                                                          : null,
                                                                              onChanged: (
                                                                                String?
                                                                                newValue,
                                                                              ) {
                                                                                setState(
                                                                                  () {
                                                                                    int index = productList.indexWhere(
                                                                                      (
                                                                                        element,
                                                                                      ) =>
                                                                                          element.nom ==
                                                                                          newValue!,
                                                                                    );
                                                                                    txtProduct =
                                                                                        newValue!;
                                                                                    prod =
                                                                                        productList[index].id.toString();
                                                                                  },
                                                                                );
                                                                              },
                                                                              selectedItem:
                                                                                  txtProduct,
                                                                              dropdownDecoratorProps: DropDownDecoratorProps(
                                                                                dropdownSearchDecoration: InputDecoration(
                                                                                  hintText:
                                                                                      'Produit',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                              ],
                                                                              initialValue:
                                                                                  mesProduit![i].toString().split(
                                                                                    ';',
                                                                                  )[1],
                                                                              toolbarOptions: ToolbarOptions(
                                                                                copy:
                                                                                    false,
                                                                                cut:
                                                                                    false,
                                                                                paste:
                                                                                    false,
                                                                                selectAll:
                                                                                    false,
                                                                              ),
                                                                              maxLength:
                                                                                  10,
                                                                              decoration: InputDecoration(
                                                                                label: Text(
                                                                                  "Quantité",
                                                                                  style: GoogleFonts.montserrat(
                                                                                    color:
                                                                                        green,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              keyboardType:
                                                                                  TextInputType.number,
                                                                              validator: (
                                                                                value,
                                                                              ) {
                                                                                return value!.isEmpty
                                                                                    ? 'Entré la quantité'
                                                                                    : null;
                                                                              },
                                                                              onChanged: (
                                                                                value,
                                                                              ) {
                                                                                qt =
                                                                                    value;
                                                                              },
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(
                                                                                top:
                                                                                    20,
                                                                                right:
                                                                                    10,
                                                                                left:
                                                                                    10,
                                                                              ),
                                                                              child: TextButton(
                                                                                child: Text(
                                                                                  'Ajouter',
                                                                                  overflow:
                                                                                      TextOverflow.ellipsis,
                                                                                  maxLines:
                                                                                      1,
                                                                                  softWrap:
                                                                                      true,
                                                                                  style: TextStyle(
                                                                                    color:
                                                                                        white,
                                                                                  ),
                                                                                ),
                                                                                style: TextButton.styleFrom(
                                                                                  backgroundColor:
                                                                                      blue,
                                                                                ),
                                                                                onPressed: () {
                                                                                  var _proqt =
                                                                                      "";
                                                                                  if (fromKey1.currentState!.validate()) {
                                                                                    setState(
                                                                                      () {
                                                                                        filling =
                                                                                            filling +
                                                                                            int.parse(
                                                                                              qt,
                                                                                            ) -
                                                                                            lastFilling;
                                                                                        _proqt =
                                                                                            "$prod;$qt;$txtProduct";
                                                                                        mesProduit!.remove(
                                                                                          mesProduit![i],
                                                                                        );
                                                                                        mesProduit!.insert(
                                                                                          i,
                                                                                          _proqt,
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                    Navigator.pop(
                                                                                      context,
                                                                                    );
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }),
                                                          icon: Icon(
                                                            Icons.edit_sharp,
                                                            color: blue,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: (() {
                                                            // setState(() {
                                                            //   filling = filling -
                                                            //       int.parse(mesProduit![i]
                                                            //           .toString()
                                                            //           .split(';')[1]);
                                                            // });
                                                            mesProduit!.remove(
                                                              mesProduit![i],
                                                            );
                                                            setState(() {});
                                                          }),
                                                          icon: Icon(
                                                            Icons
                                                                .cancel_rounded,
                                                            color: red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                        /////////////////////
                        ///  Boutton pour ajouter un produit
                        /// //////////////////////
                        Row(
                          children: [
                            Padding(
                              padding:
                                  _size.height > _size.width
                                      ? EdgeInsets.only(
                                        top: 20,
                                        // right: _size.width * 0.75,
                                      )
                                      : EdgeInsets.only(
                                        top: 20,
                                        // right: _size.width * 0.80,
                                      ),
                              child: TextButton.icon(
                                onPressed: (() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          // scrollable: true,
                                          insetPadding: EdgeInsets.all(10),
                                          child: Container(
                                            child: SingleChildScrollView(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Form(
                                                  key: fromKey2,
                                                  child: Column(
                                                    children: [
                                                      DropdownButtonFormField<
                                                        String
                                                      >(
                                                        isExpanded: true,
                                                        hint: Text(
                                                          "Produit",
                                                          style:
                                                              GoogleFonts.montserrat(
                                                                color: blue,
                                                              ),
                                                        ),
                                                        decoration:
                                                            InputDecoration(),
                                                        validator:
                                                            (value) =>
                                                                value == null
                                                                    ? 'Choisissez un produit'
                                                                    : null,
                                                        onChanged: (
                                                          String? newValue,
                                                        ) {
                                                          setState(() {
                                                            int
                                                            index = productList
                                                                .indexWhere(
                                                                  (element) =>
                                                                      element.id
                                                                          .toString() ==
                                                                      newValue,
                                                                );
                                                            txtProduct =
                                                                productList[index]
                                                                    .nom;
                                                            // txtStation.text = newValue;
                                                            prod = newValue!;
                                                          });
                                                        },
                                                        items:
                                                            productList.isEmpty
                                                                ? []
                                                                : productList.map((
                                                                  product,
                                                                ) {
                                                                  return DropdownMenuItem<
                                                                    String
                                                                  >(
                                                                    value:
                                                                        product
                                                                            .id
                                                                            .toString(),
                                                                    child: Text(
                                                                      product
                                                                          .nom,
                                                                      softWrap:
                                                                          true,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          styleG,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                      ),
                                                      TextFormField(
                                                        toolbarOptions:
                                                            ToolbarOptions(
                                                              copy: false,
                                                              cut: false,
                                                              paste: false,
                                                              selectAll: false,
                                                            ),
                                                        decoration: InputDecoration(
                                                          label: Text(
                                                            "Quantité",
                                                            style:
                                                                GoogleFonts.montserrat(
                                                                  color: blue,
                                                                ),
                                                          ),
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          return value!.isEmpty
                                                              ? 'Entré la quantité'
                                                              : null;
                                                        },
                                                        onChanged: (value) {
                                                          qt = value;
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              top: 20,
                                                              right: 10,
                                                              left: 10,
                                                            ),
                                                        child: TextButton(
                                                          style:
                                                              TextButton.styleFrom(
                                                                backgroundColor:
                                                                    blue,
                                                              ),
                                                          child: Text(
                                                            'Ajouter',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            var _proqt = "";
                                                            if (fromKey2
                                                                .currentState!
                                                                .validate()) {
                                                              setState(() {
                                                                filling =
                                                                    filling +
                                                                    int.parse(
                                                                      qt,
                                                                    );
                                                                _proqt =
                                                                    "$prod;$qt;$txtProduct";
                                                                mesProduit!.add(
                                                                  _proqt,
                                                                );
                                                              });
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            } else {
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  duration:
                                                                      Duration(
                                                                        seconds:
                                                                            2,
                                                                      ),
                                                                  content: Text(
                                                                    "Une erreur c'est produite veuillez réessayer",
                                                                    style: GoogleFonts.montserrat(
                                                                      color:
                                                                          Colors
                                                                              .redAccent,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                                style: TextButton.styleFrom(
                                  backgroundColor: blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.add,
                                  size: _size.height > _size.width ? 15 : 20,
                                  color: Colors.white,
                                ),
                                label: Container(
                                  child: Text(
                                    'Produit',
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                backgroundColor:
                                    mesProduit!.isEmpty ? Colors.grey : blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                _addBl ? "Valider" : "Modifier",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed:
                                  mesProduit!.isEmpty
                                      ? () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            // backgroundColor: green,
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              "Veuillez ajouter un ou des produits que vous souhaitiez",
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              // style: styleG,
                                            ),
                                          ),
                                        );
                                      }
                                      : _addBl
                                      ? () {
                                        if (fromKey.currentState!.validate()) {
                                          List<DetailBl> listeDetailBL = [];
                                          int total = 0;
                                          if (mesProduit!.isNotEmpty) {
                                            for (var element in mesProduit!) {
                                              total =
                                                  total +
                                                  int.parse(
                                                    element.toString().split(
                                                      ';',
                                                    )[1],
                                                  );
                                              listeDetailBL.add(
                                                DetailBl(
                                                  int.parse(
                                                    element.toString().split(
                                                      ';',
                                                    )[0],
                                                  ),
                                                  int.parse(
                                                    element.toString().split(
                                                      ';',
                                                    )[1],
                                                  ),
                                                ),
                                              );
                                            }
                                            if (total > capacity) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                  ),
                                                  backgroundColor: red,
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                  content: Text(
                                                    'La quantité de(s) produit(s) depasse la capacité du camion',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                _listMultiBl.add(
                                                  ModelCreateMultiBL(
                                                    int.parse(
                                                      txtStation.text
                                                          .trim()
                                                          .toString(),
                                                    ),
                                                    int.parse(
                                                      txtBl.text
                                                          .trim()
                                                          .toString(),
                                                    ),
                                                    int.parse(
                                                      txtCamion.text
                                                          .trim()
                                                          .toString(),
                                                    ),
                                                    listeDetailBL,
                                                  ),
                                                );
                                              });
                                              setState(() {
                                                mesProduit!.clear();
                                                _addBl = false;
                                                _updateBl = false;
                                                _blElement = true;
                                              });
                                            }
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                ),
                                                backgroundColor: red,
                                                duration: Duration(seconds: 3),
                                                content: Text(
                                                  'Ajouter un produit et réessayer',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        } else {}
                                      }
                                      : () {
                                        if (fromKeyUpdate.currentState!
                                            .validate()) {
                                          List<DetailBl> listeDetailBL = [];
                                          int total = 0;
                                          if (mesProduit!.isNotEmpty) {
                                            for (var element in mesProduit!) {
                                              total =
                                                  total +
                                                  int.parse(
                                                    element.toString().split(
                                                      ';',
                                                    )[1],
                                                  );
                                              listeDetailBL.add(
                                                DetailBl(
                                                  int.parse(
                                                    element.toString().split(
                                                      ';',
                                                    )[0],
                                                  ),
                                                  int.parse(
                                                    element.toString().split(
                                                      ';',
                                                    )[1],
                                                  ),
                                                ),
                                              );
                                            }
                                            if (total > capacity) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                  ),
                                                  backgroundColor: red,
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                  content: Text(
                                                    'La quantité de(s) produit(s) depasse la capacité du camion',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                _listMultiBl.removeAt(
                                                  _elementposition!,
                                                );
                                                _listMultiBl.insert(
                                                  _elementposition!,
                                                  ModelCreateMultiBL(
                                                    int.parse(
                                                      txtStation.text
                                                          .trim()
                                                          .toString(),
                                                    ),
                                                    int.parse(
                                                      txtBl.text
                                                          .trim()
                                                          .toString(),
                                                    ),
                                                    int.parse(
                                                      txtCamion.text
                                                          .trim()
                                                          .toString(),
                                                    ),
                                                    listeDetailBL,
                                                  ),
                                                );
                                              });
                                              setState(() {
                                                mesProduit!.clear();
                                                _addBl = false;
                                                _updateBl = false;
                                                _blElement = true;
                                              });
                                            }
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                ),
                                                backgroundColor: red,
                                                duration: Duration(seconds: 3),
                                                content: Text(
                                                  'Ajouter un produit et réessayer',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        } else {}
                                      },
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
          /////////////////////
          ///  Bouton pour soumettre le formulaire
          /// //////////////////////
        ),
      ),
    );
  }
}
