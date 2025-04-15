// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, unused_field

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Pages/DetailUpdate/MicUpdate/Detail/DetailDepot.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/CardWidget.dart';
import 'package:sygeq/ui/DefaultToas.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class DepotDouanier extends StatefulWidget {
  const DepotDouanier({Key? key}) : super(key: key);

  @override
  State<DepotDouanier> createState() => _DepotDouanierState();
}

class _DepotDouanierState extends State<DepotDouanier> {
  bool _obscuretext = true;
  DateTime? dt1;
  DateTime? dt2;
  List<Depot> listDepot = [];
  List listId = [];
  List listDistance = [];
  List listDifficultee = [];
  List listPrime = [];
  bool _animate = true;
  late TextEditingController txtNum,
      txtAgrement,
      txtRegistre,
      txtIfu,
      txtNom,
      txtAdresse,
      txtVille,
      txtDateStart,
      txtDateEnd,
      txtName,
      txtEmail,
      txtLogin,
      txtDifficultee,
      txtPrime,
      txtDistance;
  final formKey = GlobalKey<FormState>();
  final formKeyDetailVille = GlobalKey<FormState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  micAddDepot() async {
    var data = await RemoteServiceMic.micAddDepot(
      txtNum.text.toString().trim(),
      txtNom.text.toString().trim(),
      txtIfu.text.toString().trim(),
      txtAgrement.text.toString().trim(),
      txtEmail.text.toString().trim(),
      txtAdresse.text.toString().trim(),
      txtVille.text.toString().trim(),
      txtDateStart.text.toString().trim(),
      txtDateEnd.text.toString().trim(),
      txtLogin.text.toString().trim(),
      txtName.text.toString().trim(),
      listId,
      listDistance,
      listDifficultee,
      listPrime,
    );
    return data;
  }

