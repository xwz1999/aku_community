import 'package:aku_community/constants/app_theme.dart';
import 'package:aku_community/main_initialize.dart';
import 'package:aku_community/pages/splash/splash_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/provider/sign_up_provider.dart';
import 'package:aku_community/provider/user_provider.dart';
import 'package:aku_community/utils/developer_util.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:power_logger/power_logger.dart';
import 'package:provider/provider.dart';

void main() async {
  const buildType = const String.fromEnvironment('BUILD_TYPE');
  DeveloperUtil.setDev(!(buildType.contains('PRODUCT')));
  WidgetsFlutterBinding.ensureInitialized();

  ///firebase crashlytics initalize
  //await MainInitialize.initFirebase();
  MainInitialize.initTheme();
  MainInitialize.initWechat();
  MainInitialize.initWebSocket();
  await MainInitialize.initJPush();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          //点击输入框外部隐藏键盘⌨️
          //只能响应点击非手势识别的组件
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: ScreenUtilInit(
          designSize: Size(750, 1334),
          builder: () => GetMaterialApp(
            onGenerateTitle: (context) => S.of(context)!.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            home: SplashPage(),
            //国际化支持
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('zh')],
            locale: Locale('zh'),
            //builder: BotToastInit(),
            builder: (context, child) {
              return MediaQuery(
                //设置文字大小不随系统设置改变
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: BotToastInit().call(context,child),
              );
            },
            navigatorObservers: [BotToastNavigatorObserver()],
          ),
        ),
      ),
    );
  }
}
