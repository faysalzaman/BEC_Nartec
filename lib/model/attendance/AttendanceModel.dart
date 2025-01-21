// ignore_for_file: file_names

class AttendanceModel {
  int? id;
  int? employeeId;
  String? checkIn;
  String? checkOut;
  String? createdAt;
  String? updatedAt;
  String? location;
  String? checkInIMEI;
  String? checkOutIMEI;
  String? costCode;
  String? wps;
  int? adminId;

  AttendanceModel({
    this.id,
    this.employeeId,
    this.checkIn,
    this.checkOut,
    this.createdAt,
    this.updatedAt,
    this.checkInIMEI,
    this.checkOutIMEI,
    this.costCode,
    this.wps,
    this.adminId,
  });

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    checkIn = json['checkIn'];
    checkOut = json['checkOut'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    checkInIMEI = json['checkInIMEI'];
    checkOutIMEI = json['checkOutIMEI'];
    costCode = json['costCode'];
    wps = json['wps'];
    adminId = json['adminId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['checkIn'] = checkIn;
    data['checkOut'] = checkOut;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['checkInIMEI'] = checkInIMEI;
    data['checkOutIMEI'] = checkOutIMEI;
    data['costCode'] = costCode;
    data['wps'] = wps;
    data['adminId'] = adminId;
    return data;
  }
}
