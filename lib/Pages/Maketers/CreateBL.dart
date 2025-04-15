// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_child_properties_last, deprecated_member_use, unnecessary_null_comparison, dead_code

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

List<Produit> productList = [];
List<Depot> depList = [];
List<Camion> listCar = [];

class CreateBL extends StatefulWidget {
  const CreateBL({Key? key}) : super(key: key);

  @override
  State<CreateBL> createState() => _CreateBLState();
}

class _CreateBLState extends State<CreateBL> {
  List? mesProduit = [];
  String prod = "";
  String qt = "";
  int capacity = 0;
  int lastCapacity = 0;
  int lastFilling = 0;
  bool isExpand = false;
  int filling = 0;
  List<Produit> productList = [];
  List<Depot> depList = [];
  List<Camion> listCar = [];
  int camionId = 0;
  List<Compartiment> listCompartiment = [];
  late TextEditingController txtStation, txtTransporteur, txtCamion, txtBl;
  final fromKey = GlobalKey<FormState>();
  final fromKey1 = GlobalKey<FormState>();
  final fromKey2 = GlobalKey<FormState>();
  String txtProduct = 'Dog';
  markAddBl() async {
    var data = await MarketerRemoteService.markAddBL(
      txtBl.text.toString().trim(),
      txtStation.text.toString().trim(),
      txtTransporteur.text.toString().trim(),
      txtCamion.text.toString().trim(),
      mesProduit!,
      prefUserInfo['idUser'].toString(),
    );
    return data;
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
    // if (!mounted) return null;
    setState(() {
      productList = data;
    });
    return productList;
  }

