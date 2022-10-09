import 'dart:async';
import 'dart:convert';

import 'package:aku_community/constants/config.dart';
import 'package:aku_community/models/pay/pay_model.dart';
import 'package:aku_community/models/pay/wx_pay_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluwx/fluwx.dart';
import 'package:power_logger/power_logger.dart';
import 'package:tobias/tobias.dart';

enum PAYTYPE {
  ///支付宝
  ALI,

  ///微信
  WX,

  ///现金
  CASH,

  ///pos
  POS
}

class PayUtil {
  void resultSatus(String status) {
    switch (status) {
      case '8000':
        BotToast.showText(text: '正在处理中');
        break;
      case '4000':
        BotToast.showText(text: '订单支付失败');
        break;
      case '5000':
        BotToast.showText(text: '重复请求');
        break;
      case '6001':
        BotToast.showText(text: '	用户中途取消');
        break;
      case '6002':
        BotToast.showText(text: '网络连接出错');
        break;
      case '6004':
        BotToast.showText(text: '支付结果未知,请查询商户订单列表中订单的支付状态');
        break;
      default:
        BotToast.showText(text: '其他支付错误');
        break;
    }
  }

  String _resultStatus = '';

  ///传入订单信息和确认订单请求地址
  Future<bool> callAliPay(String order, String apiPath) async {
    var install = await isAliPayInstalled();
    if (!install) {
      BotToast.showText(text: '未安装支付宝！');
      return false;
    }
    Map<dynamic, dynamic> result = {};
    try {
      result = await aliPay(order);
    } catch (e) {
      print(e.toString());
    }
    _resultStatus = result['resultStatus'];
    if (_resultStatus == '9000') {
      String _res = result['result'];
      PayModel _model = PayModel.fromJson(jsonDecode(_res));
      bool _confirmResult = await _confirmPayResult(
          apiPath, _model.aliPayTradeAppPayResponse.outTradeNo);
      return _confirmResult;
    } else {
      resultSatus(_resultStatus);
      return false;
    }
  }

  Future<bool> _confirmPayResult(String path, String code) async {
    try {
      int status = 0;
      for (var i = 0; i < 3; i++) {
        await Future.delayed(Duration(milliseconds: 1000), () async {
          Response response = await NetUtil().dio!.get(path, queryParameters: {
            "code": code,
          });
          status = response.data['status'] as int;
        });
        if (status == 2) {
          break;
        }
      }
      if (status == 2) {
        BotToast.showText(text: '交易成功');
        return true;
      } else {
        BotToast.showText(text: '交易失败 错误码${status}');
        return false;
      }
    } catch (e) {
      BotToast.showText(text: '网络请求错误');
      LoggerData.addData(e);
      return false;
    }
  }

  ///微信支付

  StreamSubscription? _wxPayStream;

  void wxPayAddListener(
      {required VoidCallback paySuccess,
        Function(BaseWeChatResponse)? payError}) {
    _wxPayStream = weChatResponseEventHandler.listen((event) {
      if (kDebugMode) {
        print(event);
        print('errorCode:${event.errCode}    errorStr:${event.errStr}');
      }
      if (event.errCode == 0) {
        paySuccess();
      } else {
        print('1231231231232131221');
        print(event);
        LoggerData.addData(
            'errorCode:${event.errCode}    errorStr:${event.errStr ?? '支付失败'}');
        LoggerData.addData(
            'event:${event}');
        BotToast.showText(text: event.errStr ?? '支付失败');
        if (payError != null) payError(event);
        //payError == null ? null : payError(event);
      }
    });
  }

  void removeWxPayListener() {
    _wxPayStream?.cancel();
  }

  Future callWxPay({
    required WxPayModel payModel,
  }) async {
    print(payModel.partnerId);
    print(payModel.prepayId);
    print(payModel.package);
    print(payModel.nonceStr);
    print(payModel.timeStamp);
    print(payModel.sign);
    await payWithWeChat(
        appId:AppConfig.wechatAppId,
        partnerId: payModel.partnerId,
        prepayId: payModel.prepayId,
        packageValue: payModel.package,
        nonceStr: payModel.nonceStr,
        timeStamp: int.parse(payModel.timeStamp),
        sign: payModel.sign);
  }
}
