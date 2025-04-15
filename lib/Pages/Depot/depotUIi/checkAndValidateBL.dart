import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Services/DepotRemoteService.dart';
import 'package:sygeq/main.dart';

class CheckAndValidateBl extends StatefulWidget {
  final BonL bonBl;
  const CheckAndValidateBl({Key? key, required this.bonBl}) : super(key: key);

  @override
  State<CheckAndValidateBl> createState() => _CheckAndValidateBlState();
}

class _CheckAndValidateBlState extends State<CheckAndValidateBl> {
  late TextEditingController txtCommentaire;
  final formKey = GlobalKey<FormState>();
  int id = 0;
  String statut = "";
  bool visible = false;
  bool isExpand = false;
  String commentaire = "";
  rejetBl() async {
    var data = await RemoteDepotService.updateBlDepot(
      id: id,
      state: statut,
      commentaire: commentaire,
    );
    return data;
  }

  confirmeBl() async {
    var data = await RemoteDepotService.updateBlDepot(
      id: id,
      state: statut,
      commentaire: commentaire,
    );
    return data;
  }

  @override
  void initState() {
    super.initState();
    txtCommentaire = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: 5, right: 5, left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, size: 40),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                widget.bonBl.numeroBl,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                widget.bonBl.station.nom,
                textAlign: TextAlign.start,
                style: styleG,
                // style: TextStyle(fontSize: 17),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: ExpansionPanelList(
                elevation: 0,
                dividerColor: blue,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    isExpand = !isExpand;
                  });
                  setState(() {});
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpended) {
                      return ListTile(
                        title: Text(
                          "Produits",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      );
                    },
                    isExpanded: true,
                    body: ListTile(
                      title: Column(
                        children: [
                          for (
                            int i = 0;
                            widget.bonBl.produits.length > i;
                            i++
                          ) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    widget.bonBl.produits[i].produit.nom,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.blue[300],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    '${widget.bonBl.produits[i].qtte} ${widget.bonBl.produits[i].produit.unite}',
                                    softWrap: true,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Form(
                key: formKey,
                child: TextFormField(
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  toolbarOptions: ToolbarOptions(
                    copy: false,
                    cut: false,
                    paste: true,
                    selectAll: false,
                  ),
                  maxLength: 1500,
                  maxLines: 5,

                  decoration: InputDecoration(
                    hintText:
                        "Le champs commentaire est obligatoire si vous voulez rejeter le BL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(
                      "Commentaire",
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleG,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    return value!.isEmpty ? 'Ajouter de commentaire' : null;
                  },
                  onChanged: (value) {
                    txtCommentaire.text = value;
                  },
                ),
              ),
            ),
            widget.bonBl.statut != "Bon à Charger"
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            id = widget.bonBl.id;
                            statut = "Bon à Charger";
                            txtCommentaire.clear();
                          });
                          confirmeBl();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text(
                          "Valider",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            id = widget.bonBl.id;
                            statut = "Rejeté";
                          });

                          if (formKey.currentState!.validate()) {
                            rejetBl();
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                        child: Text(
                          "Rejeter",
                          softWrap: true,
                          maxLines: 1,
                          textScaleFactor: 1.2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        id = widget.bonBl.id;
                        statut = "Rejeté";
                      });

                      if (formKey.currentState!.validate()) {
                        rejetBl();
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    child: Text(
                      "Rejeter",
                      softWrap: true,
                      maxLines: 1,
                      textScaleFactor: 1.2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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
