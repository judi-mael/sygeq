// ignore_for_file: prefer_const_constructors, must_be_immutable, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateTransporteur extends StatefulWidget {
  var data;
  UpdateTransporteur({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateTransporteur> createState() => _UpdateTransporteurState();
}

class _UpdateTransporteurState extends State<UpdateTransporteur> {
  DateTime? dt1;
  DateTime? dt2;
  late TextEditingController txtNom,
      txtIfu,
      txtAdresse,
      txtAgrement,
      txtRegistre,
      txtDateStart,
      txtDateEnd;
  final formKey = GlobalKey<FormState>();
  micUpdateTransporteur() async {
    var data = await RemoteServiceMic.micUpdateTransporteur(
      widget.data['id'],
      txtNom.text.toString().trim(),
      txtIfu.text.toString().trim(),
      txtAgrement.text.toString().trim(),
      txtAdresse.text.toString().trim(),
      txtDateStart.text.toString().trim(),
      txtDateEnd.text.toString().trim(),
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
    dt1 = DateTime.parse("${widget.data['DateStart']}");
    dt2 = DateTime.parse("${widget.data['DateEnd']}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // HeaderMic(),
            ///////////////////////////////
            /// Nom Transporteur
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
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
                    "Nom transporteur",
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
            /// Adresse Transporteur
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtAdresse,
                // onChanged: (value) {
                //   txtAdresse.text = value;
                // },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(paste: false),
                keyboardType: TextInputType.name,
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
            /// Agrement Transporteur
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
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
                    "Agrément",
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
            /// IFU Transporteur
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtIfu,
                // onChanged: (value) {
                //   txtIfu.text = value;
                // },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(paste: false),
                maxLength: 14,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Ifu",
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
            /// Registre Transporteur
            /// /////////////////////////
            // Padding(
            //   padding: EdgeInsets.only(
            //     top:10,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: TextFormField(
            //     onChanged: (value) {
            //       txtRegistre.text = value;
            //     },
            //     validator: (value) {
            //       return value!.isEmpty ? "Ce champs est obligatoire" : null;
            //     },
            //     toolbarOptions: ToolbarOptions(
            //       paste: false,
            //     ),
            //     keyboardType: TextInputType.name,
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Registre",
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
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
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
                    firstDate: DateTime.now().subtract(Duration(days: 0)),
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
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
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

            ///////////////////////////////////////////////
            /// Information de connexion
            /// //////////////////////////////////////////
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
                        style: btnTxtCOlor,
                        overflow: TextOverflow.ellipsis,
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
                        style: btnTxtCOlor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          micUpdateTransporteur();
                          Navigator.pop(context);
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
    );
  }
}
