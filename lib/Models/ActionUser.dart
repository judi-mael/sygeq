// To parse this JSON data, do
//
//     final actionUser = actionUserFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Action.dart';
import 'package:sygeq/Models/User.dart';

ActionUser actionUserFromJson(String str) =>
    ActionUser.fromJson(json.decode(str));

String actionUserToJson(ActionUser data) => json.encode(data.toJson());

class ActionUser {
  ActionUser({
    required this.id,
    required this.action,
    required this.userId,
    required this.etat,
    //  required this.createdBy,
    //  required this.updatedBy,
    //  required  this.createdAt,
    //  required this.updatedAt,
    //  required this.deletedAt,
  });

  int id;
  Action action;
  User userId;
  int etat;
  // int createdBy;
  // int updatedBy;
  // String createdAt;
  // String updatedAt;
  // String deletedAt;

  factory ActionUser.fromJson(Map<String, dynamic> json) => ActionUser(
    id: int.parse(json["id"]),
    action: Action.fromJson(json["action_id"]),
    userId: json["userId"],
    etat: json["etat"] == null ? 0 : int.parse(json["etat"]),
    // createdBy: json["created_by "],
    // updatedBy: json["updated_by"],
    // createdAt: json["createdAt"] ?? "",
    // updatedAt: json["updatedAt"] ?? "",
    // deletedAt: json["deletedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "action": action.toJson(),
    "userId": userId,
    "etat": etat,
    // "created_by ": createdBy,
    // "updated_by": updatedBy,
    // "createdAt": createdAt,
    // "updatedAt": updatedAt,
    // "deletedAt": deletedAt,
  };
}
