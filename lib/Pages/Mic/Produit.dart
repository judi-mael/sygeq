// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailProduit.dart';

import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class Produits extends StatefulWidget {
  const Produits({Key? key}) : super(key: key);

  @override
  State<Produits> createState() => _ProduitsState();
}

class _ProduitsState extends State<Produits> {
  final formKey = GlobalKey<FormState>();
  List<Produit> listProduit = [];
  late TextEditingController txtNom, txtType, txtCode, txtUnite;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _animate = true;
  micAddProduct() async {
    var data = RemoteServiceMic.micAddProduit(
      txtNom.text.toString().trim(),
      txtCode.text.toString().trim(),
      txtType.text.toString().trim(),
      txtUnite.text.toString().trim(),
    );
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetProduit);
  }

  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'produits');
    return data;
  }

  //////////////////////////////////
  ///////////// get all produit //////////
  /// ////////////////////
  micGetProduit() async {
    var res = await RemoteServices.allGetListeProduits();
    // if (!mounted) return null;
    setState(() {
      listProduit = res;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return listProduit;
  }

  actionOnTheProduit(var data) {
    showDialog(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                insetPadding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: DetailProduit(data: data),
                ),
              ),
            );
          },
        )
        .then((value) {
          setState(() async {
            await micGetProduit();
          });
        })
        .then((value) {
          setState(() async {
            await micGetProduit();
          });
        });
  }

  @override
  void initState() {
    super.initState();
    micGetProduit();
    txtCode = TextEditingController();
    txtNom = TextEditingController();
    txtType = TextEditingController();
    txtUnite = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "produits",
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 1,
          style: styleAppBar,
        ),
      ),
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listProduit.isEmpty
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
                            micGetProduit();
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
                : RefreshIndicator(
                  key: refreshKey,
                  onRefresh: refresh,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 5,
                              right: 5,
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0,
                                    childAspectRatio:
                                        _size.height < _size.width
                                            ? MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.height /
                                                    2)
                                            : MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.height /
                                                    4),
                                  ),
                              scrollDirection: Axis.vertical,
                              itemCount: listProduit.length,
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    var data = {
                                      'nom': listProduit[index].nom,
                                      'type': listProduit[index].type,
                                      'code': listProduit[index].hscode,
                                      'delete': listProduit[index].deletedAt,
                                      'id': listProduit[index].id,
                                    };
                                    actionOnTheProduit(data);
                                  },
                                  child: Card(
                                    semanticContainer: true,
                                    color:
                                        listProduit[index].deletedAt != ''
                                            ? cardColorred
                                            : Colors.white.withOpacity(0.7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Expanded(child: SizedBox(height: 10)),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              listProduit[index].nom,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: styleG,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text('Type: '),
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  listProduit[index].type,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: styleG,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // child: ListView.builder(
                            //   itemCount: listProduit.length,
                            //   shrinkWrap: true,
                            //   scrollDirection: Axis.vertical,
                            //   itemBuilder: (context, index) {
                            // return GestureDetector(
                            //   onTap: () {
                            //     var data = {
                            //       'nom': listProduit[index].nom,
                            //       'type': listProduit[index].type,
                            //       'code': listProduit[index].hscode,
                            //       'delete': listProduit[index].deletedAt,
                            //       'id': listProduit[index].id,
                            //     };
                            //     actionOnTheProduit(data);
                            //     // Navigator.push(
                            //     //         context,
                            //     //         MaterialPageRoute(
                            //     //             builder: (context) =>
                            //     //                 DetailProduit(data: data)))
                            //     //     .then((value) => micGetProduit());
                            //   },
                            //   child: Card(
                            //     color: listProduit[index].deletedAt != ''
                            //         ? cardColorred
                            //         : null,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: Padding(
                            //       padding: EdgeInsets.all(5),
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Flexible(
                            //             flex: 2,
                            //             child: Text(
                            //               listProduit[index].nom,
                            //               softWrap: true,
                            //               overflow: TextOverflow.ellipsis,
                            //               style: styleG,
                            //               maxLines: 2,
                            //             ),
                            //           ),
                            //           Flexible(
                            //             flex: 2,
                            //             child: Text(
                            //               listProduit[index].type,
                            //               softWrap: true,
                            //               overflow: TextOverflow.ellipsis,
                            //               style: styleG,
                            //               maxLines: 1,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // );
                            //   },
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  insetPadding: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: createProduct(),
                  ),
                ),
              );
            },
          ).then((value) {
            setState(() async {
              await micGetProduit();
            });
          });

          // Navigator.push(context,
          //         MaterialPageRoute(builder: ((context) => createProduct())))
          //     .then((value) => micGetProduit());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget createProduct() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(),
            child: Column(
              children: [
                Text(
                  "Ajouter un produit",
                  textScaleFactor: 1,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styleG,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    onChanged: (value) {
                      txtNom.text = value;
                    },
                    validator: (value) {
                      return value!.isEmpty
                          ? "Ce champs est obligatoire"
                          : null;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      label: Text(
                        "Produit",
                        softWrap: true,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: styleG,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                    ),
                    items: ['L', 'Kg'],
                    validator:
                        (value) =>
                            value == null
                                ? 'Choisissez l\'unité de mésures'
                                : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        // dropdownValue = newValue!;
                        txtUnite.text = newValue!;
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Unité de mésure',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    onChanged: (value) {
                      txtCode.text = value;
                    },
                    validator: (value) {
                      return value!.isEmpty
                          ? "Ce champs est obligatoire"
                          : null;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      label: Text(
                        "Code produit",
                        softWrap: true,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: styleG,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                    ),
                    items: ['Péréqué', 'Non Péréqué'],
                    validator:
                        (value) =>
                            value == null
                                ? 'Choisissez le type de produits'
                                : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        // dropdownValue = newValue!;
                        txtType.text = newValue!;
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Type de produits',
                      ),
                    ),
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.only(
                //     top: 20,
                //   ),
                //   child: TextFormField(
                //     onChanged: (value) {
                //       txtType.text = value;
                //     },
                //     validator: (value) {
                //       return value!.isEmpty
                //           ? "Ce champs est obligatoire"
                //           : null;
                //     },
                //     maxLines: 1,
                //     keyboardType: TextInputType.name,
                //     decoration: InputDecoration(
                //       label: Text(
                //         "Type",
                //         softWrap: true,
                //         textScaleFactor: 1,
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 1,
                //         style: styleG,
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Annuler",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: btnTxtCOlor,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              micAddProduct().then((val) {
                                fToast.showToast(
                                  child: toastWidget(val['message']),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 5),
                                );
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Enregistrer",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: btnTxtCOlor,
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
      ),
    );
  }
}
