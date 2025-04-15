// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unused_local_variable, unused_field, must_be_immutable

import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sygeq/Athentification/ResertPassword.dart';
import 'package:sygeq/Pages/B2B/HomeB2b.dart';
import 'package:sygeq/Pages/Depot/HomeDepot.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Pages/Mic/HomeMic.dart';
import 'dart:async';

import 'package:sygeq/Pages/Station/HomeStation.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
Future<void> GetAddressFromLatLong(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];

    localisation =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}, ${place.subThoroughfare}, ${position.latitude.toString()};${position.longitude.toString()}";
  } catch (e) {}
}

class Login extends StatefulWidget {
  Function? getposition;
  Login({Key? key, this.getposition}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController txtLogin, txtPassword;
  bool _obscuretext = true;
  bool visibleErro = true;
  final formKey = GlobalKey<FormState>();
  bool progressIndicatorVisible = false;
  String loginuname = "";
  String password = "";
  String messageErro = "";

  authenticate() async {
    var data = await RemoteServices.authenticate(
      loginuname,
      password,
      ip,
      phones,
      localisation,
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtLogin = TextEditingController();
    txtPassword = TextEditingController();
  }

  @override
  void dispose() {
    txtLogin.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  _getCurrentPosition() async {
    //Permission
    LocationPermission permission = await Geolocator.checkPermission();
    // if (!mounted) return null;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position currentPosotion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() async {
        localisation = "$currentPosotion";
        GetAddressFromLatLong(currentPosotion);
        positionLat = currentPosotion.latitude;
        positionLog = currentPosotion.longitude;
      });
      setState(() {});
    }
  }

