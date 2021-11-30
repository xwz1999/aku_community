class CreateOrderModel {
  DefaultAddressVo? defaultAddressVo;
  List<MyShoppingCartVoList>? myShoppingCartVoList;
  double? fee;

  CreateOrderModel(
      {this.defaultAddressVo, this.myShoppingCartVoList, this.fee});

  factory CreateOrderModel.fail() => CreateOrderModel(defaultAddressVo: null,myShoppingCartVoList: [],fee: null
  );

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    defaultAddressVo = json['defaultAddressVo'] != null
        ? new DefaultAddressVo.fromJson(json['defaultAddressVo'])
        : null;

    if (json['myShoppingCartVoList'] != null) {
      myShoppingCartVoList = [];
      json['myShoppingCartVoList'].forEach((v) {
        myShoppingCartVoList!.add(new MyShoppingCartVoList.fromJson(v));
      });
    }else
      myShoppingCartVoList = [];
    fee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.defaultAddressVo != null) {
      data['defaultAddressVo'] = this.defaultAddressVo!.toJson();
    }
    if (this.myShoppingCartVoList != null) {
      data['myShoppingCartVoList'] =
          this.myShoppingCartVoList!.map((v) => v.toJson()).toList();
    }
    data['fee'] = this.fee;
    return data;
  }
}

class DefaultAddressVo {
  int? id;
  String? name;
  String? tel;
  String? locationName;
  String? addressDetail;

  DefaultAddressVo(
      {this.id, this.name, this.tel, this.locationName, this.addressDetail});

  DefaultAddressVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tel = json['tel'];
    locationName = json['locationName'];
    addressDetail = json['addressDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['tel'] = this.tel;
    data['locationName'] = this.locationName;
    data['addressDetail'] = this.addressDetail;
    return data;
  }
}

class MyShoppingCartVoList {
  int? id;
  String? skuName;
  String? mainPhoto;
  int? status;
  int? shopStatus;
  double? sellPrice;
  double? discountPrice;
  int? stockStatus;
  String? unit;
  int? kind;
  double? weight;
  int? num;

  MyShoppingCartVoList(
      {this.id,
        this.skuName,
        this.mainPhoto,
        this.status,
        this.shopStatus,
        this.sellPrice,
        this.discountPrice,
        this.unit,
        this.kind,
        this.weight,
        this.num,this.stockStatus});

  MyShoppingCartVoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skuName = json['skuName'];
    mainPhoto = json['mainPhoto'];
    status = json['status'];
    shopStatus = json['shopStatus'];
    sellPrice = json['sellPrice'];
    discountPrice = json['discountPrice'];
    stockStatus = json['stockStatus'];
    unit = json['unit'];
    kind = json['kind'];
    weight = json['weight'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['skuName'] = this.skuName;
    data['mainPhoto'] = this.mainPhoto;
    data['status'] = this.status;
    data['shopStatus'] = this.shopStatus;
    data['sellPrice'] = this.sellPrice;
    data['discountPrice'] = this.discountPrice;
    data['stockStatus'] = this.stockStatus;
    data['unit'] = this.unit;
    data['kind'] = this.kind;
    data['weight'] = this.weight;
    data['num'] = this.num;
    return data;
  }
}