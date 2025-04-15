// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unrelated_type_equality_checks, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sygeq/Models/Camion.dart';
import 'package:sygeq/Models/Compartiment.dart';
import 'package:sygeq/Models/Depot.dart';
import 'package:sygeq/Models/Driver.dart';
import 'package:sygeq/Models/MNotifications.dart';
import 'package:sygeq/Models/Marketer.dart';
import 'package:sygeq/Models/Produit.dart';
import 'package:sygeq/Models/SsatMarkers.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/Models/TauxForfait.dart';
import 'package:sygeq/Models/Tauxtks.dart';
import 'package:sygeq/Models/User.dart';
import 'package:sygeq/Models/Viehicul.dart';
import 'package:sygeq/Models/Ville.dart';
import 'package:sygeq/Statistiques/MicStatProduit.dart';
import 'package:sygeq/Statistiques/MicStatProduitMarketer.dart';
import 'package:sygeq/Statistiques/StartPerRegion.dart';

import 'package:sygeq/main.dart';

class RemoteServices {
  static var client = http.Client();
  // static String autorisation = "Bearer ${prefUserInfo['token']}";
  // static String autorisation = "Bearer" " " + prefUserInfo['token'].toString();

  static Future<dynamic> authenticate(
    String uname,
    String password,
    String pp,
    String tel,
    String loc,
  ) async {
    try {
      var response = await client.post(
        Uri.parse(uRl + "auth/uname-login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': uname,
          'password': password,
          'ip': pp,
          'appareil': tel,
          'localisation': loc,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      var ssss = [];
      var success = true;
      if (response.statusCode == 200) {
        ssss.add("true");
        ssss.add(json.decode(response.body)['access_token']);
        var res = json.encode(ssss);
        return json.decode(res);
      } else {
        ssss.add("false");
        ssss.add(json.decode(response.body)['message']);

        var res = json.encode(ssss);
        return json.decode(res);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> getRapportPerMarketer([
    String? dateStat,
    String? dateEnd,
    List? marketerIds,
  ]) async {
    var response;
    try {
      if (marketerIds!.length == 0) {
        response = await client.post(
          Uri.parse(uRl + "bilans/get-perequations"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': autorisation,
          },
          body: json.encode({'startDate': dateStat, 'endDate': dateEnd}),
          encoding: Encoding.getByName("utf-8"),
        );
      } else {
        response = await client.post(
          Uri.parse(uRl + "bilans/get-perequations"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': autorisation,
          },
          body: json.encode({
            'startDate': dateStat,
            'endDate': dateEnd,
            'marketer_ids': marketerIds,
          }),
          encoding: Encoding.getByName("utf-8"),
        );
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future allGetListeUser() async {
    List<User> listUser = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "users"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listUser = list.map((e) => User.fromJson(e)).toList();
      return listUser;
    }
  }

  static Future newVersion() async {
    // List<User> listUser = [];
    var version;
    var response = await client.get(
      Uri.parse(uRl + "version"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      version = result;
      return version;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future<dynamic> allUpdateMailUser({
    String? id,
    String? userEmail,
  }) async {
    Object data = [];

    data = json.encode({'email': userEmail});

    try {
      var response = await client.patch(
        Uri.parse(uRl + "users/change_mail/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        return {
          "message": "Les informations utilisateur modifiées avec succès",
        };
      } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> allUpdateUser({
    String? id,
    String? userEmail,
    String? nom,
    String? username,
    String? marketer,
    String? depot,
    String? mic,
    String? type,
    String? station,
    String? transporteur,
    String? role,
  }) async {
    Object data = [];
    if (marketer!.isNotEmpty && marketer != '0') {
      if (station!.isNotEmpty) {
        data = json.encode({
          'name': nom,
          'email': userEmail,
          'role': role,
          // 'username': username,
          'marketerId': prefUserInfo['marketerId'],
          'type': 'Station',
          'stationId': station,
        });
      } else {
        data = json.encode({
          'name': nom,
          'email': userEmail,
          'role': role,
          // 'username': username,
          'type': 'Marketer',
          'marketerId': prefUserInfo['marketerId'],
        });
      }
    }
    if (depot!.isNotEmpty && depot != '0') {
      data = json.encode({
        // 'username': username,
        'email': userEmail,
        'name': nom,
        'role': role,
        'type': 'Depot',
        'depotId': prefUserInfo['depotId'],
      });
    }
    if (mic == "MIC") {
      data = json.encode({
        // 'username': username,
        'email': userEmail,
        'name': nom,
        'role': role,
        'type': 'MIC',
      });
    }
    try {
      var response = await client.patch(
        Uri.parse(uRl + "users/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        return {
          "message": "Les informations utilisateur modifiées avec succès",
        };
      } else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> allAddUser({
    String? userEmail,
    String? nom,
    String? username,
    String? marketer,
    String? depot,
    String? mic,
    String? type,
    String? station,
    String? transporteur,
    String? role,
  }) async {
    Object data = [];
    if (marketer!.isNotEmpty && marketer != '0') {
      if (station!.isNotEmpty) {
        data = json.encode({
          'name': nom,
          'email': userEmail,
          'role': role,
          'username': username,
          'marketerId': prefUserInfo['marketerId'],
          'type': 'Station',
          'stationId': station,
        });
      } else {
        data = json.encode({
          'name': nom,
          'email': userEmail,
          'role': role,
          'username': username,
          'type': 'Marketer',
          'marketerId': prefUserInfo['marketerId'],
        });
      }
    }
    if (depot!.isNotEmpty && depot != '0') {
      data = json.encode({
        'username': username,
        'email': userEmail,
        'name': nom,
        'role': role,
        'type': 'Depot',
        'depotId': prefUserInfo['depotId'],
      });
    }
    if (mic == "MIC") {
      data = json.encode({
        'username': username,
        'email': userEmail,
        'name': nom,
        'role': role,
        'type': 'MIC',
      });
    }
    try {
      var response = await client.put(
        Uri.parse(uRl + "users"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        return {"message": "Utilisateur ajouter avec succès"};
      } else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> forgetPassword(
    String email,
    String pp,
    String tel,
    String long,
    String lat,
  ) async {
    try {
      var response = await client.post(
        Uri.parse(uRl + "users/password-reset"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          // 'password': password,
          'ip': pp,
          'device': tel,
          'longitude': long,
          'latitude': lat,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      var ssss = [];
      var success = true;
      // if (response.statusCode == 200) {
      // var a = json.decode(response.body.toString());
      if (response.statusCode == 200) {
        ssss.add("true");
        ssss.add(json.decode(response.body)['access_token']);
        var res = json.encode(ssss);
        return res;
      } else {
        ssss.add("false");
        ssss.add(json.decode(response.body)['message']);

        var res = json.encode(ssss);
        return json.decode(res);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  ///////////////////////////////////////////
  /// get all villes
  /// ///////////////////////////////

  static Future allGetListeVilles() async {
    List<Ville> listVille = [];
    List list = [];

    var response = await client.get(
      Uri.parse(uRl + "villes"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listVille = list.map((i) => Ville.fromJson(i)).toList();
      return listVille;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeNotifications() async {
    List<MNotification> listNotifications = [];
    List list = [];

    var response = await client.get(
      Uri.parse(uRl + "notifications"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result as List;
      listNotifications = list.map((i) => MNotification.fromJson(i)).toList();

      return listNotifications;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeStation() async {
    List<Station> listStation = [];
    List list = [];
    // try {
    var response = await client.get(
      Uri.parse(uRl + "stations/filter-by/type/stations-only"),
      // Uri.parse(uRl + "stations"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());

      list = result["data"] as List;

      listStation = list.map((i) => Station.fromJson(i)).toList();

      return listStation;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetDepotInterieur() async {
    List<Depot> listDepot = [];
    List list = [];
    // try {
    var response = await client.get(
      Uri.parse(uRl + "depots/bytype/INTERIEUR"),
      // Uri.parse(uRl + "stations"),
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
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeB2B() async {
    List<Station> listStation = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "b2bs"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      // list = result as List;
      list = result["data"] as List;
      listStation = list.map((i) => Station.fromJson(i)).toList();
      return listStation;
    } else {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeStationNoFilter() async {
    List<Station> listStation = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "stations/poi/listt/no-filter"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listStation = list.map((i) => Station.fromJson(i)).toList();
      return listStation;
    } else {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  ///////////////////////////////////////////
  /// get all produits
  /// ///////////////////////////////
  static Future allGetListeProduits() async {
    List<Produit> listProduit = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "produits"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listProduit = list.map((i) => Produit.fromJson(i)).toList();
      return listProduit;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    
  }

  ///////////////////////////////////////////
  /// get all compartiment
  /// ///////////////////////////////
  static Future allGetListeCommpartiment() async {
    List<Compartiment> listCompartiment = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "compartiments"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listCompartiment = list.map((i) => Compartiment.fromJson(i)).toList();
      return listCompartiment;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    
  }

  ///////////////////////////////////////////
  /// get all TauxTK
  /// ///////////////////////////////
  static Future allGetListeTauxTK() async {
    List<Tauxtks> listTauxTK = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "ttks/filter-by-statut/inactive"),
      // Uri.parse(uRl + "ttks"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTauxTK = list.map((i) => Tauxtks.fromJson(i)).toList();
      return listTauxTK;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeTauxTKActif() async {
    List<Tauxtks> listTauxTKActif = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "ttks/filter-by-statut/active"),
      // Uri.parse(uRl + "ttks"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTauxTKActif = list.map((i) => Tauxtks.fromJson(i)).toList();
      return listTauxTKActif;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  ///////////////////////////////////////////
  /// get all Taux Forfaitaire
  /// ///////////////////////////////
  static Future allGetListeTauxForfait() async {
    List<TauxForfait> listTauxForfait = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "tfs/filter-by-statut/inactive"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTauxForfait = list.map((i) => TauxForfait.fromJson(i)).toList();
      return listTauxForfait;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeTauxForfaitActif() async {
    List<TauxForfait> listTauxForfait = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "tfs/filter-by-statut/active"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTauxForfait = list.map((i) => TauxForfait.fromJson(i)).toList();
      return listTauxForfait;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future micGetSsatListStation() async {
    List<SsatMarkers> listTauxForfait = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "stations/poi/list"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result as List;
      listTauxForfait = list.map((i) => SsatMarkers.fromJson(i)).toList();
      return listTauxForfait;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future micGetSsatListStationNoFilter() async {
    List<SsatMarkers> listTauxForfait = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "stations/poi/list/no-filter"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result as List;
      listTauxForfait = list.map((i) => SsatMarkers.fromJson(i)).toList();
      return listTauxForfait;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future micGetSsatListVehicul() async {
    List<Vehicule> listVehicul = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "camions/ssat/list"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result as List;
      listVehicul = list.map((i) => Vehicule.fromJson(i)).toList();
      return listVehicul;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future micGetSsatListVehiculNoFilter() async {
    List<Vehicule> listVehicul = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "camions/ssat/list/no-filter"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result as List;
      listVehicul = list.map((i) => Vehicule.fromJson(i)).toList();
      return listVehicul;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  ///////////////////////////////////////////
  /// get all Transporteurs
  /// ///////////////////////////////
  static Future allGetListeTransporteur() async {
    List<Driver> listTransporteur = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "trs"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTransporteur = list.map((i) => Driver.fromJson(i)).toList();
      return listTransporteur;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeTransporteurC() async {
    List<Driver> listTransporteur = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "trs/filter-by/contractuals"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTransporteur = list.map((i) => Driver.fromJson(i)).toList();
      return listTransporteur;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeTransporteurNC() async {
    List<Driver> listTransporteur = [];
    List list = [];
    var parametre = {};

    // try {
    var response = await client.get(
      Uri.parse(uRl + "trs/filter-by/contractables"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTransporteur = list.map((i) => Driver.fromJson(i)).toList();
      return listTransporteur;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future statPerProduit([String? dateStart, String? dateEnd]) async {
    List<StaProduit> listPerProduit = [];
    List list = [];
    var response;
    if (dateStart != null && dateEnd != null) {
      response = await client.get(
        Uri.parse(
          uRl + "bilans/mic/quantities-per-products/$dateStart/$dateEnd",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
    } else {
      response = await client.get(
        Uri.parse(uRl + "bilans/mic/quantities-per-products"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
    }
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listPerProduit = list.map((i) => StaProduit.fromJson(i)).toList();
      return listPerProduit;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future statPerRegion([String? dateStart, String? dateEnd]) async {
    List<StartPerRegion> listPerRegion = [];
    List list = [];
    print("jrertjgekjhrtkjh $dateStart");
    // var response;
    // if (dateStart != null && dateEnd != null) {
      var response = await client.get(
        Uri.parse(
          uRl + "bilans/quantities-per-products-per-area/$dateStart/$dateEnd",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
    // } else {
    //   response = await client.get(
    //     Uri.parse(uRl + "bilans/quantities-per-products-per-area"),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': autorisation,
    //     },
    //   );
    // }
    print("jrertjgekjhrtkjh ${response.statusCode}");
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listPerRegion = list.map((i) => StartPerRegion.fromJson(i)).toList();
      return listPerRegion;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future statPerProduitMarketer([
    String? dateStart,
    String? dateEnd,
  ]) async {
    List<StarProduitMarketer> listPerProduitMarketer = [];
    List list = [];
    var response;
    if (dateStart != null && dateEnd != null) {
      response = await client.get(
        Uri.parse(
          uRl + "bilans/mic/quantities-per-marketers/$dateStart/$dateEnd",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
    } else {
      response = await client.get(
        Uri.parse(uRl + "bilans/mic/quantities-per-marketers"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
    }
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listPerProduitMarketer =
          list.map((i) => StarProduitMarketer.fromJson(i)).toList();
      return listPerProduitMarketer;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future getAllMarketerList() async {
    List<Marketer> listMicMarketer = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + 'marketers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result['data'] as List;
      listMicMarketer = list.map((e) => Marketer.fromJson(e)).toList();
      return listMicMarketer;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future llGetListeMarketer() async {
    List<Marketer> listMarketers = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "marketers"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listMarketers = list.map((i) => Marketer.fromJson(i)).toList();

      return listMarketers;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  ///////////////////////////////////////////
  /// get all Camions
  /// ///////////////////////////////
  static Future allGetListeCamions() async {
    List<Camion> listCamion = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "camions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());

      list = result["data"] as List;

      listCamion = list.map((i) => Camion.fromJson(i)).toList();
      return listCamion;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetDriverCamions({int dd = 0}) async {
    List<Camion> listCamion = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "camions/as-marketer/filter-by-tr/$dd"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listCamion = list.map((i) => Camion.fromJson(i)).toList();
      return listCamion;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    
  }

  static Future allGetListedepot() async {
    List<Depot> listDepot = [];
    List list = [];

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
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future getCompartiment() async {
    List<Compartiment> listCompartiment = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "Compartiments/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listCompartiment = list.map((i) => Compartiment.fromJson(i)).toList();
      return listCompartiment;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    
  }

  static Future getUserProfilImage() async {
    var response = await client.get(
      Uri.parse(uRl + "users/profile/picture"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future getVersion() async {
    var response = await client.get(
      Uri.parse(uRl + "version"),
      headers: {'Content-Type': 'application/json', 'Authorization': ""},
    );
    if (response.statusCode == 200) {
      return response.body;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future getOneCompartiment(int camion) async {
    List<Compartiment> listCompartiment = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "Compartiments/$camion"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listCompartiment = list.map((i) => Compartiment.fromJson(i)).toList();
      return listCompartiment;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    
  }

  static Future<dynamic> changepassword(String oldPass, String newPass) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "users/change/password"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'oldPass': oldPass, 'newPass': newPass}),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> changeUserInfo({
    String? id,
    String? email,
    String? name,
    String? userName,
    String? image,
  }) async {
    Object data = [];

    try {
      if (image!.isNotEmpty) {
        final bytesSlp = File(image).readAsBytesSync();
        String file64Slp = base64Encode(bytesSlp);
        data = json.encode({'picture': file64Slp});
      } else {
        data = json.encode({
          'name': name,
          'username': userName,
          'email': email,
        });
      }
      var response = await client.patch(
        Uri.parse(uRl + "users/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    } on SocketException {
     return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future getTtkActive() async {
    List<Tauxtks> listttksActive = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "ttks/filter-by-statut/active"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listttksActive = list.map((i) => Tauxtks.fromJson(i)).toList();

      return listttksActive;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future getTfsActive() async {
    List<TauxForfait> listTfssActive = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "tfs/filter-by-statut/active"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTfssActive = list.map((i) => TauxForfait.fromJson(i)).toList();

      return listTfssActive;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future getB2B() async {
    List<TauxForfait> listTfssActive = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "b2bs"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listTfssActive = list.map((i) => TauxForfait.fromJson(i)).toList();

      return listTfssActive;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future<dynamic> micAddB2B(
    String agrement,
    String ifu,
    String nom,
    String ville,
    String adresse,
    int marketerIds,

    // String uname,
    String username,
    String login,
    String email,
    // String upassword,
    int poi,
    // String latitude,
    // String longitude,
    String rc,
    String ifuDoc,
    String agreDoc,
  ) async {
    final bytesifu = File(ifuDoc).readAsBytesSync();
    String file64ifu = base64Encode(bytesifu);
    final bytesagre = File(agreDoc).readAsBytesSync();
    String file64agre = base64Encode(bytesagre);
    try {
      var response = await client.put(
        Uri.parse(uRl + "b2bs"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'email': email,
          'name': username,
          'username': login,
          'ifu': ifu,
          'rccm': rc,
          'nom': nom,
          'ville_id': ville,
          'adresse': adresse,
          'marketer_ids': marketerIds,
          'document_rccm': file64agre,
          'document_ifu': file64ifu,
          // 'poi_id': poi.toString(),
          // 'latitude': latitude,
          // 'longitude': longitude,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }
}
