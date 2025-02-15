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
  String? userId;
  String? name;
  int? isSuperAdmin;
  List<Locations>? locations;

  AdminUser(
      {this.id,
      this.email,
      this.userId,
      this.name,
      this.isSuperAdmin,
      this.locations});

  AdminUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    userId = json['userId'];
    name = json['name'];
    isSuperAdmin = json['is_super_admin'];
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['userId'] = userId;
    data['name'] = name;
    data['is_super_admin'] = isSuperAdmin;
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  int? id;
  String? name;

  Locations({this.id, this.name});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
