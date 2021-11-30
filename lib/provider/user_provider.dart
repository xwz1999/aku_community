import 'dart:io';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/user/user_detail_model.dart';
import 'package:aku_community/models/user/user_info_model.dart';
import 'package:aku_community/pages/sign/sign_func.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:aku_community/utils/hive_store.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/utils/websocket/web_socket_util.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:power_logger/power_logger.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  bool get isNotLogin => !_isLogin;
  Future setLogin(int token) async {
    try {
      final appProvider = Provider.of<AppProvider>(Get.context!, listen: false);
      _isLogin = true;
      NetUtil()
          .dio!
          .options
          .headers
          .putIfAbsent('App-Admin-Token', () => token);
      HiveStore.appBox!.put('token', token);
      HiveStore.appBox!.put('login', true);
      await updateProfile();
      await updateUserDetail();
      await appProvider.updateHouses(await HouseFunc.passedHouses);
      if (isLogin) {
        WebSocketUtil().setUser(userInfoModel!.id.toString());
        WebSocketUtil().startWebSocket();
      }
      notifyListeners();
    } catch (e) {
      LoggerData.addData(e);
    }
  }

  logout() {
    if (!kIsWeb && !Platform.isMacOS) JPush().deleteAlias();
    final appProvider = Provider.of<AppProvider>(Get.context!, listen: false);
    appProvider.setCurrentHouse(null);
    _isLogin = false;
    _token = null;
    _userInfoModel = null;
    _userDetailModel = null;
    NetUtil().get(API.user.logout, showMessage: true);
    NetUtil().dio!.options.headers.remove('App-Admin-Token');
    HiveStore.appBox!.delete('token');
    HiveStore.appBox!.delete('login');
    WebSocketUtil().closeWebSocket();

    notifyListeners();
  }

  Future updateProfile() async {
    _userInfoModel = await SignFunc.getUserInfo();
    if (_userInfoModel != null && !kIsWeb && !Platform.isMacOS) {
      try {
         await JPush().setAlias(_userInfoModel!.id.toString());
      } catch (e) {
        LoggerData.addData(e);
      }
    }
    notifyListeners();
  }

  Future updateUserDetail() async {
    UserDetailModel? _model = await SignFunc.getUserDetail();
    if (_model != null) {
      _userDetailModel = _model;
      UserTool.appProveider.setCurrentHouseId(_model.nowEstateExamineId);
    }
    notifyListeners();
  }

  String? _token;
  String get token => _token ?? '';

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  UserDetailModel? _userDetailModel;
  UserDetailModel? get userDetailModel => _userDetailModel;

  ///设置性别
  Future setSex(int sex) async {
    BaseModel baseModel = await NetUtil().post(
      API.user.setSex,
      params: {'sex': sex},
      showMessage: true,
    );
    if (baseModel.status!) {
      _userInfoModel!.sex = sex;
      notifyListeners();
    }
  }

  ///设置生日
  Future setBirthday(DateTime date) async {
    BaseModel baseModel = await NetUtil().post(
      API.user.setBirthday,
      params: {
        'birthday': DateUtil.formatDate(date, format: "yyyy-MM-dd HH:mm:ss")
      },
      showMessage: true,
    );
    if (baseModel.status!) {
      _userInfoModel!.birthday =
          DateUtil.formatDate(date, format: "yyyy-MM-dd HH:mm:ss");
      notifyListeners();
    }
  }

  //修改昵称
  Future setName(String name) async {
    BaseModel baseModel = await NetUtil().post(
      API.user.updateNickName,
      params: {'nickName': name},
      showMessage: true,
    );
    if (baseModel.status!) {
      _userInfoModel!.nickName = name;
      notifyListeners();
    }
  }

  //修改手机号
  Future updateTel(String oldTel, String newTel, String code) async {
    BaseModel baseModel = await NetUtil().post(
      API.user.updateTel,
      params: {'oldTel': oldTel, 'newTel': newTel, 'code': code},
      showMessage: true,
    );
    if (baseModel.status!) {
      _userInfoModel!.tel = newTel;
      notifyListeners();
    }
  }

  ///修改头像
  Future updateAvatar(String? path) async {
    BaseModel model = await NetUtil().post(
      API.user.udpdateAvatar,
      params: {
        'fileUrls': [path]
      },
      showMessage: true,
    );
    if (model.status!) {
      await updateProfile();
    }
  }
}
