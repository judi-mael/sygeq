// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ForwardPassword extends StatefulWidget {
  String loginUser;
  ForwardPassword({super.key, required this.loginUser});

  @override
  State<ForwardPassword> createState() => _ForwardPasswordState();
}

class _ForwardPasswordState extends State<ForwardPassword> {
  forgetPass() async {
    var data = await RemoteServices.forgetPassword(
      widget.loginUser,
      ip,
      phones,
      positionLog.toString(),
      positionLat.toString(),
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Icon(
                      Icons.mark_email_read_sharp,
                      color: blue,
                      size: 200,
                    ),
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
                        'Instructions Envoyés !',
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
                        'Nous avons envoyés des instructions de réinitialisation de mot de passe à \n ${widget.loginUser}',
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
                        child: ElevatedButton(
                          child: Text(
                            'OUVRIR MA BOITE EMAIL',
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
                          onPressed: () async {
                            if (!await launchUrl(
                              Uri.parse('https://gmail.com'),
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw 'Impossible de lancer le lien';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.refresh_rounded, color: blue),
                          label: Text(
                            'RENVOYER',
                            style: GoogleFonts.montserrat(
                              color: blue,
                              fontSize: 20,
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
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 30, left: 30),
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
    );
  }
}
