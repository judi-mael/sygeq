// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/Ville.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailVille.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class Villes extends StatefulWidget {
  const Villes({Key? key}) : super(key: key);

  @override
  State<Villes> createState() => _VillesState();
}

class _VillesState extends State<Villes> {
  List<Ville> listVille = [];
  late TextEditingController txtVille, txtDifficult, txtPrime, txtDepartement;
  final formKey = GlobalKey<FormState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  // micAddVille(){
  //   var data = RemoteServiceMic.micAddVille(nom, dep, difficulte, prime)
  // }
  bool _animate = true;
  @override
  void initState() {
    super.initState();
    micGetVille();
    txtVille = TextEditingController();
    txtDepartement = TextEditingController();
    txtDifficult = TextEditingController();
    txtPrime = TextEditingController();
  }

  //////////////////////////////
  //////////// get all ville
  ///////////////////
  @override
  void dispose() {
    super.dispose();
  }

  actionOnTheVille(var data) {
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
              child: DetailVille(data: data),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await micGetVille();
      });
    });
  }

  micGetVille() async {
    var res = await RemoteServices.allGetListeVilles();
    // if (!mounted) return null;
    setState(() {
      listVille = res;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });

    return listVille;
  }

  micAddVille() async {
    var data = await RemoteServiceMic.micAddVille(
      txtVille.text.toString().trim(),
    );
    // txtDepartement.text.toString().trim(),
    // txtDifficult.text.toString().trim(),
    // txtPrime.text.toString().trim(),
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetVille);
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Villes",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styleAppBar,
        ),
      ),
      backgroundColor: gryClaie,
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listVille.isEmpty
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
                            micGetVille();
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
                      children: [
                        // HeaderMic(),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     top: 20,
                        //     left: 30,
                        //     right: 30,
                        //   ),
                        //   child: Text(
                        //     "Listes des villes",
                        //     maxLines: 1,
                        //     softWrap: true,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: styleG,
                        //   ),
                        // ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              right: 20,
                              left: 20,
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 4,
                                    childAspectRatio:
                                        MediaQuery.of(context).size.width /
                                        (MediaQuery.of(context).size.height /
                                            3),
                                  ),
                              itemCount: listVille.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    var data = {
                                      'id': listVille[index].id,
                                      'nom': listVille[index].nom,
                                    };
                                    actionOnTheVille(data);
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          // top: 20,
                                          right: 10,
                                          left: 10,
                                          // bottom: 100,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Flexible(
                                            //   flex: 2,
                                            //   child: Text(
                                            //     "Nom de la ville",
                                            //     softWrap: true,
                                            //     overflow: TextOverflow.ellipsis,
                                            //     style: styleG,
                                            //   ),
                                            // ),
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                listVille[index].nom,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: blue,
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Dialog(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.all(
      //                     Radius.circular(10),
      //                   ),
      //                 ),
      //                 insetPadding: EdgeInsets.all(10),
      //                 child: Container(
      //                   child: createVille(),
      //                 )),
      //           );
      //         });
      //     setState(() {
      //       micGetVille();
      //     });

      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }

  Widget createVille() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // HeaderMic(),
            Text(
              "Nouvelle ville",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: green,
              ),
            ),
            ///////////////////////////////
            /// Ville
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                onChanged: (value) {
                  txtVille.text = value;
                },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                decoration: InputDecoration(
                  label: Text(
                    "Ville",
                    style: styleG,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            /////////////////////////
            /// Departement
            /// /////////////////////
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 20,
            //     // left: 20,
            //     // right: 20,
            //   ),
            //   child: TextFormField(
            //     onChanged: (value) {
            //       txtDepartement.text = value;
            //     },
            //     validator: (value) {
            //       return value!.isEmpty ? "Ce champs est obligatoire" : null;
            //     },
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Departement",
            //         textScaleFactor: 1,
            //         overflow: TextOverflow.ellipsis,
            //         style: styleG,
            //         softWrap: true,
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //   ),
            // ),
            /////////////////////////
            /// Difficulte
            /// ////////////////////
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 20,
            //     // left: 20,
            //     // right: 20,
            //   ),
            //   child: TextFormField(
            //     onChanged: (value) {
            //       txtDifficult.text = value;
            //     },
            //     validator: (value) {
            //       return value!.isEmpty ? "Ce champs est obligatoire" : null;
            //     },
            //     toolbarOptions: ToolbarOptions(
            //       copy: false,
            //       cut: false,
            //       paste: false,
            //       selectAll: false,
            //     ),
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Difficulté d'accèss",
            //         textScaleFactor: 1,
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //   ),
            // ),
            //////////////////////////
            ///Prime
            /////////////////////////
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 20,
            //     // left: 20,
            //     // right: 20,
            //   ),
            //   child: TextFormField(
            //     onChanged: (value) {
            //       txtPrime.text = value;
            //     },
            //     validator: (value) {
            //       return value!.isEmpty ? "Ce champs est obligatoire" : null;
            //     },
            //     toolbarOptions: ToolbarOptions(
            //       copy: false,
            //       cut: false,
            //       paste: false,
            //       selectAll: false,
            //     ),
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Prime",
            //         textScaleFactor: 1,
            //         style: styleG,
            //         softWrap: true,
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // right: 20,
                // left: 20,
              ),
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
                      child: Text(
                        "Annuler",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: btnTxtCOlor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Enregistrer",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: btnTxtCOlor,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          micAddVille().then((val) {
                            fToast.showToast(
                              child: toastWidget(val['massage']),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 5),
                            );
                            Navigator.pop(context);
                          });
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
    );
  }
}
