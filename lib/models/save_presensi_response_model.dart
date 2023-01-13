// To parse this JSON data, do
//
//     final savePresensiResponseModel = savePresensiResponseModelFromJson(jsonString);

import 'dart:convert';

SavePresensiResponseModel? savePresensiResponseModelFromJson(String str) => SavePresensiResponseModel.fromJson(json.decode(str));

String savePresensiResponseModelToJson(SavePresensiResponseModel? data) => json.encode(data!.toJson());

class SavePresensiResponseModel {
  SavePresensiResponseModel({
    this.meta,
    this.data,
  });

  Meta? meta;
  Data? data;

  factory SavePresensiResponseModel.fromJson(Map<String, dynamic> json) => SavePresensiResponseModel(
    meta: Meta.fromJson(json["meta"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta!.toJson(),
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.presensiData,
  });

  PresensiData? presensiData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    presensiData: PresensiData.fromJson(json["presensiData"]),
  );

  Map<String, dynamic> toJson() => {
    "presensiData": presensiData!.toJson(),
  };
}

class PresensiData {
  PresensiData({
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
  });

  int? id;
  int? userId;
  String? keterangan;
  String? latitude;
  String? longitude;
  DateTime? tanggal;
  String? masuk;
  dynamic pulang;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PresensiData.fromJson(Map<String, dynamic> json) => PresensiData(
    id: json["id"],
    userId: json["user_id"],
    keterangan: json["keterangan"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    tanggal: DateTime.parse(json["tanggal"]),
    masuk: json["masuk"],
    pulang: json["pulang"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "keterangan": keterangan,
    "latitude": latitude,
    "longitude": longitude,
    "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
    "masuk": masuk,
    "pulang": pulang,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
