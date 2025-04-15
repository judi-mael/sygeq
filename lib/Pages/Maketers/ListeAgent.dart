// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/User.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/Detail/DetailUser.dart';

import 'package:sygeq/Pages/Maketers/NewUser.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';

class ListeAgent extends StatefulWidget {
  const ListeAgent({Key? key}) : super(key: key);

  @override
  State<ListeAgent> createState() => _ListeAgentState();
}

class _ListeAgentState extends State<ListeAgent> {
  List<User> listUser = [];
  getUser() async {
    var data = await MarketerRemoteService.allGetListeUser();
    // if (!mounted) return null;
    setState(() {
      listUser = data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        title: Text(
          "Mes Agents",
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleG,
        ),
      ),
      backgroundColor: gryClaie,
      body:
          listUser.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyList(),
                    EmptyMessage(),
                    TextButton.icon(
                      style: TextButton.styleFrom(backgroundColor: blue),
                      onPressed: () {
                        setState(() {
                          getUser();
                        });
                      },
                      icon: Icon(Icons.refresh, color: Colors.white, size: 30),
                      label: Text(
                        'Réessayer',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : SafeArea(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderMic(),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: Text(
                        "Liste de mes agents",
                        style: GoogleFonts.montserrat(fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, right: 20, left: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: listUser.length,
                          itemBuilder: (context, int index) {
                            return GestureDetector(
                              onTap: () {
                                User userL = listUser[index];
                                var data = {
                                  'id': listUser[index].id,
                                  'name': listUser[index].name,
                                  'email': listUser[index].email,
                                  'role': listUser[index].role,
                                  'type': listUser[index].type,
                                };
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailUser(data: data),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              listUser[index].name,
                                              style: styleG,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              listUser[index].role,
                                              style: styleG,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                "E-mail",
                                                style: styleG,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                listUser[index].email,
                                                style: styleG,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                "Adresse",
                                                style: styleG,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                listUser[index].adresse,
                                                style: styleG,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => NewUser())),
          ).then((value) => getUser());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
