// To parse this JSON data, do
//
//     final homeResponseModel = homeResponseModelFromJson(jsonString);

import 'dart:convert';

HomeResponseModel? homeResponseModelFromJson(String str) => HomeResponseModel.fromJson(json.decode(str));

String homeResponseModelToJson(HomeResponseModel? data) => json.encode(data!.toJson());

class HomeResponseModel {
  HomeResponseModel({
    this.meta,
    this.data,
  });

  Meta? meta;
  List<Datum?>? data;

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) => HomeResponseModel(
    meta: Meta.fromJson(json["meta"]),
    data: json["data"] == null ? [] : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta!.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.userId,
    this.keterangan,
    this.latitude,
    this.longitude,
    this.tanggal,
    this.masuk,
    this.pulang,
    this.createdAt,
    this.updatedAt,
    this.isHariIni,
  });

  int? id;
  int? userId;
  String? keterangan;
  String? latitude;
  String? longitude;
  String? tanggal;
  String? masuk;
  String? pulang;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isHariIni;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    keterangan: json["keterangan"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    tanggal: json["tanggal"],
    masuk: json["masuk"],
    pulang: json["pulang"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isHariIni: json["is_hari_ini"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "keterangan": keterangan,
    "latitude": latitude,
    "longitude": longitude,
    "tanggal": tanggal,
    "masuk": masuk,
    "pulang": pulang,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_hari_ini": isHariIni,
  };
}

class Meta {
  Meta({
    this.code,
    this.status,
    this.message,
  });

  int? code;
  String? status;
  String? message;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    code: json["code"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
  };
}
