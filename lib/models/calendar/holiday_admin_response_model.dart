// To parse this JSON data, do
//
//     final holidayAdminResponseModel = holidayAdminResponseModelFromJson(jsonString);

import 'dart:convert';

HolidayAdminResponseModel holidayAdminResponseModelFromJson(String str) =>
    HolidayAdminResponseModel.fromJson(json.decode(str));

String leavesAdminResponseModelToJson(HolidayAdminResponseModel data) =>
    json.encode(data.toJson());

class HolidayAdminResponseModel {
  HolidayAdminResponseModel({
    required this.message,
    required this.leaveList,
  });

  String message;
  List<LeaveList> leaveList;

  factory HolidayAdminResponseModel.fromJson(Map<String, dynamic> json) =>
      HolidayAdminResponseModel(
        message: json["message"],
        leaveList: List<LeaveList>.from(
            json["leave_list"].map((x) => LeaveList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "leave_list": List<dynamic>.from(leaveList.map((x) => x.toJson())),
      };
}

class LeaveList {
  LeaveList({
    required this.id,
    required this.countryId,
    required this.type,
    required this.employerId,
    required this.name,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int countryId;
  String type;
  int employerId;
  String name;
  String date;
  DateTime createdAt;
  DateTime updatedAt;

  factory LeaveList.fromJson(Map<String, dynamic> json) => LeaveList(
        id: json["id"],
        countryId: json["country_id"],
        type: json["type"],
        employerId: json["employer_id"],
        name: json["name"],
        date: json["date"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_id": countryId,
        "type": type,
        "employer_id": employerId,
        "name": name,
        "date": date,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
