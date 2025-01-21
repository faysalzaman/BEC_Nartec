// ignore_for_file: file_names, non_constant_identifier_names

class LoginModel {
  bool? success;
  String? token;
  AdminUser? adminUser;

  LoginModel({this.success, this.token, this.adminUser});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    adminUser = json['adminUser'] != null
        ? AdminUser.fromJson(json['adminUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['token'] = token;
    if (adminUser != null) {
      data['adminUser'] = adminUser!.toJson();
    }
    return data;
  }
}

class AdminUser {
  int? id;
  String? email;
  String? userId;
  String? name;
  int? is_super_admin;
  int? locationId;

  AdminUser({
    this.id,
    this.email,
    this.userId,
    this.name,
    this.is_super_admin,
    this.locationId,
  });

  AdminUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    userId = json['userId'];
    name = json['name'];
    is_super_admin = json['is_super_admin'];
    locationId = json['locationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['userId'] = userId;
    data['name'] = name;
    data['is_super_admin'] = is_super_admin;
    data['locationId'] = locationId;
    return data;
  }
}
