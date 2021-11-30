import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/community/activity_item_model.dart';
import 'package:aku_community/model/community/board_model.dart';
import 'package:aku_community/model/community/community_topic_model.dart';
import 'package:aku_community/model/community/hot_news_model.dart';
import 'package:aku_community/model/community/swiper_model.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/models/market/goods_classification.dart';
import 'package:aku_community/models/market/goods_popular_model.dart';
import 'package:aku_community/models/market/order/goods_home_model.dart';
import 'package:aku_community/utils/network/base_list_model.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:bot_toast/bot_toast.dart';

class Userfunc {

  ///查询我的收货地址列表
  static Future<List<AddressModel>> getMyAddress(
      ) async {
    BaseModel model = await NetUtil().get(
      API.user.myAddressList,
    );
    if (model.data!.length == 0)
      return [];
    return (model.data as List)
        .map((e) => AddressModel.fromJson(e))
        .toList();
  }

  ///添加收货地址
  static Future<bool> insertAddress(String name,String tel,int? location,
      String addressDetail,int? isDefault) async {
    BaseModel model = await NetUtil().post(
      API.user.insertAddress,
        params: {'name':name,'tel':tel,'location':location,
          'addressDetail':addressDetail,'isDefault':isDefault},
      showMessage: false
    );
    if (model.status??false)
      {
        BotToast.showText(text: '添加成功');
        return true;
      }

    else{
      BotToast.showText(text: '添加失败');
      return false;
    }

  }

  ///修改收货地址
  static Future<bool> updateAddress(int id,String name,String tel,int? location,
      String addressDetail,int? isDefault) async {
    BaseModel model = await NetUtil().post(
      API.user.updateAddress,
        params: {'id': id,'name':name,'tel':tel,'location':location,
          'addressDetail':addressDetail,'isDefault':isDefault},
        showMessage: false
    );
    if (model.status??false)
    {
      BotToast.showText(text: '修改成功');
      return true;
    }

    else{
      BotToast.showText(text: '修改失败');
      return false;
    }
  }

  ///删除收货地址
  static Future<bool> deleteAddress(int addressId) async {
    BaseModel model = await NetUtil().post(
        API.user.deleteAddress,
        params: {'addressId': addressId},
        showMessage: false
    );
    if (model.status??false)
    {
      BotToast.showText(text: '删除成功');
      return true;
    }

    else{
      BotToast.showText(text: '删除失败');
      return false;
    }
  }


  ///设置默认收货地址
  static Future<bool> setIsDefaultAddress(int addressId) async {
    BaseModel model = await NetUtil().post(
        API.user.settingDefaultAddress,
        params: {'addressId': addressId},
        showMessage: false
    );
    if (model.status??false)
    {
      BotToast.showText(text: '设置成功');
      return true;
    }

    else{
      BotToast.showText(text: '设置失败');
      return false;
    }
  }













  ///查询SKU总数
  static Future<String> getSkuTotal() async {
    BaseModel model = await NetUtil().get(
      API.market.skuTotal,
    );
    if (model.data! == null)
      return '0';
    return (model.data as int).toString();
  }



  static Future<List<BoardItemModel>> board() async {
    BaseListModel model = await NetUtil().getList(
      API.community.boardList,
      params: {'pageNum': 1, 'size': 5},
    );
    if (model.tableList!.length == 0) return [];
    return model.tableList!.map((e) => BoardItemModel.fromJson(e)).toList();
  }

  static Future<List<SwiperModel>> swiper() async {
    BaseModel model = await NetUtil().get(
      API.community.getSwiper,
    );
    if (model.data!.length == 0)
      return [];
    return (model.data as List)
        .map((e) => SwiperModel.fromJson(e))
        .toList();
  }
}
