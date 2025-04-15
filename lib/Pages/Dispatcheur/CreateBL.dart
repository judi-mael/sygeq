// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_child_properties_last, dead_code

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Pages/Dispatcheur/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

List<Produit> productList = [];
List<Depot> depList = [];
List<Camion> listCar = [];

class CreateBLDispatcheur extends StatefulWidget {
  const CreateBLDispatcheur({Key? key}) : super(key: key);

  @override
  State<CreateBLDispatcheur> createState() => _CreateBLDispatcheurState();
}

class _CreateBLDispatcheurState extends State<CreateBLDispatcheur> {
  List? mesProduit = [];
  String prod = "";
  String qt = "";
  List<Produit> productList = [];
  List<Depot> depList = [];
  List<Camion> listCar = [];
  late TextEditingController
      // txtId,
      txtStation,
      txtTransporteur,
      txtCamion,
      // txtDate,
      txtBl;
  final fromKey = GlobalKey<FormState>();
  final fromKey1 = GlobalKey<FormState>();
  final fromKey2 = GlobalKey<FormState>();
  String txtProduct = 'Dog';
  markAddBl() async {
    var data = MarketerRemoteService.markAddBL(
      txtBl.text.toString().trim(),
      txtStation.text.toString().trim(),
      txtTransporteur.text.toString().trim(),
      txtCamion.text.toString().trim(),
      mesProduit!,
      prefUserInfo['idUser'].toString(),
    );
    return data;
  }

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

  driverCas(int id) async {
    var data = await RemoteServices.allGetDriverCamions(dd: id);
    setState(() {
      listCar = data;
    });
    return data;
  }

