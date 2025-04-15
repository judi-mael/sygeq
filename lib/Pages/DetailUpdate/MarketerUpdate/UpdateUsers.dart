// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unused_field, deprecated_member_use

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Services/RemoteService.dart';
import 'package:sygeq/main.dart';

class UpdateUsers extends StatefulWidget {
  var userL;
  UpdateUsers({Key? key, required this.userL}) : super(key: key);

  @override
  State<UpdateUsers> createState() => _UpdateUsersState();
}

class _UpdateUsersState extends State<UpdateUsers> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController txtEmail, txtName;
  String userRole = "";
  String typeUser = "";
  String station = "";
  bool _visible = false;
  depotAddUer() async {
    var data = await RemoteServices.allUpdateUser(
      id: widget.userL['id'].toString(),
      // username: txtUserName.text.trim().toString(),
      nom: txtName.text.trim().toString(),
      userEmail: txtEmail.text.trim().toString(),
      role: userRole,
      mic: prefUserInfo['type'],
      depot: prefUserInfo['depotId'].toString(),
      station: station.isEmpty ? prefUserInfo['stationId'].toString() : station,
      marketer: prefUserInfo['marketerId'].toString(),
    );
    return data;
  }

  @override
  void initState() {
    userRole = widget.userL['role'];
    txtEmail = TextEditingController(text: widget.userL['email']);
    txtName = TextEditingController(text: widget.userL['name']);
    // txtUserName = TextEditingController();
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
                  "Ajouter un utilisateur",
                  style: styleG,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Divider(),
                // Padding(
                //   padding: EdgeInsets.only(top: 110),
                //   child: Text('Ajoute d\'un nouvel Agent'),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    // left: 20,
                    // right: 20,
                  ),
                  child: TextFormField(
                    controller: txtName,
                    keyboardType: TextInputType.name,
                    // inputFormatters: [
                    // FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                    // ],
                    toolbarOptions: ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entré le nom et prénom de l\'utilisateur';
                      }
                      if (value.length < 4) {
                        return 'Nom prénom trop court';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      label: Text(
                        'Nom Complet',
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.only(
                //     top: 20,
                //     // left: 20,
                //     // right: 20,
                //   ),
                //   child: TextFormField(
                //     controller: txtUserName,
                //     keyboardType: TextInputType.name,
                //     inputFormatters: [
                //       FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                //     ],
                //     toolbarOptions: ToolbarOptions(
                //       copy: false,
                //       cut: false,
                //       paste: false,
                //       selectAll: false,
                //     ),
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Entré le user name';
                //       }
                //       if (value.length < 4) {
                //         return 'Le user name doit comporter aumoins 4 caractères';
                //       }
                //       return null;
                //     },
                //     decoration: InputDecoration(
                //       filled: true,
                //       label: Text(
                //         'Identifiant \ login',
                //         textScaleFactor: 1,
                //         overflow: TextOverflow.ellipsis,
                //         softWrap: true,
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //   ),
                // ),
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
                    // right: 20,
                    // left: 20,
                  ),
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      showSearchBox: true,
                    ),
                    items:
                        prefUserInfo['role'] == 'Super Admin'
                            ? ['Responsable', 'Utilisateur']
                            : ['Utilisateur'],
                    validator:
                        (value) => value == null ? 'Choisissez le rôle' : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Responsable') {
                          userRole = 'Admin';
                        }
                        if (newValue == 'Utilisateur') {
                          userRole = 'User';
                        }
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Rôle',
                      ),
                    ),
                  ),
                ),
                if (prefUserInfo['type'] == "Marketer") ...[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      // left: 20,
                      // right: 20,
                    ),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        fit: FlexFit.loose,
                        showSearchBox: true,
                      ),
                      items: ['Dispatcheur', 'Opérateur de Station'],
                      validator:
                          (value) =>
                              value == null ? 'Choisissez la station' : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          // dropdownValue = newValue!;
                          var t = newValue!;
                          if (t == "Opérateur de Station") {
                            _visible = true;
                          } else {
                            _visible = false;
                            station = '';
                          }
                        });
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Type d\'utilisateur',
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        // left: 20,
                        // right: 20,
                      ),
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          fit: FlexFit.loose,
                          showSearchBox: true,
                        ),
                        selectedItem: userRole,
                        items:
                            listMarkStation.map((e) => e.nomStation).toList(),
                        validator:
                            (value) =>
                                value == null ? 'Choisissez le rôle' : null,
                        onChanged: (String? newValue) {
                          setState(() {
                            int index = listMarkStation.indexWhere(
                              (element) => element.nomStation == newValue,
                            );
                            // dropdownValue = newValue!;
                            station = listMarkStation[index].id.toString();
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Station',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
