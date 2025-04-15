// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
    Notification({
        required this.id,
        required this.type,
        required this.notifiableType,
        required this.notifiableId,
        required this.data,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    int id;
    String type;
    String notifiableType;
    int notifiableId;
    String data;
    String createdAt;
    String updatedAt;
    String deletedAt;

    factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"]??0,
        type: json["type"]??'',
        notifiableType: json["notifiable_type"] ?? "",
        notifiableId: json["notifiable_id"],
        data: json["data"]  ?? "",
       createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        deletedAt: json["deletedAt"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
    };
}