  deconnexion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefUserInfo.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext ctx) => Login()),
      (route) => false,
    );
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: _size.height / 9),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   backgroundColor: Color(0xFFF8F8FB),
                  //   child: Image(
                  //       width: 80,
                  //       height: 80,
                  //       image: AssetImage('assets/Images/default_image.png')),
                  // ),
                  Image(
                    height: _size.height / 7,
                    width: _size.width / 4,
                    image: AssetImage('assets/Images/default_image.png'),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 10),
                  //   child: Text(
                  //     "Bienvenue sur",
                  //     textAlign: TextAlign.start,
                  //     overflow: TextOverflow.ellipsis,
                  //     softWrap: true,
                  //     maxLines: 1,
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         color: blue,
                  //         fontSize: 20),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: DefaultTextStyle(
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: blue,
                        fontSize: 35,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'SyGeQ',
                            cursor: '',
                            speed: Duration(milliseconds: 500),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: _size.height / 30,
                      right: 30,
                      left: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "Connectez-vous pour acceder à votre compte",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(213, 70, 66, 66),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: _size.height / 30,
                      left: 20,
                      right: 20,
                    ),
                    child: TextFormField(
                      // controller: txtLogin,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(179, 208, 208, 233),
                        hintText: 'Nom d\'utilisateur',
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      validator: (val) {
                        return val!.length < 2
                            ? 'Le login doit comporter au moins 02 caratères'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          txtLogin.text = value;
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: _size.height / 50,
                      left: 20,
                      right: 20,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      obscureText: _obscuretext,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(179, 222, 222, 236),
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 5,
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
                        return vals!.length < 3
                            ? 'Le password doit comporter au moins 03 caractères'
                            : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          txtPassword.text = value;
                        });
                      },
                    ),
                  ),

                  Visibility(
                    child: Text(
                      messageErro,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.montserrat(
                        color: Color.fromARGB(255, 196, 102, 115),
                        fontSize: 13,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    visible: visibleErro,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child:
                          progressIndicatorVisible
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.8,
                                      color: blue,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    flex: 4,
                                    child: Text(
                                      "Veuillez patienter",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : ElevatedButton(
                                onPressed: () async {
                                  if (localisation.isNotEmpty) {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        loginuname = txtLogin.text.trim();
                                        password = txtPassword.text.trim();
                                        progressIndicatorVisible = true;
                                      });

                                      authenticate().then((val) async {
                                        if (val[0] == "true") {
                                          setState(() {
                                            progressIndicatorVisible = false;
                                          });
                                          Map<String, dynamic> payload =
                                              Jwt.parseJwt(val[1].toString());
                                          DateTime? expiryDate =
                                              Jwt.getExpiryDate(
                                                val[1].toString(),
                                              );
                                          prefs =
                                              await SharedPreferences.getInstance();
                                          prefs.setInt("idUser", payload['id']);
                                          prefs.setInt(
                                            "transporteurId",
                                            payload['transporteur_id'] ?? 0,
                                          );
                                          prefs.setInt(
                                            "marketerId",
                                            payload['marketer_id'] ?? 0,
                                          );
                                          prefs.setInt(
                                            "stationId",
                                            payload['station_id'] ?? 0,
                                          );
                                          prefs.setInt(
                                            "b2bId",
                                            payload['b2b_id'] ?? 0,
                                          );
                                          prefs.setInt(
                                            "passChanged",
                                            payload['passChanged'] ?? 0,
                                          );
                                          prefs.setInt(
                                            "depotId",
                                            payload['depot_id'] ?? 0,
                                          );
                                          prefs.setString(
                                            "email",
                                            payload['email'],
                                          );
                                          prefs.setString(
                                            "token",
                                            val[1].toString(),
                                          );
                                          prefs.setString(
                                            "password",
                                            txtPassword.text.trim(),
                                          );
                                          prefs.setString(
                                            "userImage",
                                            payload['image'] ?? '',
                                          );
                                          prefs.setString(
                                            "username",
                                            payload['username'],
                                          );
                                          prefs.setString(
                                            "name",
                                            payload['name'],
                                          );
                                          prefs.setString(
                                            "type",
                                            payload['type'],
                                          );
                                          prefs.setString(
                                            "role",
                                            payload['role'],
                                          );
                                          SharedPreferences prefsFirstLaunch =
                                              await SharedPreferences.getInstance();
                                          prefsFirstLaunch.setBool(
                                            'firstLaunch',
                                            true,
                                          );
                                          await getPrefUserInfo();
                                          setState(() {
                                            autorisation =
                                                "Bearer ${prefs.getString('token')}";
                                          });
                                          if (prefs
                                                  .getString('type')
                                                  .toString() ==
                                              "Marketer") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => HomeMarketer(),
                                              ),
                                            ).then((value) => deconnexion());
                                          } else if (prefs
                                                  .getString('type')
                                                  .toString() ==
                                              "Station") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    ((context) =>
                                                        HomeStation()),
                                              ),
                                            ).then((value) => deconnexion());
                                          } else if (prefs
                                                  .getString('type')
                                                  .toString() ==
                                              "Depot") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    ((context) => HomeDepot()),
                                              ),
                                            ).then((value) => deconnexion());
                                          } else if (prefs
                                                  .getString('type')
                                                  .toString() ==
                                              "MIC") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    ((context) => HomeMic()),
                                              ),
                                            ).then((value) => deconnexion());
                                          } else if (prefs
                                                  .getString('type')
                                                  .toString() ==
                                              "B2B") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    ((context) => HomeB2b()),
                                              ),
                                            ).then((value) => deconnexion());
                                          }
                                        } else if (val[0] == "false") {
                                          setState(() {
                                            progressIndicatorVisible = false;
                                            visibleErro = true;
                                            messageErro = val[1].toString();
                                          });
                                        }
                                      });
                                      await Future.delayed(
                                        Duration(seconds: 5),
                                      );
                                      setState(() {
                                        progressIndicatorVisible = false;
                                      });
                                    } else {}
                                  } else {
                                    setState(() {
                                      _getCurrentPosition();
                                    });
                                    Widget toast = Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                        color: Colors.redAccent,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.gps_fixed_outlined,
                                            size: 20,
                                          ),
                                          SizedBox(width: 12.0),
                                          Text(
                                            "Veuillez activer votre localisation",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    );
                                    fToast.showToast(
                                      child: toast,
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration: Duration(seconds: 4),
                                    );
                                  }
                                },
                                child: Text(
                                  'Connexion',
                                  // style: styleG,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  backgroundColor: blue,
                                  shape: RoundedRectangleBorder(
                                    // side: BorderSide(
                                    //   color: green,
                                    //   style: BorderStyle.solid,
                                    //   width: 4.0,
                                    // ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      // left: 20,
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResertPassword(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 133, 130, 130),
                      ),
                      label: Text(
                        "Mot de passe oublié ?",
                        // textHeightBehavior: TextHeightBehavior(),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          // decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationThickness: 5,
                          color: blue,
                          fontSize: 15,
                          textStyle: TextStyle(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
