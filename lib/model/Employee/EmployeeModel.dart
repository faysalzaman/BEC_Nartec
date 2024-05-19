// ignore_for_file: file_names

class EmployeeModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? location;
  String? employeeCode;
  String? profilePicture;
  String? locationCode;
  String? nationality;
  String? companyId;
  String? companyName;
  String? createdAt;
  String? updatedAt;

  EmployeeModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.location,
    this.employeeCode,
    this.profilePicture,
    this.locationCode,
    this.nationality,
    this.companyId,
    this.companyName,
    this.createdAt,
    this.updatedAt,
  });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    location = json['location'];
    employeeCode = json['employeeCode'];
    profilePicture = json['profilePicture'];
    locationCode = json['locationCode'];
    nationality = json['nationality'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['location'] = location;
    data['employeeCode'] = employeeCode;
    data['profilePicture'] = profilePicture;
    data['locationCode'] = locationCode;
    data['nationality'] = nationality;
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
