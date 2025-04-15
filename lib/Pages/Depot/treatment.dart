// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, must_be_immutable, unused_field, unused_local_variable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Models/TotalModel.dart';
import 'package:sygeq/Pages/Depot/ValidationBC.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';

List? finaL = [];

class Traitement extends StatefulWidget {
  Produit listprodu;
  int car;
  int qte;
  int position;
  int id;
  String imat;
  Traitement({
    Key? key,
    required this.listprodu,
    required this.car,
    required this.qte,
    required this.position,
    required this.id,
    required this.imat,
  }) : super(key: key);

  @override
  State<Traitement> createState() => _TraitementState();
}

class _TraitementState extends State<Traitement> {
  String valu = "";
  String barcode = "Inconnu";
  bool scaffoldStatut = false;
  bool _animate = true;
  Future<void> startBarcodeScanStream(int po) async {
    try {
      // final barcode = await FlutterBarcodeScanner.scanBarcode(
      //     '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // if (!mounted) return;
      // setState(() {
      //   this.barcode = barcode;
      //   listcod!.removeAt(po);
      //   listcod!.insert(po, barcode);
      // });
    } on PlatformException {}
  }

  List<Compartiment> c = [];
  List<Compartiment> debL = [];
  List<Compartiment> allCompartiment = [];

  int qte = 0;
  //liste des id de compartiments  selectionner
  List? listcom = [];
  //liste des capacitédes compartiments selctionnées
  List? listcap = [];
  //liste des codes barre ou code sur les celés
  List? listcod = [];
  List? listpro = [];
  List? listg = [];

  List? ctrl = [];
  int controlqt = 0;
  bool visibleqt = false;
  bool isExpand = false;
  getCompartiement() async {
    var data = await RemoteServices.getOneCompartiment(widget.car);
    setState(() {
      allCompartiment = data;
      debL = data;
    });
    if (finaL!.isNotEmpty) {
      for (int n = 0; finaL!.length > n; n++) {
        debL.removeWhere((element) => element.numero == finaL![n]);
      }
    }
    setState(() {
      c = debL;
    });
    return {allCompartiment, c};
  }

  _getCompartiment() {
    if (finaL!.isNotEmpty) {
      for (int n = 0; finaL!.length > n; n++) {
        debL.removeWhere((element) => element.numero == finaL![n]);
      }
    }
    setState(() {
      c = debL;
    });
  }

