// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, must_be_immutable, dead_code

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/DetailLivraison.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Models/StationBL.dart';
import 'package:sygeq/Models/Ville.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateBL extends StatefulWidget {
  var data;
  Depot depot;
  Marketer marketer;
  Camion camion;
  StationBl station;
  Driver driver;

  List<DetailLivraison> listDetailLivraison = [];
  UpdateBL({
    Key? key,
    required this.data,
    required this.listDetailLivraison,
    required this.camion,
    required this.depot,
    required this.driver,
    required this.marketer,
    required this.station,
  }) : super(key: key);

  @override
  State<UpdateBL> createState() => _UpdateBLState();
}

class _UpdateBLState extends State<UpdateBL> {
  final fromKey = GlobalKey<FormState>();
  final fromKey1 = GlobalKey<FormState>();
  final fromKey2 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List? mesProduit = [];
  String prod = "";
  String qt = "";
  int capacity = 0;
  int lastCapacity = 0;
  int lastFilling = 0;
  String txtProduct = 'Dog';
  List<Driver> listMarkTransporteurC = [];
  List<Compartiment>? listCompartomentCamion = [];
  String nonProduit = '';
  bool isExpand = false;
  // int filling = 0;
  List<Produit> productList = [];
  List<Depot> depList = [];
  List<Camion> listCar = [];
  markUpdateBl() async {
    var data = await MarketerRemoteService.markUpdateBL(
      widget.data['id'],
      idDepot,
      idStation,
      // idTransporteur,
      idCamion,
      mesProduit!,
      prefUserInfo['idUser'].toString(),
      widget.data['numBL'],
    );
    return data;

    // return ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    //     ),
    //     // backgroundColor: Colors.white,
    //     duration: Duration(seconds: 3),
    //     content: Text(
    //       data['massage'],
    //       overflow: TextOverflow.ellipsis,
    //       softWrap: true,
    //       maxLines: 2,
    //       textAlign: TextAlign.center,
    //       style: GoogleFonts.montserrat(color: red),
    //     ),
    //   ),
    // );
  }

  marketerGetStation() async {
    var data = await RemoteServices.allGetListeStation();
    // if (!mounted) return null;
    setState(() {
      listMarkStation = data;
    });
    return data;
  }

