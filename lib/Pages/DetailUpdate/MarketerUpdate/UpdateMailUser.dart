// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateMailUser extends StatefulWidget {
  var userL;
  UpdateMailUser({Key? key, required this.userL}) : super(key: key);

  @override
  State<UpdateMailUser> createState() => _UpdateMailUserState();
}

class _UpdateMailUserState extends State<UpdateMailUser> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController txtEmail;

  depotAddUer() async {
    var data = await RemoteServices.allUpdateMailUser(
      id: widget.userL['id'].toString(),
      userEmail: txtEmail.text.trim().toString(),
    );
    return data;
  }

  @override
  void initState() {
    txtEmail = TextEditingController(text: widget.userL['email']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              // left: 10,
              // right: 10,
            ),
            child: Column(
              children: [
                Text(
                  "Modifier l'e-mail utilisateur",
                  style: styleG,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    // left: 20,
                    // right: 20,
                  ),
                  child: TextFormField(
                    controller: txtEmail,
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
                  padding: EdgeInsets.only(
                    top: 10,
                    // left: 20,
                    // right: 20,
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
                              depotAddUer();
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
        ),
      ),
    );
  }
}
