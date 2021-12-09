class MarketSwiperModel {
  int? id;
  int? jcookGoodsId;
  int? skuId;
  List<ImgList>? imgList;

  MarketSwiperModel({this.id, this.jcookGoodsId, this.skuId, this.imgList});

  MarketSwiperModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jcookGoodsId = json['jcookGoodsId'];
    skuId = json['skuId'];
    if (json['imgList'] != null) {
      imgList = [];
      json['imgList'].forEach((v) {
        imgList!.add(new ImgList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jcookGoodsId'] = this.jcookGoodsId;
    data['skuId'] = this.skuId;
    if (this.imgList != null) {
      data['imgList'] = this.imgList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImgList {
  String? url;
  String? size;
  int? longs;
  int? paragraph;
  int? sort;

  ImgList({this.url, this.size, this.longs, this.paragraph, this.sort});

  ImgList.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    size = json['size'];
    longs = json['longs'];
    paragraph = json['paragraph'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['size'] = this.size;
    data['longs'] = this.longs;
    data['paragraph'] = this.paragraph;
    data['sort'] = this.sort;
    return data;
  }
}