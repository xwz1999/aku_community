class AlarmModel {
  String? alarmNo;
  String? alarmType;
  String? deviceName;
  String? deviceNo;
  String? time;
  int? type;
  String? planContent;
  String? alarmContent;

  AlarmModel.fromJson(Map<String, dynamic> json) {
    alarmNo = json['alarmNo'];
    alarmType = json['alarmType'];
    deviceName = json['deviceName'];
    deviceNo = json['deviceNo'];
    time = json['time'];
    type = json['type'];
    planContent = json['planContent'];
    alarmContent = json['alarmContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alarmNo'] = this.alarmNo;
    data['alarmType'] = this.alarmType;
    data['deviceName'] = this.deviceName;
    data['deviceNo'] = this.deviceNo;
    data['time'] = this.time;
    data['type'] = this.type;
    data['planContent'] = this.planContent;
    data['alarmContent'] = this.alarmContent;
    return data;
  }

  AlarmModel({
    this.alarmNo,
    this.alarmType,
    this.deviceName,
    this.deviceNo,
    this.time,
    this.type,
    this.planContent,
    this.alarmContent,
  });
}
