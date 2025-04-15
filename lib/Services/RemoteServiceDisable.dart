import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sygeq/main.dart';

class RemoteServiceDisable {
  static var client = http.Client();
  static String autorisation = "Bearer ${prefUserInfo['token']}";
  final navigatorKey = GlobalKey<NavigatorState>();
  static Future<dynamic> micDisable(int id, int etat, String lienUrl) async {
    try {
      var response = await client.post(
        Uri.parse("$uRl$lienUrl/trash/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'suspensionComment': 'Aucun'}),
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

  static Future<dynamic> micRestor(int id, int etat, String lienUrl) async {
    try {
      var response = await client.post(
        Uri.parse("$uRl$lienUrl/untrash/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'suspensionComment': 'Aucun'}),
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

  static Future<dynamic> marketerDisable(
    int id,
    int etat,
    String lienUrl,
  ) async {
    try {
      var response = await client.post(
        Uri.parse("$uRl$lienUrl/trash/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'suspensionComment': 'Aucun'}),
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

  static Future<dynamic> marketerRestor(
    int id,
    int etat,
    String lienUrl,
  ) async {
    try {
      var response = await client.post(
        Uri.parse("$uRl$lienUrl/untrash/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': autorisation,
        },
        body: json.encode({'suspensionComment': 'Aucun'}),
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
}
