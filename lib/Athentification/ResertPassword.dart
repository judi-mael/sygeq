// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, deprecated_member_use, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Athentification/forwardPassword.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class ResertPassword extends StatefulWidget {
  const ResertPassword({Key? key}) : super(key: key);

  @override
  State<ResertPassword> createState() => _ResertPasswordState();
}

class _ResertPasswordState extends State<ResertPassword> {
  late TextEditingController txtEmail;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    txtEmail = TextEditingController();
  }

  forgetPass() async {
    var data = await RemoteServices.forgetPassword(
      txtEmail.text.trim().toString(),
      ip,
      phones,
      positionLog.toString(),
      positionLat.toString(),
    );
    return data;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: green,
      //   centerTitle: true,
      //   title: Text(
      //     'Mot de passe oublier',
      //     overflow: TextOverflow.ellipsis,
      //     maxLines: 1,
      //     softWrap: true,
      //     style: styleG,
      //     textAlign: TextAlign.center,
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: Center(
                    child: Card(
                      color: gryfoncee,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                      child: Icon(Icons.refresh, color: blue, size: 200),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Réinitialisation',
                          style: GoogleFonts.montserrat(
                            color: blue,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                        child: Text(
                          'Entre l\'adresse email associé à votre compte, afin de recevoir les instructions',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Color.fromARGB(248, 28, 48, 97),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: txtEmail,
                            // onChanged: (value) {
                            //   txtEmail.text = value;
                            // },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'L\'e-mail doit comporter au moins 08 caractères & 64 au plus';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "Exmeple : xyz@exe.com";
                              }
                              return null;
                            },
                            toolbarOptions: ToolbarOptions(paste: false),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: gryfoncee,
                              label: Text(
                                "E-mail",
                                textScaleFactor: 1,
                                softWrap: true,
                                maxLines: 1,
                                style: styleG,
                                overflow: TextOverflow.ellipsis,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              'CONTINUER',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                forgetPass().then((val) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.white,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                        val["message"],
                                        style: styleG,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                      ),
                                    ),
                                  );
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ForwardPassword(
                                          loginUser:
                                              txtEmail.text.trim().toString(),
                                        ),
                                  ),
                                );
                              } else {}
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, right: 30, left: 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.arrow_back, color: red),
                            label: Text(
                              'ANNULER',
                              style: GoogleFonts.montserrat(
                                color: red,
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: red),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
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
