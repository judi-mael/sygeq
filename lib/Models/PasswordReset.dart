// To parse this JSON data, do
//
//     final passwordResets = passwordResetsFromJson(jsonString);

import 'dart:convert';

PasswordResets passwordResetsFromJson(String str) =>
    PasswordResets.fromJson(json.decode(str));

String passwordResetsToJson(PasswordResets data) => json.encode(data.toJson());

class PasswordResets {
  PasswordResets({
    required this.email,
    required this.token,
    // required this.createdAt,
    // required this.createdBy,
    // required this.updatedAt,
    // required this.updatedBy,
    // required this.deletedAt,
  });

  String email;
  String token;
  // String createdAt;
  // int createdBy;
  // String updatedAt;
  // int updatedBy;
  // String deletedAt;

  factory PasswordResets.fromJson(Map<String, dynamic> json) => PasswordResets(
        email: json["email"]??'',
        token: json["token"]??'',
        // createdAt: json["createdAt"]??'',
        // createdBy: json["createdBy"],
        // updatedAt: json["updatedAt"],
        // updatedBy: json["updatedBy"],
        // deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "token": token,
        // "createdAt": createdAt,
        // "createdBy": createdBy,
        // "updatedAt": updatedAt,
        // "updatedBy": updatedBy,
        // "deletedAt": deletedAt,
      };
}
