import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:power_logger/power_logger.dart';
import 'package:provider/provider.dart';

import 'package:aku_community/constants/app_theme.dart';
import 'package:aku_community/constants/config.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/utils/message_parser.dart';
import 'package:aku_community/utils/websocket/fire_dialog.dart';
import 'package:aku_community/utils/websocket/web_socket_util.dart';

class MainInitialize {
  ///初始化firebase
  static Future initFirebase() async {
    await Firebase.initializeApp();
    // web MacOS Platform not support firebase
    if (!kIsWeb && !Platform.isMacOS) {
      FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kReleaseMode);
    }
    FlutterError.onError = (detail) {
      LoggerData.addData(detail);
      if (kReleaseMode && !kIsWeb && !Platform.isMacOS) {
        FirebaseCrashlytics.instance.recordFlutterError(detail);
      }
      FlutterError.presentError(detail);
    };
  }

  static initTheme() {
    SystemChrome.setSystemUIOverlayStyle(SystemStyle.initial);
  }

  static Future initJPush() async {
    if (kIsWeb || Platform.isMacOS) return;
    JPush jpush = new JPush();

    Future<dynamic> Function(Map<String, dynamic>? message)? jPushLogger(
        String type) {
      return (Map<String, dynamic>? message) async {
        LoggerData.addData(message, tag: type);
      };
    }

    jpush.addEventHandler(
      onReceiveNotification: (message) async {
        LoggerData.addData(message, tag: 'onReceiveNotification');
        await MessageParser(message).shot();
        final appProvider =
            Provider.of<AppProvider>(Get.context!, listen: false);
        appProvider.getMessageCenter();
      },
      onOpenNotification: jPushLogger('onOpenNotification'),
      onReceiveMessage: jPushLogger('onReceiveMessage'),
    );
    jpush.setup(
      appKey: "6a2c6507e3e8b3187ac1c9f9",
      channel: "developer-default",
      production: false,
      debug: true,
    );
    String? rID = await jpush.getRegistrationID();
    LoggerData.addData(rID, tag: 'RegistrationID');
  }

  static initWechat() {
    if (kIsWeb || Platform.isMacOS) return;
    registerWxApi(appId: AppConfig.wechatAppId);
  }

  static initWebSocket() {
    WebSocketUtil().initWebSocket(
      consolePrint: false,
      onReceiveMes: (message) async {
        await FireDialog.fireAlarm(message);
      },
      onError: (e) {
        LoggerData.addData(e);
      },
    );
  }
}
