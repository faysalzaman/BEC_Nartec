// ignore_for_file: file_names

class AttendanceModel {
  int? id;
  int? employeeId;
  String? checkIn;
  String? checkOut;
  String? createdAt;
  String? updatedAt;

  AttendanceModel(
      {this.id,
      this.employeeId,
      this.checkIn,
      this.checkOut,
      this.createdAt,
      this.updatedAt});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    checkIn = json['checkIn'];
    checkOut = json['checkOut'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['checkIn'] = checkIn;
    data['checkOut'] = checkOut;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
