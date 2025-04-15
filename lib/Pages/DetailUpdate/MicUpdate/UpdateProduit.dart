// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sygeq/Services/MicRemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateProduit extends StatefulWidget {
  var data;
  UpdateProduit({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateProduit> createState() => _UpdateProduitState();
}

class _UpdateProduitState extends State<UpdateProduit> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController txtNom, txtCode, txtType;
  modProduct() async {
    var data = await RemoteServiceMic.micupdateProduit(
      txtNom.text.trim().toString(),
      txtCode.text.trim().toString(),
      txtType.text.trim().toString(),
      widget.data['id'],
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtCode = TextEditingController(text: "${widget.data['code']}");
    txtNom = TextEditingController(text: "${widget.data['nom']}");
    txtType = TextEditingController(text: "${widget.data['type']}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              "Modifier le produit",
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: txtNom,
                // onChanged: (value) {
                //   txtNom.text = value;
                // },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
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
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: txtCode,
                // onChanged: (value) {
                //   txtCode.text = value;
                // },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
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
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: txtType,
                // onChanged: (value) {
                //   txtType.text = value;
                // },
                validator: (value) {
                  return value!.isEmpty ? "Ce champs est obligatoire" : null;
                },
                maxLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  label: Text(
                    "Type",
                    softWrap: true,
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
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
                        style: btnTxtCOlor,
                        overflow: TextOverflow.ellipsis,
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
                          modProduct();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Enregistrer",
                        softWrap: true,
                        maxLines: 1,
                        style: btnTxtCOlor,
                        overflow: TextOverflow.ellipsis,
                      ),
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
