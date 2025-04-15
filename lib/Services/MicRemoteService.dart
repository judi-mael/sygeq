// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:sygeq/Models/CountElement.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/main.dart';

class RemoteServiceMic {
  static var client = http.Client();
  static String autorisation =
      "Bearer"
          " " +
      prefUserInfo['token'].toString();

  static Future<dynamic> micAddDepot(
    String numdepot,
    String nom,
    String ifu,
    String agrement,
    String userEmail,
    String adresse,
    String idVille,
    String datestart,
    String dateEnd,
    String uname,
    String username,
    List listId,
    List listDistance,
    List listDifficultee,
    List listPrime,
  ) async {
    List detailsVilles = [];
    for (int i = 0; listId.length > i; i++) {
      detailsVilles.add({
        'ville_id': listId[i],
        'difficultee': listDifficultee[i],
        'distance': listDistance[i],
        'prime': listPrime[i],
      });
    }
    try {
      var response = await client.put(
        Uri.parse(uRl + "depots"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'username': uname,
          'numdepotdouanier': numdepot,
          'agrement': agrement,
          'ifu': ifu,
          'email': userEmail,
          'nom': nom,
          'ville_id': idVille,
          'name': username,
          'adresse': adresse,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
          'detailsVilles': detailsVilles,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return showToast("Modification éffectuée.");
      } else {
       var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateDepot(
    int id,
    String numdepot,
    String nom,
    String ifu,
    String agrement,
    // String userEmail,
    String adresse,
    String datestart,
    String dateEnd,
    // String uname,
    // String username,
  ) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "depots/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          // 'username': uname,
          'numdepotdouanier': numdepot,
          'agrement': agrement,
          'ifu': ifu,
          // 'email': userEmail,
          'nom': nom,
          // 'name': username,
          'adresse': 0,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
          'adresse_user': {},
          'adresse_depot': {},
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddTransporteur(
    String nom,
    String ifu,
    String agrement,
    // String userEmail,
    String adresse,
    String datestart,
    String dateEnd,
    String ifuDoc,
    String agreDoc,
    // String uname,
    // String username,
  ) async {
    final bytesifu = File(ifuDoc).readAsBytesSync();
    String file64ifu = base64Encode(bytesifu);
    final bytesagre = File(agreDoc).readAsBytesSync();
    String file64agre = base64Encode(bytesagre);
    try {
      var response = await client.put(
        Uri.parse(uRl + "trs"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'agrement': agrement,
          'ifu': ifu,
          'nom': nom,
          'adresse': adresse,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
          'document_agrement': file64agre,
          'document_ifu': file64ifu,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return showToast("Transporteur ajouté avec succès.");
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateTransporteur(
    int id,
    String nom,
    String ifu,
    String agrement,
    // String userEmail,
    String adresse,
    String datestart,
    String dateEnd,
  ) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "trs/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          // 'username': username,
          'agrement': agrement,
          'ifu': ifu,
          // 'email': userEmail,
          'nom': nom,
          // 'name': uname,
          'adresse': adresse,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
          // 'adresse_user': {},
          // 'adresse_transporteur': {},
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddMarketer(
    String nom,
    String ifu,
    String agrement,
    String userEmail,
    String adresse,
    String datestart,
    String dateEnd,
    String uname,
    String username,
    String ifuDoc,
    String agreDoc,

    // String upassword,
  ) async {
    final bytesifu = File(ifuDoc).readAsBytesSync();
    String file64ifu = base64Encode(bytesifu);
    final bytesagre = File(agreDoc).readAsBytesSync();
    String file64agre = base64Encode(bytesagre);
    try {
      var response = await client.put(
        Uri.parse(uRl + "marketers"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'username': username,

          'agrement': agrement,
          'ifu': ifu,
          'email': userEmail,
          'nom': nom,
          'name': uname,
          'adresse': adresse,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
          'document_agrement': file64agre,
          'document_ifu': file64ifu,

          // 'adresse_user': {},
          // 'adresse_marketer': {},
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return showToast("Marketer ajouté avec succès.");
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateMarketer(
    int id,
    String nom,
    String ifu,
    String agrement,
    // String userEmail,
    String adresse,
    String datestart,
    String dateEnd,
    // String uname,
    // String username,
    // String upassword,
  ) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "marketers/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'agrement': agrement,
          'ifu': ifu,
          'nom': nom,
          'adresse': adresse,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
          // 'adresse_user': {},
          // 'adresse_marketer': {},
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddVille(
    String nom,
    // String dep,
    // String difficulte,
    // String prime,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "villes"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'nom': nom}),
        // 'dep': dep,
        // 'difficulte': difficulte,
        // 'prime': prime,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateVille(
    String nom,
    String dep,
    String difficulte,
    String prime,
    int id,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "villes/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'nom': nom,
          'dep': dep,
          'difficulte': difficulte,
          'prime': prime,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        var resultt = json.decode(response.body.toString());
        return showToast("Modification éffectuée.");
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(
          result["message"]
        );
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddTauxForfait(
    String taux,
    // String distance,
    String datestart,
    String dateEnd,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "tfs"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'tarifforfait': taux,
          // 'distance': distance,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateTauxForfait(
    String taux,
    String distance,
    String datestart,
    String dateEnd,
    int id,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "tfs/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'tarifforfait': taux,
          'distance': distance,
          'dateVigueur': datestart,
          'dateExpiration': dateEnd,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddTauxTK(
    String valeurTK,
    String ref,
    String datestart,
    String dateEnd,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "ttks"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'valeurtk': valeurTK,
          'ref': ref,
          'date_debut': datestart,
          'date_fin': dateEnd,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateTauxTK(
    String valeurTK,
    String ref,
    String datestart,
    String dateEnd,
    int id,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "ttks/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'valeurtk': valeurTK,
          'ref': ref,
          'date_debut': datestart,
          'date_fin': dateEnd,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddProduit(
    String nom,
    String hscode,
    String type,
    String mesure,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "produits"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'nom': nom,
          'hscode': hscode,
          'type': type,
          'unite': mesure,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micupdateProduit(
    String nom,
    String hscode,
    String type,
    int id,
  ) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "produits/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'nom': nom, 'hscode': hscode, 'type': type}),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micupdateContart(String statut, int id) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "contrats/${statut.toLowerCase()}/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        // body: json.encode({
        //   'statut': statut,
        // }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddCamion(
    String immatriculation,
    String nbrVanne,
    String annee,
    String type,
    String marque,
    String transporteur,
    String ssat,
    var data,
    String slp,
    String certificat,
    String visite,
    String assurance,
    String debutSLP,
    String finSLP,
    String debutCB,
    String finCB,
    String debutVT,
    String finVT,
    String debutAss,
    String finAss,
  ) async {
    var list = [];
    for (int i = 0; data.length > i; i++) {
      list.add({
        'numero': data[i].toString().split(';')[0],
        'capacite': int.parse(data[i].toString().split(';')[1]),
      });
    }
    final bytesSlp = File(slp).readAsBytesSync();
    String file64Slp = base64Encode(bytesSlp);
    final bytescertificat = File(certificat).readAsBytesSync();
    String file64certificat = base64Encode(bytescertificat);
    final bytesvisite = File(visite).readAsBytesSync();
    String file64visite = base64Encode(bytesvisite);
    final bytesAssurance = File(assurance).readAsBytesSync();
    String file64Assurance = base64Encode(bytesAssurance);

    try {
      var response = await client.put(
        Uri.parse(uRl + "camions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'imat': immatriculation,
          'nbrVanne': nbrVanne,
          'annee': annee,
          'type': type,
          'marque': marque,
          'transporteur_id': transporteur,
          'compartiments': list,
          'ssat_id': ssat,
          'cb': {
            'date_debut': debutCB,
            'date_fin': finCB,
            'doc': file64certificat,
          },
          'vt': {'date_debut': debutVT, 'date_fin': finVT, 'doc': file64visite},
          'slp': {'date_debut': debutSLP, 'date_fin': finSLP, 'doc': file64Slp},
          'insurance': {
            'date_debut': debutAss,
            'date_fin': finAss,
            'doc': file64Assurance,
          },
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return json.decode(response.body.toString());
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateCamion(
    int id,
    String immatriculation,
    String nbrVanne,
    String annee,
    String type,
    String marque,
    // String datestart,
    // String dateEnd,
    String transporteur,
    String ssat,
    var data,
    String slp,
    String certificat,
    String visite,
    String assurance,
    // String username,
    // String upassword,
  ) async {
    var list = [];
    Uint8List bytesSlp;
    Uint8List bytescertificat;
    Uint8List bytesvisite;
    Uint8List bytesAssurance;
    String file64Slp;
    String file64certificat;
    String file64visite;
    String file64Assurance;

    if (slp.isNotEmpty) {
      bytesSlp = File(slp).readAsBytesSync();
      file64Slp = base64Encode(bytesSlp);
    }
    if (certificat.isNotEmpty) {
      bytescertificat = File(certificat).readAsBytesSync();
      file64certificat = base64Encode(bytescertificat);
    }
    if (visite.isNotEmpty) {
      bytesvisite = File(visite).readAsBytesSync();
      file64visite = base64Encode(bytesvisite);
    }
    if (assurance.isNotEmpty) {
      bytesAssurance = File(assurance).readAsBytesSync();
      file64Assurance = base64Encode(bytesAssurance);
    }

    for (int i = 0; data.length > i; i++) {
      list.add({
        // 'numero': 0,
        // 'capacite': 1
        'numero': data[i].toString().split(';')[0],
        'capacite': int.parse(data[i].toString().split(';')[1]),
      });
    }
    try {
      var response = await client.patch(
        Uri.parse(uRl + "camions/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'imat': immatriculation,
          'nbrVanne': nbrVanne,
          'annee': annee,
          'type': type,
          'marque': marque,
          'transporteur_id': transporteur,
          'compartiments': list,
          'ssat_id': ssat,
          // 'name': uname,
          // 'adresse': adresse,
          // 'dateVigueur': datestart,
          // 'dateExpiration': dateEnd,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micAddStation(
    String agrement,
    // String ifu,
    String nom,
    String ville,
    String adresse,
    String marketer,

    // String uname,
    // String username,
    // String login,
    // String email,
    // String upassword,
    int poi,
    String latitude,
    String longitude,
    String licence,
    String dateStart,
    String dateEnd,
    // String rc,
  ) async {
    if (prefUserInfo['marketerId'].toString() != '0') {
      marketer = prefUserInfo['marketerId'].toString();
    }

    final bytesLicence = File(licence).readAsBytesSync();
    String file64Licence = base64Encode(bytesLicence);
    try {
      var response = await client.put(
        Uri.parse(uRl + "stations"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          // 'ifu': ifu,
          'ville_id': ville,
          'marketer_id': marketer,
          'nom': nom,
          'adresse': adresse,
          'poi_id': poi.toString(),
          'latitude': latitude,
          'longitude': longitude,
          'licenceExploitation': {
            'doc': file64Licence,
            'date_debut': dateStart,
            'date_fin': dateEnd,
          },
          // 'rccm': rc,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
     return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateStation(
    int id,
    String agrement,
    // String ifu,
    String nom,
    int ville,
    String adresse,
    int marketer,
    // String datestart,
    // String dateEnd,
    // String uname,
    // String username,
    // String login,
    // String email,
    // String upassword,
    int poi,
    String latitude,
    String longitude,
    // String rc,
  ) async {
    marketer =
        prefUserInfo['marketerId'].toString() == "0"
            ? marketer
            : prefUserInfo['marketerId'];
    try {
      var response = await client.patch(
        Uri.parse(uRl + "stations/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'ville_id': ville,
          'marketer_id': marketer,
          'nom': nom,
          'adresse': adresse,
          'poi_id': poi.toString(),
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> micUpdateB2B(
    int id,
    String agrement,
    String ifu,
    String nom,
    int ville,
    String adresse,
    int marketer,
    String ifuDoc,
    String agreDoc,
  ) async {
    final bytesifu = File(ifuDoc).readAsBytesSync();
    String file64ifu = base64Encode(bytesifu);
    final bytesagre = File(agreDoc).readAsBytesSync();
    String file64agre = base64Encode(bytesagre);
    marketer =
        prefUserInfo['marketerId'].toString() == '0'
            ? marketer
            : prefUserInfo['marketerId'];
    try {
      var response = await client.patch(
        Uri.parse(uRl + "b2bs/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'ville_id': ville,
          'marketer_id': marketer,
          'nom': nom,
          'adresse': adresse,
          'agrement': agrement,
          'ifu': ifu,
          'document_agrement': file64agre,
          'document_ifu': file64ifu,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }
  ////////////////////////////////////
  ///Get la liste des dépôts
  ///////////////////////////////////

  static Future micGetListeDepot() async {
    List<Depot> listDepot = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "depots"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listDepot = list.map((i) => Depot.fromJson(i)).toList();
      return listDepot;
    } else {
      var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
    }
  }

  static Future miccCountElement() async {
    CountElement countElement;
       
    // try {
    var response = await client.get(
      Uri.parse(uRl + "bilans/count_element"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      countElement  = CountElement(marketer: result["marketer"], station: result["station"], transporteur: result["transporteur"], depot: result["depot"], b2b: result["b2b"], camion: result["camion"],);
      return countElement;
    } else {
      var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
    }
  }
}
