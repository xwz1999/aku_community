import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/application_objects.dart';
import 'package:aku_community/pages/life_pay/life_pay_choose_page.dart';
import 'package:aku_community/pages/message_center_page/message_center_page.dart';
import 'package:aku_community/pages/personal/user_profile_page.dart';
import 'package:aku_community/pages/property/property_func.dart';
import 'package:aku_community/pages/sign/sign_in_page.dart';
import 'package:aku_community/painters/user_bottom_bar_painter.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/provider/user_provider.dart';
import 'package:aku_community/ui/profile/house/add_house_page.dart';
import 'package:aku_community/ui/profile/house/house_owners_page.dart';
import 'package:aku_community/ui/search/bee_search.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/login_util.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:aku_community/widget/views/application_view.dart';
import 'package:badges/badges.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PropertyPage extends StatefulWidget {
  final bool? isSign;

  PropertyPage({Key? key, this.isSign}) : super(key: key);

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int sum = 0;
  int commentCount = 0;
  int sysCount = 0;
  num unpaid = 0;
  num paid = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getRefresh();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getRefresh(){
    Future.delayed(Duration(milliseconds: 0), () async {
      paid = await PropertyFunc.getDailyPaymentPrePay();
      unpaid =  await PropertyFunc.getFindUnpaidAmount();
      setState(() {});
    });
  }
  
  SliverAppBar _sliverAppBar(double height) {
    final userProvider = Provider.of<UserProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    commentCount = appProvider.messageCenterModel.commentCount ?? 0;
    sysCount = appProvider.messageCenterModel.sysCount ?? 0;
    sum = commentCount + sysCount;
    return SliverAppBar(
      pinned: true,
      snap: false,
      //toolbarHeight: 0,
      elevation: 0,
      collapsedHeight: 420.w,
      titleSpacing: 10.0,
      floating: true,
      title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (appProvider.location != null)
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Image.asset(
                  R.ASSETS_ICONS_ICON_PROPERTY_LOCATION_PNG,
                  width: 40.w,
                  height: 40.w,
                ),
              ),
            Text(
              appProvider.location?['city'] == null
                  ? ''
                  : appProvider.location?['city'] as String? ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32.sp,
                color: Colors.white.withOpacity(0.85),
              ),
              textAlign: TextAlign.center,
            ),
          ]),
      actions: [
        GestureDetector(
          onTap: () {
            Get.to(() => BeeSearch());
          },
          child: Image.asset(R.ASSETS_ICONS_ICON_PROPERTY_SEARCH_PNG,
              height: 40.w, width: 40.w),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w, left: 12.w),
          child: Badge(
              elevation: 0,
              badgeColor: Color(0xFFCF2525),
              padding: sum > 9 ? EdgeInsets.all(2.w) : EdgeInsets.all(5.w),
              showBadge: appProvider.messageCenterModel.commentCount != 0 ||
                  appProvider.messageCenterModel.sysCount != 0,
              position: BadgePosition.topEnd(
                top: 3,
                end: -5,
              ),
              badgeContent: Text(
                (sum).toString(),
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
              ),
              child: GestureDetector(
                onTap: () {
                  if (LoginUtil.isNotLogin) return;
                  Get.to(() => MessageCenterPage());
                },
                child: Image.asset(R.ASSETS_ICONS_ICON_PROPERTY_MESSAGE_PNG,
                    height: 40.w, width: 40.w),
              )),
        ),
      ],
      expandedHeight: 420.w,
      backgroundColor: Colors.white,
      flexibleSpace: Stack(
        children: [
          Positioned(
              child: Image.asset(
                R.ASSETS_IMAGES_PROPERTY_BG_PNG,
                width: double.infinity,
                height: 503.w,
                fit: BoxFit.cover,
              ),


              top: 0,
              left: 0,
              right: 0,
              bottom: 0),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(left: 32.w, right: 32.w),
              width: 686.w,
              height: 74.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  24.wb,
                  Text(
                    '当前绑定房屋',
                    style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.00),
                  ),
                  Spacer(),
                  Text(
                    userProvider.userDetailModel!.estateNames!.isEmpty?'暂未绑定': userProvider.userDetailModel!.estateNames?[0]??'暂未绑定',
                    style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.00,
                        fontWeight: FontWeight.bold),
                  ),
                  32.wb,
                  GestureDetector(
                    onTap: () {
                      Get.to(HouseOwnersPage(
                        identify: UserTool.userProvider.userDetailModel!.type ?? 4,
                      ));

                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 80.w,
                      height: 42.w,
                      child: Text(
                        '切换',
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.white.withOpacity(0.85)),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF3D8CE8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.w),
                        ),
                      ),
                    ),
                  ),
                  24.wb,
                ],
              ),
            ),
            top: kTextTabBarHeight + 50.w,
            left: 0,
            right: 0,
          ),
          Positioned(
            child: _goodsTitle(),
            top: kTextTabBarHeight + 50.w + 94.w,
            left: 0,
            right: 0,
          ),
          Positioned(
            child: Container(
              padding: EdgeInsets.only(top: 20.w),
              height: 150.w,
              child: TabBarView(
                children: [_payView(true), _payView(false)],
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            top: kTextTabBarHeight + 50.w + 94.w + 60.w,
            left: 0,
            right: 0,
          ),
        ],
      ),
    );
  }

  _payView(bool pay) {
    return Container(
      padding: EdgeInsets.only(left: 36.w, right: 36.w),
      width: double.infinity,
      height: 150.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pay?paid.toStringAsFixed(2):unpaid.toStringAsFixed(2),
                style: TextStyle(
                  color: Color(0xFFFFFFFF).withOpacity(0.85),
                  fontSize: 40.sp,
                ),
              ),
              8.hb,
              Text(
                '点击查看明细',
                style: TextStyle(
                  color: Color(0xFFFFFFFF).withOpacity(0.45),
                  fontSize: 22.sp,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async{
              final appProvider = Provider.of<AppProvider>(Get.context!, listen: false);
              if (appProvider.selectedHouse == null) {
                BotToast.showText(text: '请先添加房屋');
                Get.to(() => AddHousePage());

              }else{
                bool? result = await Get.to(() => LifePayChoosePage());
                if (result == true) _getRefresh();
              }

            },
            child: Container(
              alignment: Alignment.center,
              width: 160.w,
              height: 55.w,
              child: Text(
                !pay ? '缴纳账单' : '点击充值',
                style: TextStyle(
                    fontSize: 24.sp, color: Colors.white.withOpacity(0.85)),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFFC257),

                borderRadius: BorderRadius.all(
                  Radius.circular(8.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _goodsTitle() {
    return Row(
      children: [
        24.wb,
        Container(
          height: 60.w,
          child: Material(
            color: Colors.transparent,
            child: TabBar(
                onTap: (index) {
                  // _presenter.fetchList(_category.id, 0, _sortType);
                  setState(() {});
                },
                isScrollable: true,
                labelPadding: EdgeInsets.zero,
                controller: _tabController,
                labelColor: Colors.white.withOpacity(0.85),
                unselectedLabelColor: Colors.white.withOpacity(0.65),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 40.w),
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                ),
                indicatorColor: Color(0xFFE8A93A),
                tabs: _tabItems()),
          ),
        ),
        Spacer(),
        Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Text(
                '缴费记录',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 24.sp,
                ),
              ),
              10.wb,
              Icon(
                CupertinoIcons.chevron_forward,
                size: 24.w,
                color: Colors.white.withOpacity(0.45),
              ),
            ],
          ),
        ),
        36.wb,
      ],
    );
  }

  List<Widget> _tabItems() {
    return [_tabItem(0, '未缴账单'), _tabItem(1, '预缴金额')];
  }

  _tabItem(int index, String text) {
    bool isChoose = index == _tabController.index;
    // Color textColor = index == _tabController.index
    //     ? getCurrentThemeColor()
    //     : Colors.black.withOpacity(0.9);
    return Tab(
      child: Container(
        alignment: Alignment.center,
        width: 150.w,

        // color: Colors.white,
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontWeight: isChoose ? FontWeight.bold : FontWeight.normal,
                  fontSize: isChoose ? 32.sp : 28.sp,
                  color: isChoose
                      ? Colors.white.withOpacity(0.85)
                      : Colors.white.withOpacity(0.65)),
            ),
          ],
        ),
      ),
    );
  }

  Container _containerBar(String title) {
    return Container(
      color: title == '我的物业' ? Colors.white : BaseStyle.colorf9f9f9,
      padding: EdgeInsets.all(title == '我的物业' ? 0 : 32.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: BaseStyle.fontSize34,
              color: ktextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _statusHeight = MediaQuery.of(context).padding.top;
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: EasyRefresh(
        header: MaterialHeader(),
        onRefresh: () async {
          await userProvider.updateProfile();
          await userProvider.updateUserDetail();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            _sliverAppBar(_statusHeight),

            // orderWidget,
            SliverToBoxAdapter(
              child: _getFunctionView(getOutApp, '出行安全', Color(0xFFFAC058)),
            ),
            SliverToBoxAdapter(
              child: _getFunctionView(
                  propertyServicesApp, '物业服务', Color(0xFF58FA8F)),
            ),
            SliverToBoxAdapter(
              child:
                  _getFunctionView(residentLifeApp, '居民生活', Color(0xFF58C0FA)),
            ),
            SliverToBoxAdapter(
              child: _getFunctionView(
                  aboutCommunityApp, '关于社区', Color(0xFFFA5858)),
            ),
          ],
        ),
      ),
    );
  }

  _getFunctionView(List<AO> item, String title, Color color) {
    return Container(
      margin: EdgeInsets.only(left: 32.w, right: 32.w, top: 32.w),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            offset: Offset(1, 1),
          ),
        ],
      ),
      //margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // _containerBar('我的物业'),
          Container(
            child: Column(
              children: [
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6.w),
                      width: 4.w,
                      height: 24.w,
                      color: color,
                    ),
                    10.wb,
                    _getTitle(title),
                  ],
                ),
                ApplicationView.custom(
                  items: item,
                  needAllApp: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28.sp,
        color: ktextPrimary,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
