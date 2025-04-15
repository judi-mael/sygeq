// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class FestConnecion extends StatefulWidget {
  const FestConnecion({super.key});

  @override
  State<FestConnecion> createState() => _FestConnecionState();
}

class _FestConnecionState extends State<FestConnecion> {
  late TextEditingController txtPassword, txtNewPass, txtComPass;
  final formKey = GlobalKey<FormState>();
  bool _obscuretext = true;
  bool _obscureConfirmtext = true;
  bool _obscureNewtext = true;
  changePassword() async {
    var data = await RemoteServices.changepassword(
      prefUserInfo['password'],
      txtNewPass.text.trim().toString(),
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtPassword = TextEditingController();
    txtNewPass = TextEditingController();
    txtComPass = TextEditingController();
  }

  alertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: Container(
            child: Column(
              children: [
                Text(
                  "Vous allez être déconnecté",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
                Text(
                  "Vous êtes sur de vouloir continuer?",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                changePassword().then((val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: green,
                      duration: Duration(seconds: 2),
                      content: Text(
                        val["message"],
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: green),
              child: Text("Oui"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text("Non"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        title: Text(
          "Reset password",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: styleG,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              HeaderMic(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                      ),
                      child: TextFormField(
                        // controller: txtPassword,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.name,
                        obscureText: _obscuretext,

                        maxLines: 1,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: Text('Ancien password'),
                          // errorText: ,
                          hintText: '*********',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscuretext = !_obscuretext;
                              });
                            },
                          ),
                        ),
                        // maxLength: 50,
                        validator: (vals) {
                          if (vals!.length < 8) {
                            return 'Le password doit comporter au moins 08 caratères';
                          }
                          if (vals.trim() != prefUserInfo['password']) {
                            return "L'ancien mot de passe est incorrect";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            txtPassword.text = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: TextFormField(
                        // controller: txtPassword,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.name,
                        obscureText: _obscureNewtext,

                        maxLines: 1,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: Text(
                            'Nouveau password',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: styleG,
                          ),
                          // errorText: ,
                          hintText: '*********',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewtext = !_obscureNewtext;
                              });
                            },
                          ),
                        ),
                        // maxLength: 50,
                        validator: (vals) {
                          if (vals!.length < 8) {
                            return 'Le password doit comporter au moins 08 caratères';
                          }
                          if (vals.trim() == prefUserInfo['password']) {
                            return "Les mots de passe sont identiques";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            txtNewPass.text = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                      ),
                      child: TextFormField(
                        // controller: txtPassword,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.name,
                        obscureText: _obscureConfirmtext,

                        maxLines: 1,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: Text(
                            'Confirme password',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: styleG,
                          ),
                          // errorText: ,
                          hintText: '*********',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmtext = !_obscureConfirmtext;
                              });
                            },
                          ),
                        ),
                        // maxLength: 50,
                        validator: (vals) {
                          if (vals!.length < 8) {
                            return 'Le password doit comporter au moins 08 caratères';
                          }
                          if (vals.trim() != txtNewPass.text.trim()) {
                            return "Les mots de passe ne correspondent pas";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            txtComPass.text = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            'METTRE A JOUR',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {});
                              alertDialog();
                            }
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
                            'Passer',
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
                            setState(() {});
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
    );
  }
}
