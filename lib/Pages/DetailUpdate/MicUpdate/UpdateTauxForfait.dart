// ignore_for_file: prefer_const_constructors, deprecated_member_use, must_be_immutable, unused_local_variable, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateTauxForfait extends StatefulWidget {
  var tauxForfaitL;
  UpdateTauxForfait({Key? key, required this.tauxForfaitL}) : super(key: key);

  @override
  State<UpdateTauxForfait> createState() => _UpdateTauxForfaitState();
}

class _UpdateTauxForfaitState extends State<UpdateTauxForfait> {
  late TextEditingController txtTauxForfait,
      txtDateStart,
      txtDateEnd,
      txtDistance;
  final formKey = GlobalKey<FormState>();
  DateTime? dt1;
  DateTime? dt2;
  modifTauxForfait() async {
    var data = await RemoteServiceMic.micAddTauxForfait(
      txtTauxForfait.text.trim().toString(),
      // txtDistance.text.trim().toString(),
      txtDateStart.text.trim().toString(),
      txtDateEnd.text.trim().toString(),
      // widget.tauxForfaitL['id'],
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtDateEnd = TextEditingController(
      text: "${widget.tauxForfaitL['dateEnd']}",
    );
    txtDateStart = TextEditingController(
      text: "${widget.tauxForfaitL['dateStart']}",
    );
    txtDistance = TextEditingController(
      text: "${widget.tauxForfaitL['distance']}",
    );
    txtTauxForfait = TextEditingController(
      text: "${widget.tauxForfaitL['tauxForfat']}",
    );
    dt1 = DateTime.parse("${widget.tauxForfaitL['dateStart']}");
    dt2 = DateTime.parse("${widget.tauxForfaitL['dateEnd']}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            /////////////////////////
            /// taux Forfait
            /// ////////////////////
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                controller: txtTauxForfait,
                // onChanged: (value) {
                //   txtTauxForfait.text = value;
                // },
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text(
                    "Taux forfait",
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
            /////////////////////////
            /// Distance
            /// ////////////////////
            // Padding(
            //   padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            //   child: TextFormField(
            //     controller: txtDistance,
            //     // onChanged: (value) {
            //     //   txtDistance.text = value;
            //     // },
            //     validator: (value) {
            //       return value!.isEmpty ? "Ce champs est obligatoire" : null;
            //     },
            //     toolbarOptions: ToolbarOptions(
            //       copy: false,
            //       cut: false,
            //       paste: false,
            //       selectAll: false,
            //     ),
            //     maxLength: 12,
            //     minLines: 1,
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Distance",
            //         textScaleFactor: 1,
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
            ///Date de début
            /////////////////////////
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
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
                    initialDate: DateTime.now().subtract(Duration(days: 1)),
                    firstDate: DateTime(2022).subtract(Duration(days: 1)),
                    lastDate: DateTime(2102),
                    initialDatePickerMode: DatePickerMode.day,
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
            ///Date de FIn
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
                    firstDate: DateTime(2022).subtract(Duration(days: 1)),
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
            Padding(
              padding: EdgeInsets.only(top: 30, right: 20, left: 20),
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
                    style: btnTxtCOlor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      modifTauxForfait();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {}
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
