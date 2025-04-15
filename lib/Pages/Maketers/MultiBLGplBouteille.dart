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

class MultiBLGplBouteille extends StatefulWidget {
  bool? gazoil;
  MultiBLGplBouteille({Key? key, this.gazoil}) : super(key: key);

  @override
  State<MultiBLGplBouteille> createState() => _MultiBLGplBouteilleState();
}

class _MultiBLGplBouteilleState extends State<MultiBLGplBouteille> {
  int capacity = 0;
  List<Produit> productList = [];
  List<Depot> depList = [];
  List<Camion> listCar = [];
  int camionId = 0;
  List<Compartiment>? listCompartomentCamion = [];

  List<Compartiment> listCompartiment = [];
  late TextEditingController txtStation, txtCamion, txtBl, quantite, txtProduit;

  final fromKey2 = GlobalKey<FormState>();
  String imatCamion = '';
  bool _retour = false;
  markAddBl() async {
    print(
      "je suiuiiiiiiiiiiiiiiii ${txtStation.text.trim()} && ${txtBl.text.trim()}",
    );
    var data = await MarketerRemoteService.addBonGpl(
      '0',
      txtProduit.text.trim(),
      txtBl.text.trim(),
      txtCamion.text.trim(),
      quantite.text.trim(),
    );

    return data;
  }

  getProduct() async {
    var data = await RemoteServices.allGetListeProduits();
    // if (!mounted) return null;
    setState(() {
      productList = data;
    });
    productList = [
      Produit(
        unite:
            productList[productList.indexWhere(
                  (elts) => elts.nom.contains('BOUTEILLE'),
                )]
                .unite,
        id:
            productList[productList.indexWhere(
                  (elts) => elts.nom.contains('BOUTEILLE'),
                )]
                .id,
        nom:
            productList[productList.indexWhere(
                  (elts) => elts.nom.contains('BOUTEILLE'),
                )]
                .nom,
        deletedAt:
            productList[productList.indexWhere(
                  (elts) => elts.nom.contains('BOUTEILLE'),
                )]
                .deletedAt,
        type:
            productList[productList.indexWhere(
                  (elts) => elts.nom.contains('BOUTEILLE'),
                )]
                .type,
        etat:
            productList[productList.indexWhere(
                  (elts) => elts.nom.contains('BOUTEILLE'),
                )]
                .etat,
        hscode:
            productList[productList.indexWhere(
                  (elts) => elts.nom.contains('BOUTEILLE'),
                )]
                .hscode,
      ),
    ];
    txtBl.text = "0";
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
    txtProduit = TextEditingController();
    txtBl = TextEditingController();
    quantite = TextEditingController();
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
    // Size _size = MediaQuery.of(context).size;
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
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          iconTheme: IconThemeData(color: gryClaie),
          title: Text(
            "Création de BL",
            style: styleAppBar,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 10, left: 10),
              child: Form(
                key: fromKey2,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, right: 5, left: 5),
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
                                (element) => element.nom == newValue.toString(),
                              );
                              txtBl.text = depList[index].id.toString();
                            });
                          },
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
                                  value == null ? 'Choisissez le camion' : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              int index = listCar.indexWhere(
                                (element) =>
                                    element.imat == newValue.toString(),
                              );
                              imatCamion = listCar[index].imat;
                              txtCamion.text = listCar[index].id.toString();
                              listCompartomentCamion = listCar[index].vannes;
                              capacity = listCar[index].capacity;
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
                        padding: EdgeInsets.only(
                          top: 5,
                          left: 5,
                          right: 5,
                          bottom: 5,
                        ),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Produits',
                          ),

                          hint: Text(
                            "Produit",
                            style: GoogleFonts.montserrat(color: blue),
                          ),
                          // decoration: InputDecoration(),
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Choisissez un produit'
                                      : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              int index = productList.indexWhere(
                                (element) => element.id.toString() == newValue,
                              );
                              txtProduit.text =
                                  productList[index].id.toString();
                            });
                          },
                          items:
                              productList.isEmpty
                                  ? []
                                  : productList.map((product) {
                                    return DropdownMenuItem<String>(
                                      value: product.id.toString(),
                                      child: Text(
                                        product.nom,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: styleG,
                                      ),
                                    );
                                  }).toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                          left: 5,
                          right: 5,
                          bottom: 5,
                        ),
                        child: TextFormField(
                          toolbarOptions: ToolbarOptions(
                            copy: false,
                            cut: false,
                            paste: false,
                            selectAll: false,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'QUantités',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return value!.isEmpty ? 'Entré la quantité' : null;
                          },
                          onChanged: (value) {
                            quantite.text = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
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
                              if (fromKey2.currentState!.validate()) {
                                markAddBl();
                                Navigator.pop(context);
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
          ),
          /////////////////////
          ///  Bouton pour soumettre le formulaire
          /// //////////////////////
        ),
      ),
    );
  }
}
