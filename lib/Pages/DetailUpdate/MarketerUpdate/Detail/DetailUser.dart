// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/UpdateMailUser.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/UpdateUsers.dart';
import 'package:sygeq/Services/RemoteServiceDisable.dart';
import 'package:sygeq/main.dart';

class DetailUser extends StatefulWidget {
  var data;
  // User userL;
  DetailUser({super.key, required this.data});

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  disable() async {
    var data = await RemoteServiceDisable.micDisable(
      widget.data['id'],
      0,
      'users',
    );
    return data;
  }

  restor() async {
    var data = await RemoteServiceDisable.micRestor(
      widget.data['id'],
      0,
      'users',
    );
    return data;
  }

  actionOnTheEditUser(var data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            insetPadding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              child: UpdateUsers(userL: data),
            ),
          ),
        );
      },
    );
  }

  actionOnTheEditMailUser(var data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            insetPadding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              child: UpdateMailUser(userL: data),
            ),
          ),
        );
      },
    );
  }

  restoralertDialog() {
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
                  "Vous allez restaurer ${widget.data['nom']}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                  style: styleG,
                ),
                Text(
                  "Vous êtes sur de vouloir continuer?",
                  maxLines: 2,
                  softWrap: true,
                  style: styleG,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                restor();
                Navigator.pop(context);
                Navigator.pop(context);
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
                  "Vous allez désactiver ${widget.data['name']}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                  style: styleG,
                ),
                Text(
                  "Vous êtes sur de vouloir continuer?",
                  maxLines: 2,
                  softWrap: true,
                  style: styleG,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                disable();
                Navigator.pop(context);
                Navigator.pop(context);
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
    Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Detail User',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: styleG,
                ),
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: blue),
                    onPressed: () {
                      Navigator.pop(context);
                      actionOnTheEditMailUser(widget.data);
                    },
                    child: Text(
                      "Modifier E-mail",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: GoogleFonts.montserrat(color: white),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // shape: BoxShape.circle,
                      color: blue,
                    ),
                    width:
                        _size.height < _size.width
                            ? _size.width / 13
                            : _size.height / 15,
                    height:
                        _size.height < _size.width
                            ? _size.width / 18
                            : _size.height / 20,
                    child: IconButton(
                      color: blue,
                      visualDensity: VisualDensity.standard,
                      style: IconButton.styleFrom(backgroundColor: blue),
                      icon: Icon(Icons.edit, color: white),
                      onPressed: () {
                        Navigator.pop(context);
                        actionOnTheEditUser(widget.data);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      "Nom : ",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Text(
                      widget.data['name'],
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: styleG,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      "E-mail : ",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Text(
                      widget.data['email'],
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: styleG,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      "Rôle : ",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.data['role'],
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: styleG,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      "Type : ",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.data['type'],
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: styleG,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity,
                child:
                    widget.data['delete'] == null
                        ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            alertDialog();
                          },
                          child: Text(
                            "Désactiver",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: btnTxtCOlor,
                          ),
                        )
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            restoralertDialog();
                          },
                          child: Text(
                            "Restaurer",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleG,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