  getDep() async {
    var data = await RemoteServices.allGetListedepot();
    setState(() {
      depList = data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    _addProduit();
    getProduct();
    getDep();
    // txtId = TextEditingController();
    txtStation = TextEditingController();
    txtCamion = TextEditingController();
    txtTransporteur = TextEditingController();
    // txtDate = TextEditingController();
    txtBl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        title: Text("Nouveau BL", overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
      backgroundColor: gryClaie,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderMic(),
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 30),
                  child: Text(
                    "Formulaire de Création",
                    style: GoogleFonts.montserrat(fontSize: 25),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Form(
                    key: fromKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                            ),
                            items: depList.map((e) => e.nom).toList(),
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
                                // dropdownValue = newValue!;
                                txtBl.text = depList[index].id.toString();
                              });
                            },
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            // isFilteredOnline: true,
                            // showSearchBox: true,
                            // showSelectedItems: true,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Dépôt douanier',
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                            ),
                            items:
                                listMarkStation
                                    .map((e) => e.nomStation)
                                    .toList(),
                            validator:
                                (value) =>
                                    value == null
                                        ? 'Choisissez la Station'
                                        : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                int index = listMarkStation.indexWhere(
                                  (element) =>
                                      element.nomStation == newValue.toString(),
                                );
                                // dropdownValue = newValue!;
                                txtStation.text =
                                    listMarkStation[index].id.toString();
                              });
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Station',
                              ),
                            ),
                          ),
                        ),

                        /////////////////////////////
                        ///// Transporteur
                        /////////////////////////////
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                  ),
                                  items:
                                      listMarkTransporteur
                                          .map((e) => e.nom)
                                          .toList(),
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Choisissez le Transporteur'
                                              : null,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      int index = listMarkTransporteur
                                          .indexWhere(
                                            (element) =>
                                                element.nom ==
                                                newValue.toString(),
                                          );
                                      // dropdownValue = newValue!;
                                      txtTransporteur.text =
                                          listMarkTransporteur[index].id
                                              .toString();
                                      driverCas(listMarkTransporteur[index].id);
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
                                              hintText: 'Transporteur',
                                            ),
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                  ),
                                  items: listCar.map((e) => e.imat).toList(),
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
                                      // dropdownValue = newValue!;
                                      txtCamion.text =
                                          listCar[index].id.toString();
                                    });
                                  },
                                  // popupItemDisabled: (String s) => s.startsWith('I'),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: 'Camion',
                                            ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////////////////////////////
                        ////// Liste des produits déjà ajouté
                        ////////////////////////////////////////////
                        if (mesProduit!.isNotEmpty)
                          for (int i = 0; mesProduit!.length > i; i++)
                            Container(
                              child: Row(
                                verticalDirection: VerticalDirection.down,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width:
                                        _size.height > _size.width
                                            ? MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.25
                                            : MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.25,
                                    child: Text(
                                      mesProduit![i].toString().split(';')[2],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        _size.height > _size.width
                                            ? MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.1
                                            : MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.1,
                                    child: Text(
                                      mesProduit![i].toString().split(';')[1],
                                      overflow: TextOverflow.ellipsis,
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
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                  ),
                                                  scrollable: true,
                                                  content: Container(
                                                    child: Form(
                                                      key: fromKey1,
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
                                                                    color:
                                                                        green,
                                                                  ),
                                                            ),
                                                            decoration:
                                                                InputDecoration(),
                                                            validator:
                                                                (value) =>
                                                                    value ==
                                                                            null
                                                                        ? 'Choisissez un produit'
                                                                        : null,
                                                            onChanged: (
                                                              String? newValue,
                                                            ) {
                                                              setState(() {
                                                                int
                                                                index = productList
                                                                    .indexWhere(
                                                                      (
                                                                        element,
                                                                      ) =>
                                                                          element
                                                                              .id
                                                                              .toString() ==
                                                                          newValue,
                                                                    );
                                                                txtProduct =
                                                                    productList[index]
                                                                        .nom;
                                                                prod =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items:
                                                                productList.map((
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
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly,
                                                            ],
                                                            initialValue:
                                                                mesProduit![i]
                                                                    .toString()
                                                                    .split(
                                                                      ';',
                                                                    )[1],
                                                            toolbarOptions:
                                                                ToolbarOptions(
                                                                  copy: false,
                                                                  cut: false,
                                                                  paste: false,
                                                                  selectAll:
                                                                      false,
                                                                ),
                                                            maxLength: 10,
                                                            decoration:
                                                                InputDecoration(
                                                                  label: Text(
                                                                    "Quantité",
                                                                    style: GoogleFonts.montserrat(
                                                                      color:
                                                                          green,
                                                                    ),
                                                                  ),
                                                                ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (value) {
                                                              return value!
                                                                      .isEmpty
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
                                                              child: Text(
                                                                'Ajouter',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                softWrap: true,
                                                              ),
                                                              onPressed: () {
                                                                var _proqt = "";
                                                                if (fromKey1
                                                                    .currentState!
                                                                    .validate()) {
                                                                  setState(() {
                                                                    _proqt =
                                                                        "$prod;$qt;$txtProduct";
                                                                    mesProduit!
                                                                        .remove(
                                                                          mesProduit![i],
                                                                        );
                                                                    mesProduit!
                                                                        .insert(
                                                                          i,
                                                                          _proqt,
                                                                        );
                                                                  });
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
                                            mesProduit!.remove(mesProduit![i]);
                                            setState(() {});
                                          }),
                                          icon: Icon(
                                            Icons.cancel_rounded,
                                            color: red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        /////////////////////
                        ///  Boutton pour ajouter un produit
                        /// //////////////////////
                        Padding(
                          padding:
                              _size.height > _size.width
                                  ? EdgeInsets.only(
                                    top: 20,
                                    right: _size.width * 0.75,
                                  )
                                  : EdgeInsets.only(
                                    top: 20,
                                    right: _size.width * 0.80,
                                  ),
                          child: TextButton.icon(
                            onPressed: (() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    scrollable: true,
                                    content: Container(
                                      child: Form(
                                        key: fromKey2,
                                        child: Column(
                                          children: [
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              hint: Text(
                                                "Produit",
                                                style: GoogleFonts.montserrat(
                                                  color: green,
                                                ),
                                              ),
                                              decoration: InputDecoration(),
                                              validator:
                                                  (value) =>
                                                      value == null
                                                          ? 'Choisissez un produit'
                                                          : null,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  int index = productList
                                                      .indexWhere(
                                                        (element) =>
                                                            element.id
                                                                .toString() ==
                                                            newValue,
                                                      );
                                                  txtProduct =
                                                      productList[index].nom;
                                                  // txtStation.text = newValue;
                                                  prod = newValue!;
                                                });
                                              },
                                              items:
                                                  productList.map((product) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value:
                                                          product.id.toString(),
                                                      child: Text(
                                                        product.nom,
                                                        softWrap: true,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        maxLines: 1,
                                                        style: styleG,
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                            TextFormField(
                                              toolbarOptions: ToolbarOptions(
                                                copy: false,
                                                cut: false,
                                                paste: false,
                                                selectAll: false,
                                              ),
                                              decoration: InputDecoration(
                                                label: Text(
                                                  "Quantité",
                                                  style: GoogleFonts.montserrat(
                                                    color: green,
                                                  ),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
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
                                              padding: EdgeInsets.only(
                                                top: 20,
                                                right: 10,
                                                left: 10,
                                              ),
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: blue,
                                                ),
                                                child: Text('Ajouter'),
                                                onPressed: () {
                                                  var _proqt = "";
                                                  if (fromKey2.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      _proqt =
                                                          "$prod;$qt;$txtProduct";
                                                      mesProduit!.add(_proqt);
                                                    });
                                                    Navigator.pop(context);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        duration: Duration(
                                                          seconds: 2,
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
                                  );
                                },
                              );
                            }),
                            style: TextButton.styleFrom(
                              backgroundColor: blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
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
                  ),
                ),
                /////////////////////
                ///  Bouton pour soumettre le formulaire
                /// //////////////////////
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Soumettre",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(fontSize: 20),
                      ),
                      onPressed: () {
                        if (fromKey.currentState!.validate()) {
                          if (mesProduit!.isNotEmpty) {
                            markAddBl().then((val) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: green,
                                  duration: Duration(seconds: 2),
                                  content: Text(
                                    val["message"],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: styleG,
                                  ),
                                ),
                              );
                            });
                            // Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Ajouter un produit et réessayer',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.redAccent,
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
        ),
      ),
    );
  }
}
