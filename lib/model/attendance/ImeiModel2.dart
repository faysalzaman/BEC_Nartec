class ImeiModel2 {
  bool? success;
  String? message;
  Transaction? transaction;

  ImeiModel2({this.success, this.message, this.transaction});

  ImeiModel2.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

class Transaction {
  int? id;
  int? employeeId;
  String? checkIn;
  String? iMEI;
  String? checkOut;
  String? createdAt;
  String? updatedAt;
  Employee? employee;

  Transaction({
    this.id,
    this.employeeId,
    this.checkIn,
    this.iMEI,
    this.checkOut,
    this.createdAt,
    this.updatedAt,
    this.employee,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    checkIn = json['checkIn'];
    iMEI = json['IMEI'];
    checkOut = json['checkOut'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    employee =
    json['employee'] != null ? Employee.fromJson(json['employee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['checkIn'] = checkIn;
    data['IMEI'] = iMEI;
    data['checkOut'] = checkOut;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}

class Employee {
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

  Employee(
      {this.id,
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
        this.updatedAt});

  Employee.fromJson(Map<String, dynamic> json) {
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
