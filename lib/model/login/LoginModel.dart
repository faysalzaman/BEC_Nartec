// ignore_for_file: file_names

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
  String? name;

  AdminUser({this.id, this.email, this.name});

  AdminUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}
