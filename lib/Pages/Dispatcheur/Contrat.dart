// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sygeq/Helpers/Header.dart';
import 'package:sygeq/Models/Contrart.dart';
import 'package:sygeq/Pages/Dispatcheur/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/main.dart';

class TransMarkContratDispatcheur extends StatefulWidget {
  const TransMarkContratDispatcheur({Key? key}) : super(key: key);

  @override
  State<TransMarkContratDispatcheur> createState() =>
      _TransMarkContratDispatcheurState();
}

class _TransMarkContratDispatcheurState
    extends State<TransMarkContratDispatcheur> {
  final formKey = GlobalKey<FormState>();
  List<Contrat> listContrat = [];
  String id = "";
  markAddContrat() async {
    var data = await MarketerRemoteService.markAddContrat(id);
    return data;
  }

  markGetContrat() async {
    var data = await MarketerRemoteService.allGetContrat();
    setState(() {
      listContrat = data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    markGetContrat();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        title: Text(
          "Mes contrats",
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleG,
        ),
      ),
      backgroundColor: gryClaie,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            HeaderMic(),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Text(
                "Liste de mes transporteur",
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styleG,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listContrat.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          right: 10,
                          left: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    listContrat[index].driver.nom,
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: styleG,
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    listContrat[index].driver.agrement,
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: styleG,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    listContrat[index].driver.dateVigeur,
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: styleG,
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    listContrat[index].driver.dateExp,
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: styleG,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
            MaterialPageRoute(builder: ((context) => createContart())),
          ).then((value) => markGetContrat());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget createContart() {
    // bool obscure = true;

    return Scaffold(
      backgroundColor: gryClaie,
      appBar: AppBar(
        backgroundColor: green,
        centerTitle: true,
        title: Text(
          "Nouveau contrat",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: styleG,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              HeaderMic(),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    fit: FlexFit.loose,
                  ),
                  items: listMarkTransporteur.map((e) => e.nom).toList(),
                  validator:
                      (value) =>
                          value == null ? 'Choisissez le transporeur' : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      int index = listMarkTransporteur.indexWhere(
                        (element) => element.nom == newValue.toString(),
                      );
                      id = listMarkTransporteur[index].id.toString();
                    });
                  },
                  // isFilteredOnline: true,
                  // showSearchBox: true,
                  // showSelectedItems: true,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Transporteur',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                      style: styleG,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        markAddContrat().then((val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: green,
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
                        Navigator.pop(context);
                      } else {}
                    },
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
