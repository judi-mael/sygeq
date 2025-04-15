// To parse this JSON data, do
//
//     final mnotification = mnotificationFromJson(jsonString);

import 'dart:convert';

MNotification mNotificationFromJson(String str) =>
    MNotification.fromJson(json.decode(str));

String mNotificationToJson(MNotification data) => json.encode(data.toJson());

class MNotification {
  MNotification({
    required this.id,
    required this.label,
    required this.description,
    required this.userId,
    required this.readState,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int id;
  String label;
  String description;
  int userId;
  int readState;
  String createdAt;
  String updatedAt;
  String deletedAt;

  factory MNotification.fromJson(Map<String, dynamic> json) => MNotification(
        id: json["id"]??0,
        label: json["label"] ?? "",
        description: json["description"] ?? "",
        userId: json["userId"] ?? 0,
        readState: json["readState"] ?? 0,
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "description": description,
        "userId": userId,
        "readState": readState,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
      };
}
