import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/user/province_model.dart';
import 'package:aku_community/pages/property/property_page.dart';
import 'package:aku_community/pages/sign/sign_in_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/ui/community/community_views/community_page.dart';
import 'package:aku_community/ui/market/market_page.dart';
import 'package:aku_community/utils/hive_store.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/utils/websocket/web_socket_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
import 'personal/personal_page.dart';
import 'property/property_index.dart';

class TabNavigator extends StatefulWidget {
  final int? index;
  const TabNavigator({
    Key? key, this.index,
  }) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0;
  DateTime? _lastPressed;

  //页面列表
  List<Widget> _pages = <Widget>[];

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(Get.context!);
    Future.delayed(Duration(milliseconds: 0), () async {
      await appProvider.getMyAddress();//设置默认地址
      List<ProvinceModel> _province = [];
      var agreement = await HiveStore.appBox?.get('cityList') ?? null;
      if (agreement==null) {
        ///获取城市列表
        BaseModel baseModel = await NetUtil().get(
          API.user.findAllCityInfo,
        );
        if (baseModel.data!=null) {
          _province = (baseModel.data as List)
              .map((e) => ProvinceModel.fromJson(e))
              .toList();
          HiveStore.appBox!.put('cityList', _province);
        }
      }
    });
    _pages = [
      HomePage(),
      MarketPage(),
      PropertyPage(),//PropertyIndex(),
      CommunityPage(),
      PersonalIndex()
    ];

    _tabController = TabController(length: _pages.length, vsync: this,initialIndex: widget.index??0);

  }

  _buildBottomBar(
    String title,
    String unselected,
    String selected,
  ) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        unselected,
        height: 44.w,
        width: 44.w,
        color: Colors.black38,
      ),
      activeIcon: Image.asset(
        selected,
        height: 44.w,
        width: 44.w,
      ),
      label: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    //底部导航来
    List<BottomNavigationBarItem> _bottomNav = <BottomNavigationBarItem>[
      _buildBottomBar(
        '首页',
        R.ASSETS_ICONS_TABBAR_HOME_NO_PNG,
        R.ASSETS_ICONS_TABBAR_HOME_PNG,
      ),
      _buildBottomBar(
        '商城',
        R.ASSETS_ICONS_TABBAR_MARKET_NO_PNG,
        R.ASSETS_ICONS_TABBAR_MARKET_PNG,
      ),
      _buildBottomBar(
        '物业',
        R.ASSETS_ICONS_TABBAR_HOUSE_NO_PNG,
        R.ASSETS_ICONS_TABBAR_HOUSE_PNG,
      ),
      _buildBottomBar(
        '社区',
        R.ASSETS_ICONS_TABBAR_MESSAGE_NO_PNG,
        R.ASSETS_ICONS_TABBAR_MESSAGE_PNG,
      ),
      _buildBottomBar(
        '我的',
        R.ASSETS_ICONS_TABBAR_USER_NO_PNG,
        R.ASSETS_ICONS_TABBAR_USER_PNG,
      ),
    ];
    return BeeScaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (_lastPressed == null ||
              DateTime.now().difference(_lastPressed!) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒重新计算
            _lastPressed = DateTime.now();
            BotToast.showText(text: '再点击一次返回退出');
            return false;
          }
          //否则关闭app
          WebSocketUtil().closeWebSocket();
          return true;
        },
        child: TabBarView(
          children: _pages,
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavi: StatefulBuilder(builder: (context, setFunc) {
        return BottomNavigationBar(
          items: _bottomNav,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          selectedFontSize: 20.sp,
          unselectedFontSize: 20.sp,
          onTap: (index) {
            if (UserTool.userProvider.isLogin == false) {
              Get.offAll(() => SignInPage());
            } else {
              _tabController!.animateTo(index, curve: Curves.easeInOutCubic);
              setFunc(() => _currentIndex = index);
            }
          },
        );
      }),
    );
  }
}
