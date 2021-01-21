import 'package:akuCommunity/constants/api.dart';
import 'package:akuCommunity/utils/network/base_model.dart';
import 'package:akuCommunity/utils/network/net_util.dart';

class ManagerFunc {
  static insertVisitorInfo(int id, int type, String name, int sex, String tel,
      String carNum, DateTime expectedVisitDate) async {
    BaseModel baseModel = await NetUtil().post(API.manager.insertVisitorInfo,
        params: {
          'buildingUnitEstateId': id,
          'type': type,
          'name': name,
          'sex': sex,
          'tel': tel,
          'carNum': carNum,
          'expectedVisitDate': expectedVisitDate.toIso8601String(),
        },
        showMessage: true);
    return baseModel;
  }
}