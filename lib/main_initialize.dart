import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fluwx/fluwx.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:power_logger/power_logger.dart';

import 'package:akuCommunity/constants/app_theme.dart';
import 'package:akuCommunity/constants/config.dart';

class MainInitialize {
  ///初始化firebase
  static Future initFirebase() async {
    await Firebase.initializeApp();
    //TODO setCrashlyticsCollectionEnabled state
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = (detail) {
      LoggerData.addData(detail.exception.toString(), tag: 'EXCEPTION');
      FirebaseCrashlytics.instance.recordFlutterError(detail);
    };
  }

  static initTheme() {
    SystemChrome.setSystemUIOverlayStyle(SystemStyle.initial);
  }

  static Future initJPush() async {
    JPush jpush = new JPush();
    Function(Map<String, dynamic> message) jPushLogger(String type) {
      return (Map<String, dynamic> message) async {
        LoggerData.addData({
          'type': type,
          'message': message,
        });
      };
    }

    jpush.addEventHandler(
      onReceiveNotification: jPushLogger('onReceiveNotification'),
      onOpenNotification: jPushLogger('onOpenNotification'),
      onReceiveMessage: jPushLogger('onReceiveMessage'),
    );
    jpush.setup(
      appKey: "6a2c6507e3e8b3187ac1c9f9",
      channel: "developer-default",
      production: false,
      debug: true,
    );
    String rID = await jpush.getRegistrationID();
    LoggerData.addData(rID, tag: 'RegistrationID');
  }

  static initWechat() {
    registerWxApi(appId: AppConfig.wechatAppId);
  }
}