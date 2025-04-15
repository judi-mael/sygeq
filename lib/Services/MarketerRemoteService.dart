// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:sygeq/Models/BonGPLBouteille.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/BonT.dart';
import 'package:sygeq/Models/Contrart.dart';
import 'package:sygeq/Models/ModelCreateMultiBL.dart';
import 'package:sygeq/Models/User.dart';
import 'package:sygeq/Models/dispactblgpl.dart';
import 'package:sygeq/Statistiques/StatistiqueMarketer.dart';
import 'package:sygeq/main.dart';
import 'package:http/http.dart' as http;

class MarketerRemoteService {
  static var client = http.Client();
  static String autorisation =
      "Bearer"
          " " +
      prefUserInfo['token'].toString();

  static Future<dynamic> manyBls(List<ModelCreateMultiBL> _listMultiBl) async {
    List listBls = [];
    for (var element in _listMultiBl) {
      List produ = [];
      for (var elts in element.detailBl) {
        produ.add({"produit_id": elts.produitId, "qtte": elts.qtte});
      }
      listBls.add({
        "station_id": element.stationId,
        "depot_id": element.depotId,
        "camion_id": element.camionId,
        "detailslivraison": produ,
      });
    }
    try {
      var response = await client.put(
        Uri.parse(uRl + "bls/many"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'bls': listBls}),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        // var result = json.decode(response.body);
        return showToastError('Les BL ont été ajouté avec succès.');
      }else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> addBonGpl(
    String station,
    String produit,
    String depot,
    String camion,
    String quantite,
  ) async {
    try {
      var response = await client.put(
        Uri.parse(uRl + "bls/one_bon_gpl"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'station_id': int.parse(station),
          'produit_id': int.parse(produit),
          'depot_id': int.parse(depot),
          'camion_id': int.parse(camion),
          'quantite': quantite,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        return showToastError('Les BL ont été ajouté avec succès.');
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

  static Future<dynamic> dispactGPLBouteille(
    int idBL,
    List<Dispactblgpl> gplList,
  ) async {
    var liste = [];

    for (var element in gplList) {
      liste.add({'stationId': element.stationid, 'quantite': element.quantite});
    }
    try {
      var response = await client.put(
        Uri.parse(uRl + "bls/multi_bl_gpl"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'bls': liste, 'bongpl_id': idBL}),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 204) {
        return showToastError('Les BL ont été ajouté avec succès.');
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

  static Future<dynamic> markAddBL(
    String dep,
    String sation,
    String transporteur,
    String camion,
    List detail,
    String marketer,
  ) async {
    try {
      var lidt = [];
      for (int i = 0; detail.length > i; i++) {
        lidt.add({
          "produit_id": int.parse(detail[i].toString().split(';')[0]),
          "qtte": int.parse(detail[i].toString().split(';')[1]),
        });
      }
      var response = await client.put(
        Uri.parse(uRl + "bls"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'depot_id': dep,
          'station_id': sation,
          'marketer_id': marketer,
          'transporteur_id': transporteur,
          'camion_id': camion,
          'detailslivraison': lidt,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return json.decode(response.body);
      }else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> markAddBT(
    String dep,
    String sation,
    String transporteur,
    String camion,
    List detail,
    String marketer,
  ) async {
    try {
      var lidt = [];
      for (int i = 0; detail.length > i; i++) {
        lidt.add({
          "produit_id": int.parse(detail[i].toString().split(';')[0]),
          "qtte": int.parse(detail[i].toString().split(';')[1]),
        });
      }
      var response = await client.put(
        Uri.parse(uRl + "bts"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'depot_id': dep,
          'station_id': sation,
          'marketer_id': marketer,
          'transporteur_id': transporteur,
          'camion_id': camion,
          'detailslivraison': lidt,
        }),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
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

  static Future<dynamic> markUpdateBLCharger({
    required int id,
    required String sation,
  }) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "bls/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'station_id': sation}),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> markUpdateBL(
    int id,
    String dep,
    String sation,
    // String transporteur,
    String camion,
    List detail,
    String marketer,
    String numBl,
  ) async {
    try {
      var lidt = [];
      for (int i = 0; detail.length > i; i++) {
        lidt.add({
          "produit_id": int.parse(detail[i].toString().split(';')[0]),
          "qtte": int.parse(detail[i].toString().split(';')[1]),
        });
      }
      var response = await client.patch(
        Uri.parse(uRl + "bls/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'numeroBL': numBl,
          'depot_id': dep,
          'station_id': sation,
          // 'marketer_id': marketer,
          // 'transporteur_id': transporteur,
          'camion_id': camion,
          'detailslivraison': lidt,
        }),
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> markUpdateBLStatut(int id, String statut) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "bls/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'statut': statut}),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> markUpdateBTStatut(int id, String statut) async {
    try {
      var response = await client.patch(
        Uri.parse(uRl + "bts/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'statut': statut}),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> markAddUser(
    String nom,
    String email,
    String role,
    // String password,
    String login,
    String station,
  ) async {
    try {
      Object res = {};
      if (station == "") {
        res = json.encode({
          'name': nom,
          'email': email,
          // 'role': role,
          'username': login,
          // 'password': password,
        });
      } else {
        res = json.encode({
          'name': nom,
          'email': email,
          // 'role': role,
          'username': login,
          // 'password': password,
          'station_id': station,
        });
      }
      var response = await client.put(
        Uri.parse(uRl + "users/marketer-admin-or-station"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: res,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }else  {
        var result = json.decode(response.body.toString());
        return showToastError(result["message"]);
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future<dynamic> markAddContrat(String id) async {
    List dta = [];

    try {
      var response = await client.put(
        Uri.parse(uRl + "contrats"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({
          'trIds': [id],
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

  ///////////////////////////////////////////
  /// get all BL Marketer
  /// ///////////////////////////////
  static Future allGetListeBL() async {
    List<BonL> listBonLivraison = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "bls"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBonLivraison = list.map((e) => BonL.fromJson(e)).toList();
      return listBonLivraison;
    }else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeGPL() async {
    List<BonGplBouteille> listBonGplBouteille = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "bls/bon_gpl/2024-02-02/2024-08-20"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBonGplBouteille =
          list.map((e) => BonGplBouteille.fromJson(e)).toList();
      return listBonGplBouteille;
    }else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetListeBT() async {
    List<BonT> listBonTransfere = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "bts"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBonTransfere = list.map((e) => BonT.fromJson(e)).toList();
      return listBonTransfere;
    }else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
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
    }else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future statistiqueMarketer(int year) async {
    List<StatistiqueMarketer> listStatistiqueMarketer = [];
    List list = [];
    var response = await client.get(
      Uri.parse(uRl + "bilans/marketer/quantities-per-products-per-year/$year"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listStatistiqueMarketer =
          list.map((e) => StatistiqueMarketer.fromJson(e)).toList();
      return listStatistiqueMarketer;
    }else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }

  static Future allGetContrat() async {
    List<Contrat> listContrat = [];
    List list = [];

    // try {
    var response = await client.get(
      Uri.parse(uRl + "contrats"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listContrat = list.map((i) => Contrat.fromJson(i)).toList();
      return listContrat;
    } else  {
      var result = json.decode(response.body.toString());
      return showToastError(result["message"]);
    }
  }
}
