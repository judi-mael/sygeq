// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateVille extends StatefulWidget {
  var data;
  UpdateVille({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateVille> createState() => _UpdateVilleState();
}

class _UpdateVilleState extends State<UpdateVille> {
  late TextEditingController txtPrime, txtVille, txtDepartement, txtDifficult;
  final _formKey = GlobalKey<FormState>();

  updateVille() async {
    var data = await RemoteServiceMic.micUpdateVille(
      txtVille.text.trim().toString(),
      txtDepartement.text.trim().toString(),
      txtDifficult.text.trim().toString(),
      txtPrime.text.trim().toString(),
      widget.data['id'],
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtDepartement = TextEditingController(
      text: "${widget.data['departement']}",
    );
    txtDifficult = TextEditingController(text: "${widget.data['difficult']}");
    txtPrime = TextEditingController(text: "${widget.data['prime']}");
    txtVille = TextEditingController(text: "${widget.data['nom']}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // HeaderMic(),
            Text(
              "Modifier la ville",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: GoogleFonts.montserrat(color: green),
            ),
            ///////////////////////////////
            /// Ville
            /// /////////////////////////
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                // left: 20,
                // right: 20,
              ),
              child: TextFormField(
                controller: txtVille,
                // onChanged: (value) {
                //   txtVille.text = value;
                // },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                decoration: InputDecoration(
                  label: Text("Ville"),
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
            //     top: 10,
            //     // left: 20,
            //     // right: 20,
            //   ),
            //   child: TextFormField(
            //     controller: txtDepartement,
            //     // onChanged: (value) {
            //     //   txtDepartement.text = value;
            //     // },
            //     validator: (value) {
            //       return value!.isEmpty ? "Ce champs est obligatoire" : null;
            //     },
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Departement",
            //         textScaleFactor: 1,
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
            //     top: 10,
            //     // left: 20,
            //     // right: 20,
            //   ),
            //   child: TextFormField(
            //     controller: txtDifficult,
            //     // onChanged: (value) {
            //     //   txtDifficult.text = value;
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
            //     top: 10,
            //     // left: 20,
            //     // right: 20,
            //   ),
            //   child: TextFormField(
            //     controller: txtDifficult,
            //     // onChanged: (value) {
            //     //   txtPrime.text = value;
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
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       label: Text(
            //         "Prime",
            //         textScaleFactor: 1,
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
                        if (_formKey.currentState!.validate()) {
                          updateVille();
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