  _addProduit() {
    for (int i = 0; mesProduit!.length > i; i++) {
      // var list = mesProduit![i].toString().split(';');
      // return Text("data");
      return Padding(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: Text(
                mesProduit![i].toString().split(';')[2],
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                style: styleG,
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                mesProduit![i].toString().split(';')[1],
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                style: styleG,
              ),
            ),
          ],
        ),
      );
    }
  }

  getDep() async {
    var data = await RemoteServices.allGetListedepot();
    setState(() {
      depList = data;
    });
    return data;
  }

  driverCas() async {
    var data = await RemoteServices.allGetListeCamions();
    setState(() {
      listCar = data;
    });

    return data;
  }

  marketerGetTransporteurC() async {
    var data = await RemoteServices.allGetListeTransporteurC();
    // if (!mounted) return null;
    setState(() {
      listMarkTransporteurC = data;
    });
    return data;
  }

  getProduct() async {
    var data = await RemoteServices.allGetListeProduits();
    setState(() {
      productList = data;
    });
    return productList;
  }

  String txtStation = "";
  String idStation = "";
  String txtTransporteur = "";
  String idTransporteur = "";
  String txtCamion = "";
  String idCamion = "";
  String txtDepot = "";
  String idDepot = "";
  @override
  void initState() {
    listMarkStation.removeWhere((element) => element.id == 0);
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
    capacity = widget.camion.capacity;
    driverCas();
    getProduct();
    getDep();
    listCompartomentCamion = widget.camion.vannes;
    txtStation = widget.station.nom;
    idStation = widget.station.id.toString();
    // txtTransporteur = widget.driver.nom;
    // idTransporteur = widget.driver.id.toString();
    txtCamion = widget.camion.imat;
    idCamion = widget.camion.id.toString();
    txtDepot = widget.depot.nom;
    idDepot = widget.depot.id.toString();
    for (var element in widget.listDetailLivraison) {
      mesProduit!.add(
        "${element.produit.id};${element.qtte};${element.produit.nom}",
      );
    }
    _addProduit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Modification du BL",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
          style: styleAppBar,
        ),
      ),
      // backgroundColor: gryClaie,
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
                    style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    // right: 20,
                    // left: 20,
                  ),
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
                                idDepot = depList[index].id.toString();
                              });
                            },
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            selectedItem: txtDepot,
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
                                idStation =
                                    listMarkStation[index].id.toString();
                              });
                            },
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            selectedItem: txtStation,
                            // isFilteredOnline: true,
                            // showSearchBox: true,
                            // showSelectedItems: true,
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
                          padding: const EdgeInsets.only(top: 10),
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
                                idCamion = listCar[index].id.toString();
                                listCompartomentCamion = listCar[index].vannes;
                                capacity = listCar[index].capacity;
                                // filling = filling - lastCapacity;
                                // filling = listCar[index].filling_level +
                                //     filling;
                                // lastCapacity =
                                //     listCar[index].filling_level;
                              });
                            },
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            selectedItem: txtCamion,
                            // isFilteredOnline: true,
                            // showSearchBox: true,
                            // showSelectedItems: true,
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
                                      'Informations sur le camion',
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
                                                0.15
                                            : MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.15,
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
                                            setState(() {
                                              prod =
                                                  mesProduit![i]
                                                      .toString()
                                                      .split(';')[0];
                                              txtProduct =
                                                  mesProduit![i]
                                                      .toString()
                                                      .split(';')[2];
                                              qt =
                                                  mesProduit![i]
                                                      .toString()
                                                      .split(';')[1];
                                            });
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  insetPadding: EdgeInsets.all(
                                                    0,
                                                  ),
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
                                                          DropdownSearch<
                                                            String
                                                          >(
                                                            popupProps:
                                                                PopupProps.menu(
                                                                  showSearchBox:
                                                                      true,
                                                                  fit:
                                                                      FlexFit
                                                                          .loose,
                                                                ),
                                                            items:
                                                                productList
                                                                    .map(
                                                                      (e) =>
                                                                          e.nom,
                                                                    )
                                                                    .toList(),
                                                            validator:
                                                                (value) =>
                                                                    value ==
                                                                            null
                                                                        ? 'Choisissez le produit'
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
                                                                              .nom ==
                                                                          newValue!,
                                                                    );
                                                                txtProduct =
                                                                    newValue!;
                                                                prod =
                                                                    productList[index]
                                                                        .id
                                                                        .toString();
                                                              });
                                                            },
                                                            selectedItem:
                                                                txtProduct,
                                                            dropdownDecoratorProps:
                                                                DropDownDecoratorProps(
                                                                  dropdownSearchDecoration:
                                                                      InputDecoration(
                                                                        hintText:
                                                                            'Produit',
                                                                      ),
                                                                ),
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
                                                            child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    blue,
                                                              ),
                                                              child: Text(
                                                                'Ajouter',
                                                                style: styleG,
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
                                                                    // filling = filling +
                                                                    //     int.parse(
                                                                    //         qt) -
                                                                    //     lastFilling;
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
                                            // setState(() {
                                            //   filling = filling -
                                            //       int.parse(mesProduit![i]
                                            //           .toString()
                                            //           .split(';')[1]);
                                            // });
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
                                onPressed:
                                    txtCamion.isEmpty
                                        ? () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.white,
                                              duration: Duration(seconds: 5),
                                              content: Text(
                                                "Veuillez selectionner un camion",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        : (() {
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
                                                    key: fromKey2,
                                                    child: Column(
                                                      children: [
                                                        DropdownButtonFormField<
                                                          String
                                                        >(
                                                          isExpanded: true,
                                                          hint: Text(
                                                            "Produit",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: true,
                                                            maxLines: 1,
                                                            style:
                                                                GoogleFonts.montserrat(
                                                                  color: green,
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
                                                                        element
                                                                            .id
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
                                                              productList.map((
                                                                product,
                                                              ) {
                                                                return DropdownMenuItem<
                                                                  String
                                                                >(
                                                                  value:
                                                                      product.id
                                                                          .toString(),
                                                                  child: Text(
                                                                    product.nom,
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
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
                                                                selectAll:
                                                                    false,
                                                              ),
                                                          decoration: InputDecoration(
                                                            label: Text(
                                                              "Quantité",
                                                              style:
                                                                  GoogleFonts.montserrat(
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
                                                            style:
                                                                TextButton.styleFrom(
                                                                  backgroundColor:
                                                                      blue,
                                                                ),
                                                            child: Text(
                                                              'Ajouter',
                                                              style: GoogleFonts.montserrat(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              softWrap: true,
                                                            ),
                                                            onPressed: () {
                                                              var _proqt = "";
                                                              if (fromKey2
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() {
                                                                  // filling =
                                                                  //     filling +
                                                                  //         int.parse(qt);
                                                                  _proqt =
                                                                      "$prod;$qt;$txtProduct";
                                                                  mesProduit!
                                                                      .add(
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
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                      style: GoogleFonts.montserrat(
                                                                        color:
                                                                            Colors.redAccent,
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
                                  backgroundColor:
                                      mesProduit!.isEmpty
                                          ? Color.fromARGB(255, 211, 205, 205)
                                          : txtCamion.isEmpty
                                          ? Color.fromARGB(255, 211, 205, 205)
                                          : blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.add,
                                  size: 20,
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
                      ],
                    ),
                  ),
                ),
                /////////////////////
                ///  Bouton pour soumettre le formulaire
                /// //////////////////////
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            mesProduit!.isEmpty
                                ? Color.fromARGB(255, 211, 205, 205)
                                : txtCamion.isEmpty
                                ? Color.fromARGB(255, 211, 205, 205)
                                : blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
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
                      onPressed:
                          mesProduit!.isEmpty
                              ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    // backgroundColor: Colors.white,
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      "Ajouter un produit et réessayer",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(color: red),
                                    ),
                                  ),
                                );
                              }
                              : () {
                                if (fromKey.currentState!.validate()) {
                                  int total = 0;
                                  for (var element in mesProduit!) {
                                    total =
                                        total +
                                        int.parse(
                                          element.toString().split(';')[1],
                                        );
                                  }
                                  if (total > capacity) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                          ),
                                        ),
                                        backgroundColor: red,
                                        duration: Duration(seconds: 5),
                                        content: Text(
                                          "Le camion ne peux pas transporter cette quantité de produit",
                                          textAlign: TextAlign.center,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: styleG,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // if (mesProduit!.isNotEmpty) {
                                    markUpdateBl();
                                    Navigator.pop(context);
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
