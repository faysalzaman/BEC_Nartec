// ignore_for_file: file_names

class WpsModel {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? locationId;
  Location? location;

  WpsModel(
      {this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.locationId,
      this.location});

  WpsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    locationId = json['locationId'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['locationId'] = locationId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Location {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Location({this.id, this.name, this.createdAt, this.updatedAt});

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
