// ignore_for_file: prefer_const_constructors, must_be_immutable, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateDepot extends StatefulWidget {
  var data;
  UpdateDepot({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateDepot> createState() => _UpdateDepotState();
}

class _UpdateDepotState extends State<UpdateDepot> {
  DateTime? dt1;
  DateTime? dt2;
  List<Depot> listDepot = [];
  late TextEditingController txtNum,
      txtAgrement,
      txtRegistre,
      txtIfu,
      txtNom,
      txtAdresse,
      txtDateStart,
      txtDateEnd;
  final formKey = GlobalKey<FormState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  micUpdateDepot() async {
    var data = await RemoteServiceMic.micUpdateDepot(
      widget.data['id'],
      txtNum.text.toString().trim(),
      txtNom.text.toString().trim(),
      txtIfu.text.toString().trim(),
      txtAgrement.text.toString().trim(),
      // txtEmail.text.toString().trim(),
      txtAdresse.text.toString().trim(),
      txtDateStart.text.toString().trim(),
      txtDateEnd.text.toString().trim(),
      // txtLogin.text.toString().trim(),
      // txtName.text.toString().trim(),
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtAdresse = TextEditingController(text: "${widget.data['adresse']}");
    txtAgrement = TextEditingController(text: "${widget.data['agrement']}");
    txtDateEnd = TextEditingController(text: "${widget.data['DateEnd']}");
    txtDateStart = TextEditingController(text: "${widget.data['DateStart']}");
    txtIfu = TextEditingController(text: "${widget.data['ifu']}");
    txtNom = TextEditingController(text: "${widget.data['nom']}");
    txtRegistre = TextEditingController(text: "${widget.data['registre']}");
    txtNum = TextEditingController(text: "${widget.data['numDepot']}");
    dt1 = DateTime.parse("${widget.data['DateStart']}");
    dt2 = DateTime.parse("${widget.data['DateEnd']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        centerTitle: true,
        title: Text(
          "Modifier le Dépôt",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // HeaderMic(),

              ///////////////////////////////
              /// Nom depot douanier
              /// /////////////////////////
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: txtNom,
                  // onChanged: (value) {
                  //   txtNom.text = value;
                  // },
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
                  controller: txtNum,
                  // onChanged: (value) {
                  //   txtNum.text = value;
                  // },
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
                  controller: txtAdresse,
                  // onChanged: (value) {
                  //   txtAdresse.text = value;
                  // },
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
                  controller: txtIfu,
                  // onChanged: (value) {
                  //   txtIfu.text = value;
                  // },
                  validator: (value) {
                    if (value!.length < 14) {
                      return "Ce champs doit comporter au moins 14 caractère";
                    }
                    if (value.length < 14) {
                      return "Ce champs doit comporter au moins 14 caractères";
                    }
                    return null;
                  },
                  toolbarOptions: ToolbarOptions(paste: false),
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
                  controller: txtAgrement,
                  // onChanged: (value) {
                  //   txtAgrement.text = value;
                  // },
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
              //     controller: txtRegistre,
              //     // onChanged: (value) {
              //     //   txtRegistre.text = value;
              //     // },
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
                      style: TextStyle(color: green),
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
                      style: TextStyle(color: green),
                    ),
                  ),
                  // onChanged: (value) {},
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
                      "Enregistrer",
                      softWrap: true,
                      style: btnTxtCOlor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        micUpdateDepot();
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
    );
  }
}
