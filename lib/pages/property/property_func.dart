
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/market/goods_item.dart';
import 'package:aku_community/models/market/order/order_detail_model.dart';
import 'package:aku_community/models/search/search_goods_model.dart';
import 'package:aku_community/utils/network/base_list_model.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/utils/text_utils.dart';
import 'package:aku_community/widget/others/user_tool.dart';

class PropertyFunc {

  ///根据房产id查询对应的预付款充值金额
  static Future<double> getDailyPaymentPrePay() async {
    BaseModel baseModel =
    await NetUtil().get(API.manager.dailyPaymentPrePay, params: {
      "estateId": UserTool.appProveider.selectedHouse!.estateId,
    });
    if (baseModel.status ?? false) {
      return (baseModel.data as num).toDouble();
    } else {
      return 0;
    }
  }

  ///根据房产id查询对应的未缴费金额
  static Future<double> getFindUnpaidAmount() async {
    BaseModel baseModel =
    await NetUtil().get(API.manager.findUnpaidAmount, params: {
      "estateId": UserTool.appProveider.selectedHouse!.estateId,
    });
    if (baseModel.status ?? false) {
      return (baseModel.data as num).toDouble();
    } else {
      return 0;
    }
  }

}