  driverCas(int id) async {
    var data = await RemoteServices.allGetDriverCamions(dd: id);
    List<Camion> listData = [];
    if (!mounted) return null;
    for (Camion element in data) {
      if (element.filling_level < element.capacity ||
          element.marketer_id.toString() == prefUserInfo['marketer_id'] ||
          element.marketer_id.toString() == null) {
        listData.add(element);
      } else {}
    }
    setState(() {
      listCar = listData;
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
    return data;
  }

  @override
  void initState() {
    super.initState();
    marketerGetStation();
    marketerGetTransporteurC();
    getProduct();
    _addProduit();
    getDep();
    txtStation = TextEditingController();
    txtCamion = TextEditingController();
    txtTransporteur = TextEditingController();
    txtBl = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Nouveau BL",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleAppBar,
        ),
      ),
      // backgroundColor: gryClaie,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
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
                  padding: EdgeInsets.only(top: 20),
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                    ),
                    items:
                        listMarkStation == null
                            ? []
                            : listMarkStation.map((e) => e.nomStation).toList(),
                    validator:
                        (value) =>
                            value == null ? 'Choisissez la Station' : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        int index = listMarkStation.indexWhere(
                          (element) =>
                              element.nomStation == newValue.toString(),
                        );
                        // dropdownValue = newValue!;
                        txtStation.text = listMarkStation[index].id.toString();
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
                              listMarkTransporteurC.isEmpty
                                  ? []
                                  : listMarkTransporteurC
                                      .map((e) => e.nom)
                                      .toList(),
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Choisissez le Transporteur'
                                      : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              int index = listMarkTransporteurC.indexWhere(
                                (element) => element.nom == newValue.toString(),
                              );
                              // dropdownValue = newValue!;
                              txtTransporteur.text =
                                  listMarkTransporteurC[index].id.toString();
                              if (listMarkTransporteurC[index].id != null) {
                                // setState(() {
                                camionId = listMarkTransporteurC[index].id;
                                // });
                                driverCas(listMarkTransporteurC[index].id);
                              }
                            });
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Transporteur',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: DropdownSearch<String>(
                          // enabled: txtTransporteur.text == '' ? false : true,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
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
                              txtCamion.text = listCar[index].id.toString();
                              listCompartiment = listCar[index].vannes;
                              capacity = listCar[index].capacity;
                              filling = filling - lastCapacity;
                              filling = listCar[index].filling_level + filling;
                              lastCapacity = listCar[index].filling_level;
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
                    ],
                  ),
                ),
                if (txtCamion.text != '')
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
                              title: Text('Informations sur le camion'),
                            );
                          },
                          isExpanded: isExpand,
                          body: ListTile(
                            title: Text(
                              'Capacité :   ' + capacity.toString(),
                              textScaleFactor: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Les compartiments',
                                      textScaleFactor: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                  // if (listCompartiment != null) ...[
                                  for (
                                    int i = 0;
                                    listCompartiment.length > i;
                                    i++
                                  ) ...[
                                    if (listCompartiment[i].isBusy == 0) ...[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 2,
                                          bottom: 2,
                                          left: 10,
                                        ),
                                        child: Text(
                                          "N°${i + 1} - ${listCompartiment[i].numero} - capacité ${listCompartiment[i].capacite}",
                                          textScaleFactor: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ],
                                  // ],
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'niveau de remplissage    :$filling',
                                      textScaleFactor: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Capacité disponible    : ${capacity - filling}",
                                      textScaleFactor: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
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
                  for (int i = 0; mesProduit!.length > i; i++) ...[
                    Container(
                      child: Row(
                        verticalDirection: VerticalDirection.down,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width:
                                _size.height > _size.width
                                    ? MediaQuery.of(context).size.width * 0.25
                                    : MediaQuery.of(context).size.width * 0.25,
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
                                    ? MediaQuery.of(context).size.width * 0.1
                                    : MediaQuery.of(context).size.width * 0.1,
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
                                      lastFilling = int.parse(
                                        mesProduit![i].toString().split(';')[1],
                                      );
                                      txtProduct =
                                          mesProduit![i].toString().split(
                                            ';',
                                          )[2];
                                    });

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
                                              key: fromKey1,
                                              child: Column(
                                                children: [
                                                  DropdownSearch<String>(
                                                    popupProps: PopupProps.menu(
                                                      showSearchBox: true,
                                                      fit: FlexFit.loose,
                                                    ),
                                                    items:
                                                        productList.isEmpty
                                                            ? []
                                                            : productList
                                                                .map(
                                                                  (e) => e.nom,
                                                                )
                                                                .toList(),
                                                    validator:
                                                        (value) =>
                                                            value == null
                                                                ? 'Choisissez le produit'
                                                                : null,
                                                    onChanged: (
                                                      String? newValue,
                                                    ) {
                                                      setState(() {
                                                        int index = productList
                                                            .indexWhere(
                                                              (element) =>
                                                                  element.nom ==
                                                                  newValue!,
                                                            );
                                                        txtProduct = newValue!;
                                                        prod =
                                                            productList[index]
                                                                .id
                                                                .toString();
                                                      });
                                                    },
                                                    selectedItem: txtProduct,
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
                                                            .split(';')[1],
                                                    toolbarOptions:
                                                        ToolbarOptions(
                                                          copy: false,
                                                          cut: false,
                                                          paste: false,
                                                          selectAll: false,
                                                        ),
                                                    maxLength: 10,
                                                    decoration: InputDecoration(
                                                      label: Text(
                                                        "Quantité",
                                                        style:
                                                            GoogleFonts.montserrat(
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
                                                            filling =
                                                                filling +
                                                                int.parse(qt) -
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
                                  icon: Icon(Icons.edit_sharp, color: blue),
                                ),
                                IconButton(
                                  onPressed: (() {
                                    setState(() {
                                      filling =
                                          filling -
                                          int.parse(
                                            mesProduit![i].toString().split(
                                              ';',
                                            )[1],
                                          );
                                    });
                                    mesProduit!.remove(mesProduit![i]);
                                    setState(() {});
                                  }),
                                  icon: Icon(Icons.cancel_rounded, color: red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            txtCamion.text.isEmpty
                                ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                : capacity <= filling
                                ? (() {
                                  fToast.showToast(
                                    child: toast,
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: Duration(seconds: 4),
                                  );
                                })
                                : (() {
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
                          backgroundColor:
                              capacity <= filling
                                  ? Colors.grey
                                  : txtCamion.text.isEmpty
                                  ? Colors.grey
                                  : blue,
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
                            style: GoogleFonts.montserrat(color: Colors.white),
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
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        backgroundColor:
                            mesProduit!.isEmpty ? Colors.grey : blue,
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
                              ? null
                              : capacity < filling
                              ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    // backgroundColor: green,
                                    duration: Duration(seconds: 5),
                                    content: Text(
                                      "Le camion ne peux pas transporter cette quantité de produits",
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      // style: styleG,
                                    ),
                                  ),
                                );
                              }
                              : () {
                                if (fromKey.currentState!.validate()) {
                                  if (mesProduit!.isNotEmpty) {
                                    markAddBl();
                                    // Navigator.pop(
                                    //   context,
                                    // );
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
        ),
        /////////////////////
        ///  Bouton pour soumettre le formulaire
        /// //////////////////////
      ),
    );
  }
}
