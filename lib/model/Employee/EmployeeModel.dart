// ignore_for_file: file_names

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
    return data;
  }
}
