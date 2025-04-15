// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Contrart.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class TransMarkContrat extends StatefulWidget {
  const TransMarkContrat({Key? key}) : super(key: key);

  @override
  State<TransMarkContrat> createState() => _TransMarkContratState();
}

class _TransMarkContratState extends State<TransMarkContrat> {
  final formKey = GlobalKey<FormState>();
  List<Contrat> listContrat = [];
  String id = "";
  bool _animate = true;
  markAddContrat() async {
    var data = await MarketerRemoteService.markAddContrat(id);
    return data;
  }

  markGetContrat() async {
    var data = await MarketerRemoteService.allGetContrat();
    setState(() {
      listContrat = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    markGetContrat();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        centerTitle: true,
        title: Text(
          "Mes contrats",
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleG,
        ),
      ),
      backgroundColor: gryClaie,
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listContrat.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyList(),
                      EmptyMessage(),
                      TextButton.icon(
                        style: TextButton.styleFrom(backgroundColor: blue),
                        onPressed: () {
                          setState(() {
                            markGetContrat();
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
                : Column(
                  children: [
                    HeaderMic(),
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: Text(
                        "Liste de mes transporteur",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleG,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: listContrat.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  right: 10,
                                  left: 10,
                                ),
                                child: Row(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      borderOnForeground: false,
                                      color: Color.fromARGB(255, 178, 194, 202),
                                      child: Icon(Icons.handshake, size: 60),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    "Tansporteur : ",
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: styleG,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 3,
                                                  child: Text(
                                                    "${listContrat[index].driver.nom}",
                                                    textAlign: TextAlign.center,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    "Agrement : ",
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: styleG,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 4,
                                                  child: Text(
                                                    "${listContrat[index].driver.agrement}",
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    // style: styleG,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    "Autorisation  :",
                                                    softWrap: true,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: styleG,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 3,
                                                  child: Text(
                                                    " du ${DateFormat('dd MMM yyyy').format(DateTime.parse(listContrat[index].driver.dateVigeur))} au ${DateFormat('dd MMM yyyy').format(DateTime.parse(listContrat[index].driver.dateExp))}",
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                // scrollable: true,
                child: Container(child: createContart()),
              );
            },
          ).then((value) {
            setState(() async {
              await markGetContrat();
            });
          });

          // Navigator.push(context,
          //         MaterialPageRoute(builder: ((context) => createContart())))
          //     .then((value) => markGetContrat());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget createContart() {
    // bool obscure = true;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // HeaderMic(),
              Text(
                "Nouveau contrat",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: styleG,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  // left: 20,
                  // right: 20,
                ),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    fit: FlexFit.loose,
                  ),
                  items:
                      listMarkTransporteurNC.isEmpty
                          ? []
                          : listMarkTransporteurNC.map((e) => e.nom).toList(),
                  validator:
                      (value) =>
                          value == null ? 'Choisissez le transporteur' : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      int index = listMarkTransporteurNC.indexWhere(
                        (element) => element.nom == newValue.toString(),
                      );
                      id = listMarkTransporteurNC[index].id.toString();
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
                padding: EdgeInsets.only(
                  top: 30,
                  // left: 20,
                  // right: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Annuler",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleG,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Enregistrer",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleG,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            markAddContrat().then((val) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: green,
                                  duration: Duration(seconds: 2),
                                  content: Text(
                                    val["message"],
                                    style: styleG,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                ),
                              );
                            });
                            Navigator.pop(context);
                          } else {}
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
