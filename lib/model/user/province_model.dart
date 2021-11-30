
import 'package:hive/hive.dart';
part 'province_model.g.dart';

@HiveType(typeId: 0)
class ProvinceModel {

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<City>? cityList;

  ProvinceModel({this.id, this.name, this.cityList});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    if (json['cityList'] != null) {
      cityList = (json['cityList'] as List).map((e) => City.fromJson(e)).toList();

    }else
      cityList = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.cityList != null) {
      data['cityList'] = this.cityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 1)
class City {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<District>? districts;

  City({this.id, this.name, this.districts});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['cityList'] != null) {
      districts = (json['cityList'] as List).map((e) => District.fromJson(e)).toList();

    }else
      districts = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.districts != null) {
      data['cityList'] = this.districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 2)
class District {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;

  District({this.id, this.name});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}