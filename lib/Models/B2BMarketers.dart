// To parse this JSON data, do
//
//     final b2BMarketers = b2BMarketersFromJson(jsonString);

import 'dart:convert';

import 'package:sygeq/Models/Marketer.dart';

B2BMarketers b2BMarketersFromJson(String str) =>
    B2BMarketers.fromJson(json.decode(str));

String b2BMarketersToJson(B2BMarketers data) => json.encode(data.toJson());

class B2BMarketers {
  int id;
  int b2BId;
  int marketerId;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  dynamic restoredBy;
  dynamic suspensionComment;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  Marketer marketer;

  B2BMarketers({
    required this.id,
    required this.b2BId,
    required this.marketerId,
    required this.createdBy,
    required this.updatedBy,
    this.deletedBy,
    this.restoredBy,
    this.suspensionComment,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.marketer,
  });

  factory B2BMarketers.fromJson(Map<String, dynamic> json) => B2BMarketers(
    id: json["id"],
    b2BId: json["b2b_id"],
    marketerId: json["marketer_id"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deletedBy: json["deletedBy"],
    restoredBy: json["restoredBy"],
    suspensionComment: json["suspensionComment"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
    marketer:
        json["Marketer"] == null
            ? Marketer(
              id: 0,
              agrement: '',
              dateVigueur: '',
              dateExpiration: '',
              nom: '',
              type: '',
              adresse: '',
              registre: '',
              ifu: '',
              etat: 0,
              deletedAt: '',
            )
            : Marketer.fromJson(json["Marketer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "b2b_id": b2BId,
    "marketer_id": marketerId,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deletedBy": deletedBy,
    "restoredBy": restoredBy,
    "suspensionComment": suspensionComment,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}
