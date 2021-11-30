import 'package:aku_community/constants/api.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';

class ShopCarFunc {
  static GoodStatus getGoodsStatus(int jcook, int bee) {
    if (jcook == 0) {
      return GoodStatus.unSell;
    } else {
      if (bee == 0) {
        return GoodStatus.unSell;
      } else {
        return GoodStatus.onSell;
      }
    }
  }
}

enum GoodStatus {
  onSell,
  unSell,
}
