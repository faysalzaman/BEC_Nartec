// ignore_for_file: file_names

class TransactionHistoryModel {
  bool? success;
  List<Transaction>? transaction;

  TransactionHistoryModel({this.success, this.transaction});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (transaction != null) {
      data['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  int? id;
  int? employeeId;
  String? date;
  String? mealType;
  String? iMEI;
  String? createdAt;
  String? updatedAt;
  Employee? employee;

  Transaction(
      {this.id,
      this.employeeId,
      this.date,
      this.mealType,
      this.iMEI,
      this.createdAt,
      this.updatedAt,
      this.employee});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    date = json['date'];
    mealType = json['mealType'];
    iMEI = json['IMEI'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    employee =
        json['employee'] != null ? Employee.fromJson(json['employee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['date'] = date;
    data['mealType'] = mealType;
    data['IMEI'] = iMEI;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}

class Employee {
  String? name;
  String? profilePicture;
  String? nationality;
  String? jobTitle;
  String? username;
  String? roomNumber;
  String? employmentType;
  String? location;
  String? companyName;
  String? passportNumber;

  Employee(
      {this.name,
      this.profilePicture,
      this.nationality,
      this.jobTitle,
      this.username,
      this.roomNumber,
      this.employmentType,
      this.location,
      this.companyName,
      this.passportNumber});

  Employee.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePicture = json['profilePicture'];
    nationality = json['nationality'];
    jobTitle = json['jobTitle'];
    username = json['username'];
    roomNumber = json['roomNumber'];
    employmentType = json['employmentType'];
    location = json['location'];
    companyName = json['companyName'];
    passportNumber = json['passportNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profilePicture'] = profilePicture;
    data['nationality'] = nationality;
    data['jobTitle'] = jobTitle;
    data['username'] = username;
    data['roomNumber'] = roomNumber;
    data['employmentType'] = employmentType;
    data['location'] = location;
    data['companyName'] = companyName;
    data['passportNumber'] = passportNumber;
    return data;
  }
}
