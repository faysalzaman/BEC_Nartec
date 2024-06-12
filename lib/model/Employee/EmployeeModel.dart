// ignore_for_file: file_names

class EmployeeModel {
  int? id;
  String? name;
  String? username;
  String? password;
  String? location;
  String? employeeCode;
  String? profilePicture;
  String? nationality;
  String? companyName;
  String? passportNumber;
  String? employmentType;
  String? jobTitle;
  String? roomNumber;
  String? createdAt;
  String? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    location = json['location'];
    employeeCode = json['employeeCode'];
    profilePicture = json['profilePicture'];
    nationality = json['nationality'];
    companyName = json['companyName'];
    passportNumber = json['passportNumber'];
    employmentType = json['employmentType'];
    jobTitle = json['jobTitle'];
    roomNumber = json['roomNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['password'] = password;
    data['location'] = location;
    data['employeeCode'] = employeeCode;
    data['profilePicture'] = profilePicture;
    data['nationality'] = nationality;
    data['companyName'] = companyName;
    data['passportNumber'] = passportNumber;
    data['employmentType'] = employmentType;
    data['jobTitle'] = jobTitle;
    data['roomNumber'] = roomNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
