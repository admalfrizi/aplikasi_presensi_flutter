// To parse this JSON data, do
//
//     final registerResponseModel = registerResponseModelFromJson(jsonString);

import 'dart:convert';

RegisterResponseModel? registerResponseModelFromJson(String str) => RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel? data) => json.encode(data!.toJson());

class RegisterResponseModel {
  RegisterResponseModel({
    this.meta,
    this.data,
  });

  Meta? meta;
  Data? data;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => RegisterResponseModel(
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
    this.accessToken,
    this.tokenType,
    this.user,
  });

  String? accessToken;
  String? tokenType;
  User? user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.name,
    this.email,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? name;
  String? email;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
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
