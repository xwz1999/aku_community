class SettlementGoodsDTO {
  int? jcookGoodsId;
  int? num;

  SettlementGoodsDTO(
      {this.jcookGoodsId, this.num,});

  SettlementGoodsDTO.fromJson(Map<String, dynamic> json) {
    jcookGoodsId = json['jcookGoodsId'];
    num = json['num'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jcookGoodsId'] = this.jcookGoodsId;
    data['num'] = this.num;

    return data;
  }

}
