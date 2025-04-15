// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/DetailCodeBarre.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/main.dart';

class Updatedetailchargement extends StatefulWidget {
  DetailCodeBarre detailCode;
  Updatedetailchargement({super.key, required this.detailCode});

  @override
  State<Updatedetailchargement> createState() => _UpdatedetailchargementState();
}

class _UpdatedetailchargementState extends State<Updatedetailchargement> {
  late TextEditingController txtCodeBarre, txtCreuCharger;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    txtCodeBarre = TextEditingController(text: widget.detailCode.barcode);
    txtCreuCharger = TextEditingController(text: widget.detailCode.creuCharger);
  }

  updateDetail() async {
    var data = await RemoteDepotService.modifierDetailChargement(
      txtCodeBarre.text.trim(),
      txtCreuCharger.text.trim(),
      widget.detailCode.id,
    );
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0),
                child: TextFormField(
                  controller: txtCodeBarre,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(179, 208, 208, 233),
                    hintText: 'Code barre',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    return value!.length < 4 ? "Au moins 04 caractères" : null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: TextFormField(
                  controller: txtCreuCharger,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(179, 208, 208, 233),
                    hintText: 'Creux chargé',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    return value!.length < 1
                        ? "La valeur ne peut être null"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Annuler",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white,
                          ),
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
                          "Modifier",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            updateDetail();
                            Navigator.pop(context);
                          }
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