  alertBlCharge(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: blue,
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
    setState(() {
      scaffoldStatut == false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCompartiement();
  }

  @override
  void dispose() {
    super.dispose();
    allCompartiment.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Ajout des codes barre",
          softWrap: true,
          style: styleAppBar,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(bottom: 50),
          decoration: logoDecoration(),
          child: Column(
            children: [
              HeaderMic(),
              Padding(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Text(
                  widget.listprodu.nom,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: styleG,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            'Informations sur le camion',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                      isExpanded: isExpand,
                      body: ListTile(
                        title: Text(
                          'Camion :   ' + widget.imat,
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
                                allCompartiment.length > i;
                                i++
                              ) ...[
                                if (allCompartiment[i].isBusy == 0) ...[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 2,
                                      bottom: 2,
                                      left: 10,
                                    ),
                                    child: Text(
                                      "N°${i + 1} - ${allCompartiment[i].numero} - capacité ${allCompartiment[i].capacite}",
                                      textScaleFactor: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Text(
                  "Affectation des compartiments",
                  maxLines: 1,
                  softWrap: true,
                  style: styleG,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        "$controlqt / ${widget.qte}",
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color:
                              controlqt == widget.qte
                                  ? green
                                  : controlqt > widget.qte
                                  ? red
                                  : blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              for (int m = 0; listcom!.length > m; m++)
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          right: 10,
                          child: GestureDetector(
                            onTap: () async {
                              if (listcom![m] != '') {
                                for (var element in allCompartiment) {}
                                int index = allCompartiment.indexWhere(
                                  (element) =>
                                      element.id.toString() == listcom![m],
                                );
                                var _compartiment = setState(() {
                                  c.add(allCompartiment[index]);
                                });
                              }
                              setState(() {
                                if (listcap![m] != '') {
                                  controlqt =
                                      controlqt - int.parse(listcap![m]);
                                }
                                // for (int x = 0; listcap!.length > x; x++) {
                                // }
                                listcod!.removeAt(m);
                                listcap!.removeAt(m);
                                listcom!.removeAt(m);
                                ctrl!.removeAt(m);
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              child: Icon(Icons.close, size: 35, color: red),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right: 10,
                                  left: 10,
                                ),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                  ),
                                  items:
                                      c.isEmpty
                                          ? []
                                          : c.map((e) => e.numero).toList(),
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Choisissez le compartiment'
                                              : null,
                                  onChanged: (String? newValue) async {
                                    await getCompartiement();

                                    setState(() {
                                      // c.removeWhere((element) => false) = c.remove(listcom) as List<Compartiment>;

                                      int index = c.indexWhere(
                                        (element) =>
                                            element.numero.toString() ==
                                            newValue.toString(),
                                      );
                                      ctrl![m] = newValue;
                                      // c = c;
                                      listcap!.removeAt(m);
                                      listcap!.insert(
                                        m,
                                        c[index].capacite.toString(),
                                      );
                                      listcom!.removeAt(m);
                                      listcom!.insert(
                                        m,
                                        c[index].id.toString(),
                                      );
                                      controlqt = 0;
                                      if (listcom!.isNotEmpty) {
                                        for (
                                          int r = 0;
                                          listcom!.length > r;
                                          r++
                                        ) {
                                          c.removeWhere(
                                            (element) =>
                                                element.id.toString() ==
                                                listcom![r],
                                          );
                                        }
                                      }

                                      for (
                                        int x = 0;
                                        listcap!.length > x;
                                        x++
                                      ) {
                                        controlqt =
                                            controlqt + int.parse(listcap![x]);
                                      }

                                      if (controlqt > widget.qte) {
                                        setState(() {
                                          visibleqt = true;
                                        });
                                      } else {
                                        setState(() {
                                          visibleqt = false;
                                        });
                                      }
                                    });
                                  },
                                  // popupItemDisabled: (String s) => s.startsWith('I'),
                                  // isFilteredOnline: true,
                                  // showSearchBox: true,
                                  // showSelectedItems: true,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: 'Compartiment',
                                              hintStyle:
                                                  GoogleFonts.montserrat(),
                                            ),
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  right: 10,
                                  left: 10,
                                ),
                                child: Text(
                                  "Quantité: ${listcap![m]}",
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10, left: 10),
                                child: Divider(color: Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right: 10,
                                  left: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      // flex: 1,
                                      child: SizedBox(
                                        height:
                                            _size.height < _size.width
                                                ? _size.width / 12
                                                : _size.height / 12,
                                        child: TextFormField(
                                          style: TextStyle(),
                                          onChanged: (value) {
                                            setState(() {
                                              listcod!.removeAt(m);
                                              listcod!.insert(m, value);
                                            });
                                          },
                                          validator: (value) {
                                            return value!.length < 4
                                                ? "La Valeur est incorrecte"
                                                : null;
                                          },
                                          toolbarOptions: ToolbarOptions(
                                            paste: false,
                                          ),
                                          keyboardType: TextInputType.number,
                                          maxLength: 10,
                                          decoration: InputDecoration(
                                            // fillColor: Colors.white,
                                            label: Text(
                                              "Code Barre",
                                              textScaleFactor: 1,
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: visibleqt,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 0,
                                    right: 20,
                                    bottom: 5,
                                    left: 20,
                                  ),
                                  child: Text(
                                    "Ce compartiment du camion ne peut pas contenir le produit",
                                    textScaleFactor: 0.8,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: GoogleFonts.montserrat(color: red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30),
        child:
            controlqt != widget.qte
                ? Padding(
                  padding: EdgeInsets.only(right: _size.width / 2.50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: blue,
                      shape: BoxShape.rectangle,
                    ),
                    child: TextButton(
                      onPressed: () {
                        var _statut = false;
                        for (var element in listcod!) {
                          if (element == '') {
                            _statut = true;
                          }
                        }
                        if (_statut == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.white,
                              behavior: SnackBarBehavior.floating,
                              padding: EdgeInsets.only(
                                right: 15,
                                left: 15,
                                bottom: 10,
                              ),
                              duration: Duration(seconds: 5),
                              shape: RoundedRectangleBorder(
                                // borderRadius: BorderRadius.all(
                                // Radius.circular(20),
                                // ),
                              ),
                              content: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Entre le code barre",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            listcod!.add('');
                            listcap!.add('');
                            listcom!.add("");
                            ctrl!.add("");
                          });
                        }
                      },
                      child: Text(
                        "Ajouter",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                )
                : SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    backgroundColor:
                        controlqt != widget.qte ? Colors.grey[400] : blue,
                    onPressed:
                        controlqt != widget.qte
                            ? null
                            : () async {
                              var _statut = false;
                              for (var element in listcod!) {
                                if (element == '') {
                                  _statut = true;
                                }
                              }
                              if (_statut == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white,
                                    behavior: SnackBarBehavior.floating,
                                    padding: EdgeInsets.only(
                                      right: 15,
                                      left: 15,
                                      bottom: 10,
                                    ),
                                    duration: Duration(seconds: 5),
                                    shape: RoundedRectangleBorder(
                                      // borderRadius: BorderRadius.all(
                                      // Radius.circular(20),
                                      // ),
                                    ),
                                    content: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Entre le code barre",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                bool verifCode = true;
                                for (var element in listcod!) {
                                  if (element.toString().isEmpty) {
                                    setState(() {
                                      verifCode == false;
                                    });
                                  }
                                }
                                if (verifCode == false) {
                                  setState(() {
                                    scaffoldStatut == true;
                                  });
                                  alertBlCharge(
                                    "Veuillez jouter les codes barre aux compartiments",
                                  );
                                  setState(() {
                                    scaffoldStatut == false;
                                  });
                                } else {
                                  for (int l = 0; ctrl!.length > l; l++) {
                                    finaL!.add(ctrl![l]);
                                  }
                                  var test;
                                  for (int va = 0; listcap!.length > va; va++) {
                                    setState(() {
                                      total!.add(
                                        TotalModel(
                                          blId: widget.id.toString(),
                                          compartimenId:
                                              listcom![va].toString(),
                                          qty: listcap![va].toString(),
                                          barreCode: listcod![va].toString(),
                                        ),
                                      );
                                    });
                                  }
                                  listcom!.clear();
                                  listcap!.clear();
                                  listcod!.clear();
                                  setState(() {});
                                  Navigator.pop(context);
                                }
                              }
                            },
                    label: Text(
                      'Valider',
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
