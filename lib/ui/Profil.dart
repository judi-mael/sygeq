// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously, empty_catches, unused_catch_clause, unused_local_variable

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sygeq/Athentification/Login.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late TextEditingController txtPassword,
      txtEmail,
      txtName,
      txtUserName,
      txtNewPass,
      txtComPass;
  final formKey = GlobalKey<FormState>();
  final formKeyId = GlobalKey<FormState>();
  String userAction = '';
  bool updateIdentifiant = false;
  bool updatePassword = false;
  bool _obscuretext = true;
  bool _obscureConfirmtext = true;
  bool _obscureNewtext = true;
  bool isLoading = false;
  String? _passwordValidator(String? value) {
    // Vérifie la longueur minimale de 12 caractères
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    } else if (value.length < 12) {
      return 'Le mot de passe doit contenir au moins 12 caractères';
    }

    // Vérifie la présence d'une majuscule
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }

    // Vérifie la présence d'une minuscule
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }

    // Vérifie la présence d'un chiffre
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }

    // Vérifie la présence d'un caractère spécial
    if (!RegExp(r'[\W_]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un caractère spécial';
    }
    if (value.trim() == prefUserInfo['password']) {
      return "Le nouveau mot de passe doit être different de l'ancien";
    }
    return null; // Si toutes les vérifications passent
  }

  changePassword() async {
    var data = await RemoteServices.changepassword(
      prefUserInfo['password'],
      txtNewPass.text.trim().toString(),
    );
    return data;
  }

  changeUserImage() async {
    var data = await RemoteServices.changeUserInfo(
      id: prefUserInfo['idUser'].toString(),
      image: image!.path,
    );
    var img = await RemoteServices.getUserProfilImage();
    setState(() {
      prefUserInfo['userImage'] = img.toString().replaceAllMapped(
        RegExp(r'[\" \"]'),
        (match) {
          return '';
        },
      );
    });
    setState(() {});
  }

  changeUserInfo() async {
    var data = await RemoteServices.changeUserInfo(
      id: prefUserInfo['idUser'].toString(),
      email: txtEmail.text.trim().toString(),
      name: txtName.text.trim().toString(),
      userName: txtUserName.text.trim().toString(),
      image: '',
    );
    return data;
  }

  alertUserImage() {
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
                  "Vous allez modifier ",
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
                Navigator.pop(context);
                changeUserImage();
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

  alertDeconnexion() {
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
                  "Déconnexion",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
                Text(
                  "Vous-Êtes sûr(e) de vouloir continuer ?",
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
                Navigator.pop(context);
                setState(() {
                  deconnexionState = true;
                });
                await Future.delayed(Duration(seconds: 3));
                setState(() {
                  deconnexionState = false;
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
              child: Text(
                "Oui",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                "Non",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
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
                if (userAction == 'motDePasse') {
                  setState(() {
                    isLoading = true;
                  });
                  // Future.delayed(Duration(seconds: 5));
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
                  // Navigator.of(context, rootNavigator: true).pop();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext ctx) => Login()),
                    (route) => false,
                  );
                  // Navigator.pop(context);
                  // await Future.delayed(Duration(seconds: 3))
                  //     .then((value) async {
                  //   if (mounted) {}
                  // });

                  // setState(() {
                  //   isLoading = false;
                  // });
                }
                if (userAction == 'userInfo') {
                  changeUserInfo();
                }
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
  void initState() {
    super.initState();
    txtPassword = TextEditingController();
    txtNewPass = TextEditingController();
    txtComPass = TextEditingController();
    txtEmail = TextEditingController(text: prefUserInfo['email']);
    txtName = TextEditingController(text: prefUserInfo['name']);
    txtUserName = TextEditingController(text: prefUserInfo['userName']);
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                  semanticsLabel: "Fermeture des pages encours",
                  semanticsValue: "Fermeture des pages encours",
                  strokeWidth: 5,
                  // value: 10,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                ),
              )
              : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30, right: 30, left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet()),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 170, 205, 233),
                                shape: BoxShape.circle,
                                border: Border.all(color: blue, width: 0.5),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: blue,
                              ),
                            ),
                          ),
                          GestureDetector(
                            child:
                                prefUserInfo['userImage'].toString().isNotEmpty
                                    ? Container(
                                      decoration: BoxDecoration(
                                        color: gryClaie,
                                        border: Border.all(
                                          color: green,
                                          width: 3,
                                          style: BorderStyle.solid,
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          // alignment: Alignment.center,
                                          image: NetworkImage(
                                            uRl + prefUserInfo['userImage'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: _size.width / 3,
                                      height: _size.height / 5,
                                    )
                                    // : image != null
                                    //     ? Container(
                                    //         decoration: BoxDecoration(
                                    //           color: gryClaie,
                                    //           border: Border.all(
                                    //               color: green,
                                    //               width: 3,
                                    //               style: BorderStyle.solid),
                                    //           shape: BoxShape.circle,
                                    //           image: DecorationImage(
                                    //             // alignment: Alignment.center,
                                    //             image: FileImage(
                                    //               image!,
                                    //             ),
                                    //             fit: BoxFit.cover,
                                    //           ),
                                    //         ),
                                    //         width: _size.width / 3,
                                    //         height: _size.height / 5,
                                    //       )
                                    : Container(
                                      decoration: BoxDecoration(
                                        color: gryClaie,
                                        border: Border.all(
                                          color: green,
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          // alignment: Alignment.center,
                                          image: AssetImage(
                                            'assets/icons/account.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width:
                                          _size.width < _size.height
                                              ? _size.width / 3
                                              : _size.width / 5,
                                      height:
                                          _size.width < _size.height
                                              ? _size.height / 5
                                              : _size.height / 3,
                                    ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              alertDeconnexion();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 240, 194, 191),
                                border: Border.all(color: red, width: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.power_settings_new,
                                size: 30,
                                color: red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Text(
                        prefUserInfo['name'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Text(
                        prefUserInfo['type'] + '  ~~  ' + prefUserInfo['role'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: green,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (updatePassword == false) ...[
                      if (updateIdentifiant == true) ...[
                        Form(
                          key: formKeyId,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  right: 20,
                                  left: 20,
                                ),
                                child: TextFormField(
                                  controller: txtEmail,

                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.emailAddress,

                                  maxLines: 1,

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: Text('E-mail', textScaleFactor: 0.9),
                                    // errorText: ,
                                    hintText: 'exemple@xyz.com',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // maxLength: 50,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'L\'e-mail doit comporter au moins 08 caractères & 64 au plus';
                                    }
                                    if (!RegExp(
                                      r'\S+@\S+\.\S+',
                                    ).hasMatch(value)) {
                                      return "Exmeple : xyz@exe.com";
                                    }
                                    return null;
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
                                  controller: txtName,

                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.name,

                                  maxLines: 1,

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: Text(
                                      'Nom complet',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: styleG,
                                    ),
                                    // errorText: ,
                                    hintText: 'Nom d\'utilisateur',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // maxLength: 50,
                                  validator: (vals) {
                                    if (vals!.length < 8) {
                                      return 'Le Nom d\'utilisateur  doit comporter au moins 08 caratères';
                                    }

                                    return null;
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
                                  controller: txtUserName,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.name,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: Text(
                                      'Login',
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: styleG,
                                    ),
                                    // errorText: ,
                                    hintText: 'login',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (vals) {
                                    if (vals!.length < 4) {
                                      return 'Le login doit comporter au moins 04 caratères';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  right: 30,
                                  left: 30,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: Text(
                                      'METTRE A JOUR',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 15,
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
                                      if (formKeyId.currentState!.validate()) {
                                        setState(() {
                                          updateIdentifiant =
                                              !updateIdentifiant;
                                          userAction = 'userInfo';
                                        });
                                        alertDialog();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right: 30,
                                  left: 30,
                                ),
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
                                      setState(() {
                                        updateIdentifiant = !updateIdentifiant;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (updateIdentifiant == false) ...[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            right: 10,
                            left: 10,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: defautlCardColors,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 30,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nom complet',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: gry,
                                    ),
                                  ),
                                  Text(
                                    prefUserInfo['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            right: 10,
                            left: 10,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: defautlCardColors,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 30,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'E-mail',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: gry,
                                    ),
                                  ),
                                  Text(
                                    prefUserInfo['email'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            right: 20,
                            left: 20,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                'METTRE A JOUR',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 15,
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
                                setState(() {
                                  updateIdentifiant = !updateIdentifiant;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            right: 20,
                            left: 20,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.lock, color: blue),
                              label: Text(
                                'MOT DE PASSE',
                                style: GoogleFonts.montserrat(
                                  color: blue,
                                  fontSize: 15,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: blue),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  updatePassword = !updatePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                    if (updatePassword == true) ...[
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
                                    icon:
                                        _obscuretext == false
                                            ? Icon(
                                              Icons.visibility,
                                              color: Colors.black,
                                              size: 20,
                                            )
                                            : Icon(
                                              Icons.visibility_off,
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
                                    icon:
                                        _obscureNewtext == false
                                            ? Icon(
                                              Icons.visibility,
                                              color: Colors.black,
                                              size: 20,
                                            )
                                            : Icon(
                                              Icons.visibility_off,
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
                                validator: _passwordValidator,

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
                                    icon:
                                        _obscureConfirmtext == false
                                            ? Icon(
                                              Icons.visibility,
                                              color: Colors.black,
                                              size: 20,
                                            )
                                            : Icon(
                                              Icons.visibility_off,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmtext =
                                            !_obscureConfirmtext;
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
                              padding: EdgeInsets.only(
                                top: 20,
                                right: 20,
                                left: 20,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text(
                                    'METTRE A JOUR',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 15,
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
                                      setState(() {
                                        updatePassword = !updatePassword;
                                        userAction = 'motDePasse';
                                      });
                                      alertDialog();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                right: 20,
                                left: 20,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.arrow_back, color: red),
                                  label: Text(
                                    'ANNULER',
                                    style: GoogleFonts.montserrat(
                                      color: red,
                                      fontSize: 15,
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
                                    setState(() {
                                      updatePassword = !updatePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  File? image;
  Future takePhoto(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      alertUserImage();
    } on PlatformException catch (e) {}
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Modifier ma photo de profil",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 20, color: blue),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      takePhoto(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera, color: blue, size: 50),
                    label: Text(
                      'Camera',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      takePhoto(ImageSource.gallery);
                    },
                    icon: Icon(Icons.image, color: Colors.blue, size: 50),
                    label: Text(
                      'Galerie',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
