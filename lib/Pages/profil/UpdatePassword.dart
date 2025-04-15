// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext ctx) => Login()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: green),
              child: Text("Oui", style: btnTxtCOlor),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text("Non", style: btnTxtCOlor),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    txtPassword = TextEditingController();
    txtNewPass = TextEditingController();
    txtComPass = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: green,
        title: Text("Modifier le mot de passe"),
      ),
      backgroundColor: gryClaie,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        alertDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Modifier le mot de passe",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: btnTxtCOlor,
                    ),
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
