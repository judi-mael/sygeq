// ignore_for_file: prefer_const_constructors, must_be_immutable, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateTauxTK extends StatefulWidget {
  var data;
  UpdateTauxTK({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateTauxTK> createState() => _UpdateTauxTKState();
}

class _UpdateTauxTKState extends State<UpdateTauxTK> {
  DateTime? dt1;
  DateTime? dt2;
  final formKey = GlobalKey<FormState>();
  late TextEditingController txtValeurTK, txtRef, txtDateStart, txtDateEnd;
  updateTauxTK() async {
    var data = await RemoteServiceMic.micUpdateTauxTK(
      txtValeurTK.text.trim().toString(),
      txtRef.text.trim().toString(),
      txtDateStart.text.trim().toString(),
      txtDateEnd.text.trim().toString(),
      widget.data['id'],
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtDateStart = TextEditingController(text: "${widget.data['dateStart']}");
    txtDateEnd = TextEditingController(text: "${widget.data['dateEnd']}");
    txtRef = TextEditingController(text: "${widget.data['ref']}");
    txtValeurTK = TextEditingController(text: "${widget.data['valeurTK']}");
    dt1 = DateTime.parse("${widget.data['dateStart']}");
    dt2 = DateTime.parse("${widget.data['dateEnd']}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              "Modifier le Taux TK",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            // HeaderMic(),
            ///////////////////////////////
            /// Taux TK
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtValeurTK,
                onChanged: (value) {
                  txtValeurTK.text = value;
                },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(paste: false),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text(
                    "Taux TK",
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

            /////////////////////////
            /// Refrence du taux TK
            /// ////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtRef,
                onChanged: (value) {
                  txtRef.text = value;
                },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                toolbarOptions: ToolbarOptions(
                  copy: false,
                  cut: false,
                  paste: false,
                  selectAll: false,
                ),
                maxLength: 12,
                minLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Référence",
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

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
                        backgroundColor: gryClaie,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Annuler",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.pop(context);
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
                          updateTauxTK();
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
