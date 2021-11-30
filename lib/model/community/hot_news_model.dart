import 'package:aku_community/model/common/img_model.dart';

class HotNewsModel {
  int? id;
  String? title;
  String? createDate;
  int? views;
  List<ImgModel>? imgList;

  HotNewsModel(
      {this.id, this.title, this.createDate, this.views, this.imgList});

  HotNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createDate = json['createDate'];
    views = json['views'];
    if (json['imgList'] != null) {
      imgList = [];
      json['imgList'].forEach((v) {
        imgList!.add(new ImgModel.fromJson(v));
      });
    } else
      imgList = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['createDate'] = this.createDate;
    data['views'] = this.views;
    if (this.imgList != null) {
      data['imgList'] = this.imgList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}