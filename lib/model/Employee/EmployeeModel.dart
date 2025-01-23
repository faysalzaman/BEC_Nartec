// ignore_for_file: file_names

import 'package:bec_app/constant/app_urls.dart';

class Location {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Location({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Admin {
  int? id;
  String? email;
  String? userId;
  String? password;
  String? name;
  int? locationId;
  int? isSuperAdmin;
  String? createdAt;
  String? updatedAt;

  Admin({
    this.id,
    this.email,
    this.userId,
    this.password,
    this.name,
    this.locationId,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
  });

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    userId = json['userId'];
    password = json['password'];
    name = json['name'];
    locationId = json['locationId'];
    isSuperAdmin = json['is_super_admin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['userId'] = userId;
    data['password'] = password;
    data['name'] = name;
    data['locationId'] = locationId;
    data['is_super_admin'] = isSuperAdmin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class EmployeeModel {
  int? id;
  String? name;
  String? username;
  String? password;
  Location? location;
  String? employeeCode;
  String? profilePicture;
  String? nationality;
  String? companyName;
  String? passportNumber;
  String? employmentType;
  String? jobTitle;
  String? roomNumber;
  String? costCode;
  String? wps;
  String? createdAt;
  String? updatedAt;
  int? adminId;
  EmployeeModel? employee;
  Admin? admin;

  EmployeeModel({
    this.id,
    this.name,
    this.username,
    this.password,
    this.location,
    this.employeeCode,
    this.profilePicture,
    this.nationality,
    this.companyName,
    this.passportNumber,
    this.employmentType,
    this.jobTitle,
    this.roomNumber,
    this.costCode,
    this.wps,
    this.createdAt,
    this.updatedAt,
    this.adminId,
    this.employee,
    this.admin,
  });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    employeeCode = json['employeeCode'];
    profilePicture = json['profilePicture'];
    nationality = json['nationality'];
    companyName = json['companyName'];
    passportNumber = json['passportNumber'];
    employmentType = json['employmentType'];
    jobTitle = json['jobTitle'];
    roomNumber = json['roomNumber'];
    costCode = json['costCode'];
    wps = json['wps'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    adminId = json['adminId'];
    employee = json['employee'] != null
        ? EmployeeModel.fromJson(json['employee'])
        : null;
    admin = json['admin'] != null ? Admin.fromJson(json['admin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['password'] = password;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['employeeCode'] = employeeCode;
    data['profilePicture'] = profilePicture;
    data['nationality'] = nationality;
    data['companyName'] = companyName;
    data['passportNumber'] = passportNumber;
    data['employmentType'] = employmentType;
    data['jobTitle'] = jobTitle;
    data['roomNumber'] = roomNumber;
    data['costCode'] = costCode;
    data['wps'] = wps;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['adminId'] = adminId;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    if (admin != null) {
      data['admin'] = admin!.toJson();
    }
    return data;
  }

  getProfilePictureUrl() {
    return "${AppUrls.baseUrl}/${profilePicture?.replaceAll("\\", "/").replaceAll("//", "/")}";
  }
}
