// ignore_for_file: prefer_const_constructors, deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/TotalModel.dart';
import 'package:sygeq/Pages/Depot/DetailBC.dart';
import 'package:sygeq/Pages/Depot/ValidationBC.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/DefaultToas.dart';

class RepartCompartiment extends StatefulWidget {
  var blDetail;
  var list;
  RepartCompartiment({super.key, required this.blDetail, required this.list});

  @override
  State<RepartCompartiment> createState() => _RepartCompartimentState();
}

class _RepartCompartimentState extends State<RepartCompartiment> {
  final formKey = GlobalKey<FormState>();
  int qtteCharge = 0;
  bool _retour = false;
  List specialListCompId = [];
  List<TotalModel> listPreChargement = [];
  late TextEditingController txtBarcode, txtCreuxCharger;
  @override
  void initState() {
    super.initState();
    txtBarcode = TextEditingController();
    txtCreuxCharger = TextEditingController();
  }

  updateCompartimentToBL(detailCompartiment, int psition, int dl_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Compartiment : " + detailCompartiment.numero,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          color: blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Modifier les informations du chargement",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          color: blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Icon(Icons.web_asset, color: blue),
                        ),
                        Flexible(
                          flex: 2,
                          child: Text(
                            "${detailCompartiment.capacite} L",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(color: blue),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 5, color: Colors.black),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtBarcode,
                        style: TextStyle(),
                        validator: (value) {
                          return value!.length < 4
                              ? "La Valeur est incorrecte"
                              : null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        toolbarOptions: ToolbarOptions(paste: false),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtCreuxCharger,
                        style: TextStyle(),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          return value!.length < 1
                              ? "La Valeur est incorrecte"
                              : null;
                        },
                        toolbarOptions: ToolbarOptions(paste: false),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          // fillColor: Colors.white,
                          label: Text(
                            "Creux chargé",
                            textScaleFactor: 1,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              var data = TotalModel(
                                blId: dl_id.toString(),
                                compartimenId: detailCompartiment.id.toString(),
                                qty: detailCompartiment.capacite.toString(),
                                barreCode: txtBarcode.text.trim(),
                                creuxCharger: txtCreuxCharger.text.trim(),
                              );
                              setState(() {
                                listPreChargement[psition] = data;
                              });
                              setState(() {
                                txtBarcode.clear();
                                txtCreuxCharger.clear();
                              });
                              Navigator.pop(context, true);
                            }

                            // Navigator.of(context).pop();

                            // Navigator.pop(context, true);
                            setState(() {});
                          },
                          style: TextButton.styleFrom(backgroundColor: blue),
                          child: Text(
                            "Modifier",
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
      setState(() {});
    });
  }

  addCompartimentToBL(detailCompartiment, int psition, int dl_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Compartiment : " + detailCompartiment.numero,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          color: blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Icon(Icons.web_asset, color: blue),
                        ),
                        Flexible(
                          flex: 2,
                          child: Text(
                            "${detailCompartiment.capacite} L",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(color: blue),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 5, color: Colors.black),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtBarcode,
                        style: TextStyle(),
                        validator: (value) {
                          return value!.length < 4
                              ? "La Valeur est incorrecte"
                              : null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        toolbarOptions: ToolbarOptions(paste: false),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: txtCreuxCharger,
                        style: TextStyle(),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          return value!.length < 1
                              ? "La Valeur est incorrecte"
                              : null;
                        },
                        toolbarOptions: ToolbarOptions(paste: false),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          // fillColor: Colors.white,
                          label: Text(
                            "Creux chargé",
                            textScaleFactor: 1,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                qtteCharge =
                                    detailCompartiment.capacite + qtteCharge;
                                specialListCompId.add(detailCompartiment.id);
                              });
                              var data = TotalModel(
                                blId: dl_id.toString(),
                                compartimenId: detailCompartiment.id.toString(),
                                qty: detailCompartiment.capacite.toString(),
                                barreCode: txtBarcode.text.trim(),
                                creuxCharger: txtCreuxCharger.text.trim(),
                              );
                              setState(() {
                                listPreChargement.add(data);
                                // listTotalChargementBl.add(data);
                                listIdCompartiment.add(detailCompartiment.id);
                              });
                              setState(() {
                                txtBarcode.clear();
                                txtCreuxCharger.clear();
                              });
                              Navigator.pop(context, true);
                            }

                            // Navigator.of(context).pop();

                            // Navigator.pop(context, true);
                            setState(() {});
                          },
                          style: TextButton.styleFrom(backgroundColor: blue),
                          child: Text(
                            "Charger",
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
      setState(() {});
    });
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
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (qtteCharge == widget.blDetail.qtte) {
          return true;
          // return true;
        }
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
          iconTheme: IconThemeData(
            color: gryClaie, //change your color here
          ),
          title: Text(
            widget.blDetail.produit.nom,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styleAppBar,
          ),
        ),
        body: SafeArea(
          // physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.layers_outlined, color: blue),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Qtée du produit : ${widget.blDetail.qtte.toString() + " " + widget.blDetail.produit.unite}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.montserrat(color: blue),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "Qtée chargée : $qtteCharge L",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(color: blue),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 5, color: Colors.black),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    top: 10,
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 4,
                      childAspectRatio:
                          _size.height < _size.width
                              ? MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 7)
                              : MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 9),
                    ),
                    itemCount: widget.list.camion.vannes.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (qtteCharge +
                                  widget.list.camion.vannes[i].capacite <=
                              widget.blDetail.qtte) {
                            if (widget.list.camion.vannes[i].isBusy
                                    .toString() ==
                                '1') {
                              return fToast.showToast(
                                child: toastWidget(
                                  "Ce compartiment n'est plus disponible",
                                ),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 5),
                              );
                            } else if (listIdCompartiment.contains(
                              widget.list.camion.vannes[i].id,
                            )) {
                              int index = listPreChargement.indexWhere(
                                (element) =>
                                    element.compartimenId ==
                                    widget.list.camion.vannes[i].id.toString(),
                              );
                              setState(() {
                                txtBarcode.text =
                                    listPreChargement[index].barreCode;
                                txtCreuxCharger.text =
                                    listPreChargement[index].creuxCharger!;
                              });
                              updateCompartimentToBL(
                                widget.list.camion.vannes[i],
                                index,
                                widget.blDetail.id,
                              );
                            } else {
                              addCompartimentToBL(
                                widget.list.camion.vannes[i],
                                i,
                                widget.blDetail.id,
                              );
                            }
                          } else {
                            fToast.showToast(
                              child: toastWidget(
                                "La quantité du produit dépasse la capacité du compartiment choisi.",
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Colors.grey[300],
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(child: Icon(Icons.web_asset)),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    widget.list.camion.vannes[i].numero +
                                        " : " +
                                        widget.list.camion.vannes[i].capacite
                                            .toString() +
                                        " L ",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.montserrat(
                                      color:
                                          widget.list.camion.vannes[i].isBusy
                                                          .toString() ==
                                                      '1' ||
                                                  specialListCompId.contains(
                                                    widget
                                                        .list
                                                        .camion
                                                        .vannes[i]
                                                        .id,
                                                  ) ||
                                                  listCompid.contains(
                                                    widget
                                                        .list
                                                        .camion
                                                        .vannes[i]
                                                        .id,
                                                  )
                                              ? Colors.grey[400]
                                              : blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
        floatingActionButton:
            widget.blDetail.qtte == qtteCharge
                ? Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      backgroundColor: blue,
                      onPressed:
                          widget.blDetail.qtte == qtteCharge
                              ? () {
                                for (var element in specialListCompId) {
                                  setState(() {
                                    listCompid.add(element);
                                  });
                                }
                                for (var element in listPreChargement) {
                                  setState(() {
                                    listTotalChargementBl.add(element);
                                  });
                                }
                                setState(() {
                                  listIdProduit.add(widget.blDetail.produit.id);
                                  _retour = true;
                                });
                                Navigator.pop(context);
                              }
                              : () {
                                fToast.showToast(
                                  child: toastWidget(
                                    "Veuillez repartir le produit",
                                  ),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
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
                )
                : null,
      ),
    );
  }
}
