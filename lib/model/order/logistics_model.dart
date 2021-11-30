class LogisticsModel {
  String? logisticsName;
  String? waybillCode;
  List<OperatorNodeList>? operatorNodeList;

  LogisticsModel({this.logisticsName, this.waybillCode, this.operatorNodeList});

  LogisticsModel.fromJson(Map<String, dynamic> json) {
    logisticsName = json['logistics_name'];
    waybillCode = json['waybill_code'];
    if (json['operator_node_list'] != null) {
      operatorNodeList = [];
      json['operator_node_list'].forEach((v) {
        operatorNodeList!.add(new OperatorNodeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logistics_name'] = this.logisticsName;
    data['waybill_code'] = this.waybillCode;
    if (this.operatorNodeList != null) {
      data['operator_node_list'] =
          this.operatorNodeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OperatorNodeList {
  String? scanState;
  String? systemOperator;
  int? msgTime;
  int? orderId;
  String? content;
  String? groupState;

  OperatorNodeList(
      {this.scanState,
        this.systemOperator,
        this.msgTime,
        this.orderId,
        this.content,
        this.groupState});

  OperatorNodeList.fromJson(Map<String, dynamic> json) {
    scanState = json['scan_state'];
    systemOperator = json['system_operator'];
    msgTime = json['msg_time'];
    orderId = json['order_id'];
    content = json['content'];
    groupState = json['group_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scan_state'] = this.scanState;
    data['system_operator'] = this.systemOperator;
    data['msg_time'] = this.msgTime;
    data['order_id'] = this.orderId;
    data['content'] = this.content;
    data['group_state'] = this.groupState;
    return data;
  }
}