  actionOnTheMarketer(var data) {
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
              padding: EdgeInsets.all(8.0),
              child: DetailDepot(data: data),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() async {
        await micGetDepotDouanier();
      });
    });
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), micGetDepotDouanier);
  }

  disable(int id) async {
    var data = await RemoteServiceDisable.micDisable(id, 0, 'depots');
    return data;
  }

  micGetDepotDouanier() async {
    var res = await RemoteServiceMic.micGetListeDepot();
    // if (!mounted) return null;
    setState(() {
      listDepot = res;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return listDepot;
  }

  @override
  void initState() {
    super.initState();
    micGetDepotDouanier();
    txtAdresse = TextEditingController();
    txtNom = TextEditingController();
    txtNum = TextEditingController();
    txtLogin = TextEditingController();
    txtRegistre = TextEditingController();
    txtName = TextEditingController();
    txtLogin = TextEditingController();
    txtEmail = TextEditingController();
    txtIfu = TextEditingController();
    txtVille = TextEditingController();
    txtAgrement = TextEditingController();
    txtDateStart = TextEditingController();
    txtDateEnd = TextEditingController();
    txtPrime = TextEditingController();
    txtDistance = TextEditingController();
    txtDifficultee = TextEditingController();
    if (listMicVille.isNotEmpty) {
      for (int i = 0; listMicVille.length > i; i++) {
        listId.add(listMicVille[i].id);
        listDifficultee.add('');
        listDistance.add('');
        listPrime.add('');
      }
    }
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
        iconTheme: IconThemeData(
          color: gryClaie, //change your color here
        ),
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Dépôt douanier",
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
                : listDepot.isEmpty
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
                            micGetDepotDouanier();
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
                        HeaderMic(),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     top: 20,
                        //     left: 30,
                        //     right: 30,
                        //   ),
                        //   child: Text(
                        //     "Liste des dépôts douanier",
                        //     maxLines: 1,
                        //     softWrap: true,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: styleG,
                        //   ),
                        // ),
                        if (listDepot.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 5,
                                right: 5,
                              ),
                              child: ListView.builder(
                                itemCount: listDepot.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      var data = {
                                        'id': listDepot[index].id,
                                        'numDepot':
                                            listDepot[index].numDepotDouanier,
                                        'nom': listDepot[index].nom,
                                        'ifu': listDepot[index].ifu,
                                        // 'registre': listDepot[index].registre,
                                        'adresse': listDepot[index].adresse,
                                        'delete': listDepot[index].deletedAt,
                                        'agrement': listDepot[index].agrement,
                                        'DateStart':
                                            listDepot[index].dateVigueur,
                                        'DateEnd':
                                            listDepot[index].dateExpiration,
                                      };
                                      actionOnTheMarketer(data);
                                    },
                                    child: listDesDepot(listDepot[index]),
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
    );
  }

  Widget createDepotDouanier() {
    return Scaffold(
      // backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: blue,
        centerTitle: true,
        title: Text(
          "Nouveau  dépôt douanier",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: styleG,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              HeaderMic(),

              ///////////////////////////////
              /// Nom depot douanier
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtNom.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: Text(
                      "Nom",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              ///////////////////////////////
              /// Numero depot douanier
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtNum.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: Text(
                      "Numéro dépôt",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              ///////////////////////////////
              /// Adresse depot douanier
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtAdresse.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "Adresse",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              ///////////////////////////////
              /// Ifu depot douanier
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtIfu.text = value;
                  },
                  validator: (value) {
                    if (value!.length < 13) {
                      return "Ce champs doit comporter au moins 14 caractère";
                    }
                    if (value.length < 13) {
                      return "Ce champs doit comporter au moins 14 caractères";
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  toolbarOptions: ToolbarOptions(paste: false),
                  maxLength: 13,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "IFU",
                      textScaleFactor: 1,
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
              ///////////////////////////////
              /// Agrement depot douanier
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtAgrement.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: Text(
                      "Agrement",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              ///////////////////////////////
              /// Agrement depot douanier
              /// /////////////////////////
              // Padding(
              //   padding: EdgeInsets.only(
              //     top: 20,
              //     left: 20,
              //     right: 20,
              //   ),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       txtRegistre.text = value;
              //     },
              //     validator: (value) {
              //       return value!.isEmpty
              //           ? "Ce champs est obligatoire"
              //           : null;
              //     },
              //     toolbarOptions: ToolbarOptions(
              //       paste: false,
              //     ),
              //     keyboardType: TextInputType.name,
              //     decoration: InputDecoration(
              //       label: Text(
              //         "Régistre",
              //         textScaleFactor: 1,
              //         softWrap: true,
              //         maxLines: 1,
              //         overflow: TextOverflow.ellipsis,
              //         style: styleG,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              // ),
              //////////////////////////
              ///Date debut
              /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: txtDateStart,
                  keyboardType: TextInputType.none,
                  // textAlign: TextAlign.start,
                  toolbarOptions: ToolbarOptions(
                    copy: false,
                    cut: false,
                    paste: false,
                    selectAll: false,
                  ),
                  validator:
                      (value) => value == null ? 'Choisissez la date' : null,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2102),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dt1 = pickedDate;
                        txtDateStart.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_month),
                      onPressed: () {},
                    ),
                    label: Text(
                      "Date de début",
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: GoogleFonts.montserrat(color: green),
                    ),
                  ),
                  // onChanged: (value) {},
                ),
              ),

              //////////////////////////
              ///Date de fin
              /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: txtDateEnd,
                  keyboardType: TextInputType.none,
                  // textAlign: TextAlign.start,
                  toolbarOptions: ToolbarOptions(
                    copy: false,
                    cut: false,
                    paste: false,
                    selectAll: false,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == null) {
                      return 'Choisissez la date';
                    }
                    if (dt1!.compareTo(dt2!) > 0) {
                      return 'La date de début ne peut pas être anterieur à la date de fin';
                    }
                    null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2102),
                      initialDatePickerMode: DatePickerMode.day,
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dt2 = pickedDate;
                        txtDateEnd.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_month),
                      onPressed: () {},
                    ),
                    label: Text(
                      "Date de Fin",
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: GoogleFonts.montserrat(color: green),
                    ),
                  ),
                  // onChanged: (value) {},
                ),
              ),

              ///////////////////////////////////////////////
              /// Information de connexion
              /// //////////////////////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtName.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "Nom complet",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    fit: FlexFit.loose,
                  ),
                  items:
                      listMicVille.isEmpty
                          ? []
                          : listMicVille.map((e) => e.nom).toList(),
                  validator:
                      (value) => value == null ? 'Choisissez la ville' : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      int indx = listMicVille.indexWhere(
                        (element) => element.nom == newValue.toString(),
                      );
                      txtVille.text = listMicVille[indx].id.toString();
                    });
                  },
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Ville',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtLogin.text = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Ce champs est obligatoire" : null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "Login / identifiant",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  onChanged: (value) {
                    txtEmail.text = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'L\'e-mail doit comporter au moins 08 caractères & 20 au plus';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "exmeple : xyz@exe.com";
                    }
                    return null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                      "E-mail",
                      textScaleFactor: 1,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Suivant",
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // micAddDepot().then((val) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: green,
                        //       duration: Duration(seconds: 2),
                        //       content: Text(
                        //         val["message"],
                        //         textAlign: TextAlign.center,
                        //         softWrap: true,
                        //         style: styleG,
                        //       ),
                        //     ),
                        //   );
                        // });
                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => creatDetails(),
                          ),
                        );
                      } else {}
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget creatDetails() {
    return Scaffold(
      backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        title: Text(
          "Détail pour les villes",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: styleG,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKeyDetailVille,
          child: Column(
            children: [
              // Padding(
              //   padding: EdgeInsets.only(top: 5, left: 20, right: 20),
              //   child: TextFormField(
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //       label: Text(
              //         "Difficulté",
              //         textScaleFactor: 1,
              //         softWrap: true,
              //         maxLines: 1,
              //         overflow: TextOverflow.ellipsis,
              //         style: styleG,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              // ),
              for (int i = 0; listMicVille.length > i; i++) ...[
                // listId[i]=listMicVille[i].id;
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(listMicVille[i].nom),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            left: 20,
                            right: 20,
                            bottom: 5,
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              listDifficultee[i] = value;
                            },
                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le champs est vide";
                              }
                            },
                            // autovalidateMode: AutovalidateMode.always,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text(
                                "Difficulté",
                                textScaleFactor: 1,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: styleG,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            left: 20,
                            right: 20,
                            bottom: 5,
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              listDistance[i] = value;
                            },
                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le champs est vide";
                              }
                            },
                            // autovalidateMode: AutovalidateMode.always,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text(
                                "Distance",
                                textScaleFactor: 1,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: styleG,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            left: 20,
                            right: 20,
                            bottom: 5,
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              listPrime[i] = value;
                            },
                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Le champs est vide";
                              }
                            },
                            // autovalidateMode: AutovalidateMode.always,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text(
                                "Prime",
                                textScaleFactor: 1,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: styleG,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              Padding(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    onPressed: () async {
                      if (formKeyDetailVille.currentState!.validate()) {
                        micAddDepot().then((val) {
                          fToast.showToast(
                            child: toastWidget(val['message']),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 5),
                          );
                        });
                        // micAddDepot();
                        Navigator.of(context, rootNavigator: true).pop();
                        // Navigator.pop(context);
                      } else {}
                    },
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
