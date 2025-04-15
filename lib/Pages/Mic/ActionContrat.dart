// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, deprecated_member_use, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Contrart.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class ActionContrat extends StatefulWidget {
  ActionContrat({Key? key}) : super(key: key);

  @override
  State<ActionContrat> createState() => _ActionContratState();
}

class _ActionContratState extends State<ActionContrat> {
  List<Contrat> listContrat = [];
  late TextEditingController txtCommentaire;
  final formKey = GlobalKey<FormState>();
  String id = "";
  bool _animate = true;
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

  micUpdateContrat(int id, String statut) async {
    var data = await RemoteServiceMic.micupdateContart(statut, id);
    return data;
  }

  @override
  void initState() {
    txtCommentaire = TextEditingController();
    super.initState();
    markGetContrat();
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
        backgroundColor: blue,
        centerTitle: true,
        title: Text("Contrats", overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
      // backgroundColor: gryClaie,
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listContrat.isEmpty
                ? SafeArea(
                  child: Center(
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
                  ),
                )
                : Column(
                  children: [
                    HeaderMic(),
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: Text(
                        "Liste des contrats",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                            onTap: () {
                              Marketer marketer = listContrat[index].marketer;
                              Driver transporteur = listContrat[index].driver;
                              var data = {
                                'id': listContrat[index].id,
                                'statut': listContrat[index].statut,
                              };
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      ((context) => createContart(
                                        marketer,
                                        data,
                                        transporteur,
                                      )),
                                ),
                              ).then((value) => markGetContrat());
                            },
                            child: Card(
                              color:
                                  listContrat[index].statut == "En attente" ||
                                          listContrat[index].statut == "Rejeté"
                                      ? Color.fromARGB(250, 223, 213, 212)
                                      : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 15,
                                  bottom: 10,
                                  right: 10,
                                  left: 15,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Flexible(
                                        //   flex: 2,
                                        //   child: Icon(
                                        //     Icons.fire_truck_sharp,
                                        //     color: blue,
                                        //     size: 40,
                                        //   ),

                                        // ),
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            listContrat[index].driver.nom,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Flexible(
                                        //   flex: 2,
                                        //   child: Icon(
                                        //     Icons
                                        //         .local_gas_station_outlined,
                                        //     color: red,
                                        //     size: 40,
                                        //   ),
                                        // ),
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            listContrat[index].marketer.nom,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.black),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Flexible(
                                              //   flex: 2,
                                              //   child: Icon(
                                              //     Icons.calendar_month,
                                              //     color: green,
                                              //   ),
                                              // ),
                                              Flexible(
                                                flex: 4,
                                                child: Text(
                                                  '${DateFormat('dd MMM yyyy').format(DateTime.parse(listContrat[index].driver.dateVigeur))} au ${DateFormat('dd MMM yyyy').format(DateTime.parse(listContrat[index].driver.dateExp))}',
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
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
                    ),
                  ],
                ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: blue,
      //   onPressed: () {
      // Navigator.push(context,
      //         MaterialPageRoute(builder: ((context) => createContart())))
      //     .then((value) => markGetContrat());
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }

  Widget createContart(Marketer marketer, var data, Driver transporteur) {
    // bool obscure = true;

    return Scaffold(
      // backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: blue,
        centerTitle: true,
        title: Text(
          "Vérification du contrat",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: styleG,
        ),
      ),
      body: Container(
        decoration: logoDecoration(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Informations sur le marketer',
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                "Désignation : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Text(
                                marketer.nom,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                "Autorisation : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Text(
                                '${DateFormat('dd MMM yyyy').format(DateTime.parse(marketer.dateVigueur))} au ${DateFormat('dd MMM yyyy').format(DateTime.parse(marketer.dateExpiration))}',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "IFU : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                marketer.ifu,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "Agrément : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                marketer.agrement,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Informations sur le Transporteur',
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "Désignation : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                transporteur.nom,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                "Autorisation : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                '${DateFormat('dd MMM yyyy').format(DateTime.parse(transporteur.dateVigeur))} au ${DateFormat('dd MMM yyyy').format(DateTime.parse(transporteur.dateExp))}',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "IFU : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                transporteur.ifu,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                "Agrément : ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: styleG,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                transporteur.agrement,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (data['statut'] == "Approuvé") ...[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        micUpdateContrat(data['id'], "rejeter").then((value) {
                          fToast.showToast(
                            child: toastWidget(value['message']),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 5),
                          );
                        });
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel_rounded, color: red, size: 30),
                      label: Text(
                        "Rejeter",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(color: red, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
              if (data['statut'] == "En attente") ...[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      toolbarOptions: ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: true,
                        selectAll: false,
                      ),
                      maxLength: 300,
                      maxLines: 5,

                      decoration: InputDecoration(
                        hintText:
                            "Le champs commentaire est obligatoire si vous voulez rejeter le BL",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: Text(
                          "Commentaire",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(color: green),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        return value!.isEmpty ? 'Ajouter de commentaire' : null;
                      },
                      onChanged: (value) {
                        txtCommentaire.text = value;
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: blue,
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: (() {
                            micUpdateContrat(
                              data['id'],
                              "approuver",
                            ).then((value) {});
                            Navigator.pop(context);
                          }),
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                          label: Text(
                            "Approuver",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            micUpdateContrat(
                              data['id'],
                              "rejeter",
                            ).then((value) {});
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: red,
                            size: 30,
                          ),
                          label: Text(
                            "Rejeter",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              color: red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
