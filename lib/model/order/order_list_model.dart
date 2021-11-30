class OrderListModel {
  int? id;
  String? code;
  int? tradeStatus;
  int? payType;
  double? payPrice;
  double? freightFee;
  int? jcookAddressId;
  String? receiverName;
  String? receiverTel;
  String? locationName;
  String? addressDetail;
  String? createDate;
  List<MyOrderListVoList>? myOrderListVoList;

  OrderListModel(
      {this.id,
        this.code,
        this.tradeStatus,
        this.payType,
        this.payPrice,
        this.freightFee,
        this.receiverName,
        this.receiverTel,
        this.locationName,
        this.addressDetail,
        this.createDate,
        this.myOrderListVoList,this.jcookAddressId});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    tradeStatus = json['tradeStatus'];
    payType = json['payType'];
    payPrice = json['payPrice'];
    freightFee = json['freightFee'];
    receiverName = json['receiverName'];
    receiverTel = json['receiverTel'];
    locationName = json['locationName'];
    addressDetail = json['addressDetail'];
    createDate = json['createDate'];
    jcookAddressId = json['jcookAddressId'];
    if (json['myOrderListVoList'] != null) {
      myOrderListVoList = [];
      json['myOrderListVoList'].forEach((v) {
        myOrderListVoList!.add(new MyOrderListVoList.fromJson(v));
      });
    }else{
      myOrderListVoList = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['tradeStatus'] = this.tradeStatus;
    data['payType'] = this.payType;
    data['payPrice'] = this.payPrice;
    data['freightFee'] = this.freightFee;
    data['receiverName'] = this.receiverName;
    data['receiverTel'] = this.receiverTel;
    data['locationName'] = this.locationName;
    data['addressDetail'] = this.addressDetail;
    data['createDate'] = this.createDate;
    data['jcookAddressId'] = this.jcookAddressId;
    if (this.myOrderListVoList != null) {
      data['myOrderListVoList'] =
          this.myOrderListVoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyOrderListVoList {
  int? id;
  int? jcookGoodsId;
  String? skuName;
  String? mainPhoto;
  double? sellPrice;
  String? unit;
  int? kind;
  double? weight;
  int? num;
  double? payPrice;

  MyOrderListVoList(
      {this.id,
        this.jcookGoodsId,
        this.skuName,
        this.mainPhoto,
        this.sellPrice,
        this.unit,
        this.kind,
        this.weight,
        this.num,
        this.payPrice});

  MyOrderListVoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jcookGoodsId = json['jcookGoodsId'];
    skuName = json['skuName'];
    mainPhoto = json['mainPhoto'];
    sellPrice = json['sellPrice'];
    unit = json['unit'];
    kind = json['kind'];
    weight = json['weight'];
    num = json['num'];
    payPrice = json['payPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jcookGoodsId'] = this.jcookGoodsId;
    data['skuName'] = this.skuName;
    data['mainPhoto'] = this.mainPhoto;
    data['sellPrice'] = this.sellPrice;
    data['unit'] = this.unit;
    data['kind'] = this.kind;
    data['weight'] = this.weight;
    data['num'] = this.num;
    data['payPrice'] = this.payPrice;
    return data;
  }
}