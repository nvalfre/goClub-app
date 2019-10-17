// To parse this JSON data, do
//
//     final clubModel = clubModelFromJson(jsonString);

import 'dart:convert';

ClubModel clubModelFromJson(String str) => ClubModel.fromJson(json.decode(str));

String clubModelToJson(ClubModel data) => json.encode(data.toJson());

class ClubModel {
  String id;
  String name;
  String description;
  bool available;
  String logoUrl;
  String hourOpen;
  String hourClose;

  ClubModel({
    this.id,
    this.name = '',
    this.description ='',
    this.available = false,
    this.logoUrl,
    this.hourOpen,
    this.hourClose,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) => ClubModel(
        id         : json["id"],
        name       : json["name"],
        description: json["description"],
        available  : json["available"],
        logoUrl    : json["logoUrl"],
        hourOpen   : json["hour-open"],
        hourClose  : json["hour-close"],
      );

  Map<String, dynamic> toJson() => {
//        "id"         : id,
        "name"       : name,
        "description": description,
        "available"  : available,
        "logoUrl"    : logoUrl,
        "hour-open"  : hourOpen,
        "hour-close" : hourClose,
      };
}
