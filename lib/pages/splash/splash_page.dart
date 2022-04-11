import 'dart:io';

import 'package:aku_community/const/resource.dart';
import 'package:aku_community/pages/setting_page/agreement_page/agreement_page.dart';
import 'package:aku_community/pages/setting_page/agreement_page/privacy_page.dart';
import 'package:aku_community/pages/tab_navigator.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/provider/user_provider.dart';
import 'package:aku_community/utils/developer_util.dart';
import 'package:aku_community/utils/hive_store.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:power_logger/power_logger.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  TapGestureRecognizer _agreementRecognizer = TapGestureRecognizer();
  TapGestureRecognizer _privacyRecognizer = TapGestureRecognizer();

  ///原生端耗时加载
  Future _originOp() async {
    //初始化HiveStore
    await Hive.initFlutter();
    await HiveStore.init();
  }

  Future _initOp() async {
    //ensure call _originOp first.
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.initApplications();
      appProvider.startLocation();
      if (HiveStore.appBox!.get('login') ?? false) {
        await userProvider.setLogin(HiveStore.appBox!.get('token'));
      }
    } catch (e) {
      LoggerData.addData(e);
    }
  }

  Future<bool?> _showLoginVerify() async {
    return await showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('隐私政策和用户协议'),
          content: RichText(
            text: TextSpan(
                text: '点击登录即表示您已阅读并同意',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: '《用户协议》',
                      style: TextStyle(color: Colors.blue),
                      recognizer: _agreementRecognizer
                        ..onTap = () {
                          Get.to(() => AgreementPage());
                        }),
                  TextSpan(
                      text: '《隐私政策》',
                      style: TextStyle(color: Colors.blue),
                      recognizer: _privacyRecognizer
                        ..onTap = () {
                          Get.to(() => PrivacyPage());
                        }),
                  TextSpan(
                      style: TextStyle(color: Colors.black),
                      text:
                          '（特别是免除或限制责任、管辖等粗体下划线标注的条款）。如您不同意上述协议的任何条款，您应立即停止登录及使用本软件及服务。')
                ]),
          ),

          // ),
          actions: [
            CupertinoDialogAction(
              child: Text('同意'),
              onPressed: () => Get.back(result: true),
            ),
            CupertinoDialogAction(
              child: Text('拒绝'),
              onPressed: () => Get.back(result: false),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    PowerLogger.start(
      context,
      debug: DeveloperUtil.dev,
    );
    Future.delayed(Duration(milliseconds: 0), () async {
      await _originOp();
      var agreement = await HiveStore.appBox?.get('agreement') ?? false;
      if (!agreement) {
        var result = await _showLoginVerify();
        if (result == null || !result) {
          SystemNavigator.pop();
          HiveStore.appBox!.put('agreement', false);
        } else {
          HiveStore.appBox!.put('agreement', true);
        }
      }
      //初始化AMap
      // await AmapLocation.instance.init(iosKey: 'ios key');
      if (Platform.isAndroid || Platform.isIOS) {
        await Permission.locationWhenInUse.request();
        AMapFlutterLocation.updatePrivacyShow(true, true);
        AMapFlutterLocation.updatePrivacyAgree(true);
      }
      await _initOp();
      Get.offAll(() => TabNavigator());
    });
    // _initOp().then((value) => Get.offAll(() => TabNavigator()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 80,
        width: 80,
        child: Image.asset(R.ASSETS_IMAGES_LOGO_PNG),
      ).centered(),
      bottomNavigationBar: SizedBox(
        child: CircularProgressIndicator().centered(),
        height: 100,
      ),
    );
  }
}
