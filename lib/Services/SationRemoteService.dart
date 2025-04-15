// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sygeq/ModelRapport/ModelTableau.dart';
import 'package:sygeq/Models/BonL.dart';
import 'package:sygeq/Models/CamioPosition.dart';
import 'package:sygeq/Models/LivraisonStation.dart';
import 'package:sygeq/Models/Station.dart';
import 'package:sygeq/main.dart';

class RemoteStationService {
  static var client = http.Client();
  static String autorisation = "Bearer ${prefUserInfo['token']}";

  static Future allOneStation({required String stationId}) async {
    List<Station> listStation = [];
    List list = [];
    int id = int.parse(stationId);
    print("je suis i                               $id");
    // try {
    var response = await client.get(
      Uri.parse("${uRl}stations/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      // list = response.body as List;
      list = result["data"] as List;
      listStation = list.map((i) => Station.fromJson(i)).toList();
      return listStation;
    } else {
      var result = json.decode(response.body.toString());
      return result["message"];
    }
    // } on SocketException {
    //   return Future.error("Veuillez vérifier votre connexion internet!");
    // }
    // catch (e) {
    //   // throw Exception("Imposible de récuperer les données : $e");
    // }
  }

  static Future staionGetVehiculPosition({required int camion}) async {
    List<CamionPosition> listCamionPosition = [];
    List list = [];
    try {
      var response = await client.get(
        Uri.parse("${uRl}camions/ssat/last-position/$camion"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body.toString());
        if (result["vehicles"] == null) {
          showToast(
            "L'équipement est défayant",
            
          );
          return listCamionPosition;
        } else {
          list = result["vehicles"] as List;
          listCamionPosition =
              list.map((i) => CamionPosition.fromJson(i)).toList();
          return listCamionPosition;
        }
      } else {
        var result = json.decode(response.body.toString());
        showToastError(
          result["message"],
          
        );
        return result["message"];
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future depotGetVehiculPosition({
    required int camion,
    required String type,
  }) async {
    List<CamionPosition> listCamionPosition = [];
    List list = [];
    try {
      var response = await client.post(
        Uri.parse("${uRl}camions/ssat/depot_get_last_position"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'id': camion, 'type': type}),
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body.toString());
        if (result["vehicles"] == null) {
          showToastError(
            "L'équipement est défayant",
            
          );
          return listCamionPosition;
        } else {
          list = result["vehicles"] as List;
          listCamionPosition =
              list.map((i) => CamionPosition.fromJson(i)).toList();
          return listCamionPosition;
        }
      } else {
        var result = json.decode(response.body.toString());
        showToastError(
          result["message"],
          
        );
        return result["message"];
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future stationGetBL({required int code}) async {
    List<LivraisonStation> listBonLivraison = [];
    List list = [];
    try {
      var response = await client.get(
        Uri.parse("${uRl}bls/$code"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body.toString());
        return {'data': response.body, "statut": true};
        // return listBonLivraison;
      } else {
        var result = json.decode(response.body.toString());
        showToastError(
          result["message"],
        );
        return {'data': result["message"], "statut": false};
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future depotGetBL({required int code}) async {
    List<LivraisonStation> listBonLivraison = [];
    List list = [];
    var response = await client.get(
      Uri.parse("${uRl}bts/$code"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      return {'data': response.body, "statut": true};
    } else {
      var result = json.decode(response.body.toString());
      return showToastError(
          result["message"],
        );
    }
  }

  static Future staionUpdateBL({
    required int code,
    required List<ModelQtteAvantApres> dataApresAvant,
  }) async {
    try {
      List<BonL> listBonLivraison = [];
      List list = [];
      List dataL = [];
      for (var element in dataApresAvant) {
        dataL.add({
          'id': element.productId,
          'before': element.qteAvant,
          'after': element.qteApres,
        });
      }
      var finalList = {'data': dataL};
      var response = await client.patch(
        Uri.parse("${uRl}bls/decharger/$code"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode(finalList),
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body.toString());
        showToast(
          result['message']
        );
        return {"statut": true, "message": result['message']};
      } else {
        var result = json.decode(response.body.toString());
        showToastError(
          result['message']
        );
        return {"statut": false, "message": result['message']};
      }
    } on SocketException {
      return showToastError("Veuillez vérifier votre connexion internet!");
    } catch (e) {
      return showToastError("Erreur de connexion $e");
    }
  }

  static Future staionUpdateBLB2B({required int code}) async {
    List<BonL> listBonLivraison = [];
    List list = [];

    var response = await client.patch(
      Uri.parse("${uRl}bls/decharger/$code"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
      // body: json.encode(finalList),
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());

      list = result["data"] as List;
      listBonLivraison = list.map((i) => BonL.fromJson(i)).toList();
      return json.decode(response.body);
    } else {
      var result = json.decode(response.body.toString());
      return showToastError(
          result["message"],
        );
    }
  }

  static Future stationGetListeBL() async {
    List<BonL> listBL = [];
    List list = [];

    // try {
    var response = await client.post(
      Uri.parse("${uRl}bls/get-bls/filter-by-statuses"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': autorisation,
      },
      body: json.encode({
        'statuts': ['Chargé', 'Déchargé'],
      }),
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body.toString());
      list = result["data"] as List;
      listBL = list.map((i) => BonL.fromJson(i)).toList();
      return listBL;
    }else {
      var result = json.decode(response.body.toString());
      return showToastError(
          result["message"],
        );
    }
  }
}
