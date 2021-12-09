// Dart imports:

import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/community/activity_item_model.dart';
import 'package:aku_community/model/community/board_model.dart';
import 'package:aku_community/model/community/swiper_model.dart';
import 'package:aku_community/pages/home/widget/animate_app_bar.dart';
import 'package:aku_community/pages/life_pay/life_pay_choose_page.dart';
import 'package:aku_community/pages/message_center_page/message_center_page.dart';
import 'package:aku_community/pages/one_alarm/widget/alarm_page.dart';
import 'package:aku_community/pages/things_page/fixed_submit_page.dart';
import 'package:aku_community/pages/visitor_access_page/visitor_access_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/ui/community/activity/activity_card.dart';
import 'package:aku_community/ui/community/activity/activity_list_page.dart';
import 'package:aku_community/ui/community/community_func.dart';
import 'package:aku_community/ui/community/facility/facility_appointment_page.dart';
import 'package:aku_community/ui/home/application/all_application.dart';
import 'package:aku_community/ui/home/home_notification.dart';
import 'package:aku_community/ui/home/home_title.dart';
import 'package:aku_community/ui/home/public_infomation/public_information_detail_page.dart';
import 'package:aku_community/ui/manager/advice/advice_page.dart';
import 'package:aku_community/ui/search/bee_search.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/login_util.dart';
import 'package:aku_community/widget/animated/OverlayWidget.dart';
import 'package:aku_community/widget/others/rectIndicator.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:power_logger/power_logger.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'widget/home_search.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  int _currentIndicator = 0;

  ScrollController? _scrollController;

  List<dynamic>? data;

  late EasyRefreshController _refreshController;

  int page = 1;
  int commentCount = 0;
  int sysCount = 0;
  int sum = 0;

  // ActivityItemModel? _activityItemModel;
  List<ActivityItemModel> _activityItemModels = [];
  List<BoardItemModel> _boardItemModels = [];
  List<SwiperModel> _swiperModels = [];

  @override
  void initState() {
    super.initState();
    if (UserTool.userProvider.isLogin) {
      try {
        JPush().setAlias(UserTool.userProvider.userInfoModel!.id.toString());
        LoggerData.addData(
            'setAlias ${UserTool.userProvider.userInfoModel!.id} ${DateTime.now()}');
      } catch (e) {
        LoggerData.addData('${e.toString()} ${DateTime.now()}');
      }
    }
    _scrollController = ScrollController();
    _refreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    commentCount = appProvider.messageCenterModel.commentCount ?? 0;
    sysCount = appProvider.messageCenterModel.sysCount ?? 0;
    sum = commentCount + sysCount;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AnimateAppBar(
        scrollController: _scrollController,
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => BeeSearch());
            },
            child: Image.asset(R.ASSETS_ICONS_ICON_MAIN_FIND_PNG,
                height: 40.w, width: 40.w),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 12.w),
            child: Badge(
                elevation: 0,
                badgeColor: Color(0xFFCF2525),
                padding: sum > 9 ? EdgeInsets.all(2.w) : EdgeInsets.all(5.w),
                showBadge: appProvider.messageCenterModel.commentCount != 0 ||
                    appProvider.messageCenterModel.sysCount != 0,
                position: BadgePosition.topEnd(
                  top: 8.w,
                  end: -4.w,
                ),
                badgeContent: Text(
                  (sum>99?99:sum).toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (LoginUtil.isNotLogin) return;
                    Get.to(() => MessageCenterPage());
                  },
                  child: Image.asset(R.ASSETS_ICONS_ICON_MAIN_MESSAGE_PNG,
                      height: 40.w, width: 40.w),
                )),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //
      //   child: Container(
      //     decoration: BoxDecoration(
      //         image: DecorationImage(
      //           fit: BoxFit.fill,
      //           image:
      //           AssetImage(R.ASSETS_ICONS_ICON_MAIN_OPEN_PNG),)
      //     ),
      //   ),
      //   onPressed: (){
      //     print('FloatingActionButton');
      //   },
      // ),
      body: Stack(
        children: [
          EasyRefresh(
            controller: _refreshController,
            header: MaterialHeader(),
            firstRefresh: true,
            onRefresh: () async {
              //_activityItemModel = await CommunityFunc.activity();
              _activityItemModels = await CommunityFunc.activityList();
              _boardItemModels = await CommunityFunc.board();
              _swiperModels = await CommunityFunc.swiper();
              appProvider.getMessageCenter();
              setState(() {});
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeSearch(),

                      HomeSwiper(), //要做点击事件
                      // SizedBox(height: 100.w),
                      Container(
                        padding: EdgeInsets.only(top: 24.w, bottom: 32.w),
                        child: getFunction(), //ApplicationView(),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 0,
                                  offset: Offset(0.0, 2.0),
                                  spreadRadius: 0.1)
                            ],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(28),
                                bottomRight: Radius.circular(28))),
                      )
                      //ApplicationBox(child: ApplicationView()),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                      height: 40,
                      margin:
                          EdgeInsets.only(left: 32.w, right: 32.w, top: 24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 4,
                              spreadRadius: 0.5)
                        ],
                      ),
                      child: HomeNotification(items: _boardItemModels)),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 24.w),
                          padding: EdgeInsets.only(left: 32.w, top: 24.w),
                          width: 140,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(R.ASSETS_IMAGES_CARD_YELLOW_PNG),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '访客邀请',
                                style: TextStyle(
                                    color: Color(0xD9000000),
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              10.hb,
                              Text(
                                '一键分享',
                                style: TextStyle(
                                  color: Color(0x73000000),
                                  fontSize: 20.sp,
                                ),
                              ),
                              Text(
                                '让拜访不再是难事',
                                style: TextStyle(
                                  color: Color(0x73000000),
                                  fontSize: 20.sp,
                                ),
                              ),
                              Spacer(),
                              Image.asset(
                                R.ASSETS_ICONS_ICON_MAIN_INVITE_PNG,
                                width: 100.w,
                                height: 100.w,
                              ),
                              30.hb,
                            ],
                          ),
                        ),
                        onTap: () {
                          Get.to(VisitorAccessPage());
                        },
                      ),
                      25.wb,
                      Container(
                        margin: EdgeInsets.only(top: 24.w),
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 190,
                                height: 69,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage(R.ASSETS_IMAGES_CARD_PINK_PNG),
                                )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    20.wb,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        20.hb,
                                        Text(
                                          '一键报警',
                                          style: TextStyle(
                                              color: Color(0xD9000000),
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        10.hb,
                                        Text(
                                          '提交报警位置给物业',
                                          style: TextStyle(
                                            color: Color(0x73000000),
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Image.asset(
                                      R.ASSETS_ICONS_ICON_MAIN_POLICE_PNG,
                                      width: 98.w,
                                      height: 98.w,
                                    ),
                                    20.wb,
                                  ],
                                ),
                              ),
                              onTap: () {
                                Get.to(AlarmPage());
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: 20.w),
                                width: 190,
                                height: 69,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage(R.ASSETS_IMAGES_CARD_BLUE_PNG),
                                )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    20.wb,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        20.hb,
                                        Text(
                                          '建议咨询',
                                          style: TextStyle(
                                              color: Color(0xD9000000),
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        10.hb,
                                        Text(
                                          '欢迎给我们提供服务意见',
                                          style: TextStyle(
                                            color: Color(0x73000000),
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Image.asset(
                                      R.ASSETS_ICONS_ICON_MAIN_CONSULT_PNG,
                                      width: 98.w,
                                      height: 98.w,
                                    ),
                                    20.wb,
                                  ],
                                ),
                              ),
                              onTap: () {
                                Get.to(AdvicePage(type: AdviceType.SUGGESTION));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    // HomeTitle(
                    //   title: '公共资讯',
                    //   suffixTitle: '更多资讯',
                    //   onTap: () async {
                    //     final cancel = BotToast.showLoading();
                    //     BaseModel model = await NetUtil().get(API.news.category);
                    //     List<NewsCategoryModel>? category;
                    //     if (model.status == true && model.data != null) {
                    //       category = (model.data as List)
                    //           .map((e) => NewsCategoryModel.fromJson(e))
                    //           .toList();
                    //     }
                    //     cancel();
                    //     Get.to(
                    //         () => PublicInfomationPage(models: category ?? []));
                    //   },
                    // ),
                    HomeTitle(
                      title: '社区活动',
                      suffixTitle: '查看全部',
                      onTap: () => Get.to(() => ActivityListPage()),
                    ),
                    _activityItemModels == []
                        ? SizedBox()
                        : Container(
                            height: 400.w,
                            padding: EdgeInsets.only(left: 32.w),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 16.w,
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 500.w,
                                  child: Builder(
                                    builder: (context) {
                                      return ActivityCard(
                                          model: _activityItemModels[index]);
                                    },
                                  ),
                                );
                              },
                              itemCount: _activityItemModels.length,
                            ),
                          ),
                    // : ActivityCard(model: _activityItemModel)
                    //     .pSymmetric(h: 24.w, v: 24.w),
                  ],
                )),
              ],
            ),
          ),
          OverlayLivingBtnWidget()
        ],
      ),
    );
  }

  Widget HomeSwiper() {
    return Container(
      width: double.infinity,
      height: 320.w,
      child: AspectRatio(
        aspectRatio: 375 / 160,
        child: Swiper(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return getSwiperImage(_swiperModels[index]);
          },

          pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              builder: SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                return RectIndicator(
                  position: config.activeIndex,
                  count: _swiperModels.length,
                  activeColor: Color(0x99FFFFFF),
                  color: Color(0xD9FFFFFF),
                  //未选中 指示器颜色，选中的颜色key为Color
                  width: 4,
                  //指示器宽度
                  activeWidth: 14,
                  //选中的指示器宽度
                  radius: 4,
                  //指示器圆角角度
                  height: 4,
                ); //指示器高度
              })),
          scrollDirection: Axis.horizontal,
          // control: new SwiperControl(),
          autoplay: true,
          onTap: (index) {
            Get.to(() =>
                PublicInformationDetailPage(id: _swiperModels[index].newsId!));
          },
          itemCount: _swiperModels.length,
        ),
      ),
    );
  }

  Widget getSwiperImage(SwiperModel swiperModel) {
    return Container(
      child: FadeInImage.assetNetwork(
        placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
        image: API.image(ImgModel.first(swiperModel.voResourcesImgList)),
        fit: BoxFit.fill,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  Widget getFunction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getFunctionBtn(
            '报事报修', R.ASSETS_ICONS_FUNC_BSBX_PNG, () => FixedSubmitPage()),
        getFunctionBtn('设施预约', R.ASSETS_ICONS_FUNC_SSYY_PNG,
            () => FacilityAppointmentPage()),
        getFunctionBtn('生活缴费', R.ASSETS_ICONS_FUNC_SHJF_PNG,
            () => LifePayChoosePage()),
        getFunctionBtn('全部应用', R.ASSETS_ICONS_FUNC_ALL_PNG,
            () => AllApplicationPage()),
      ],
    );
  }

  Widget getFunctionBtn(String title, String path, dynamic page) {
    return MaterialButton(
      shape: StadiumBorder(),
      padding: EdgeInsets.zero,
      onPressed: () {
        if (LoginUtil.isNotLogin) return;
        if (!LoginUtil.haveRoom(title)) return;
        Get.to(page);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            path,
            height: 80.w,
            width: 80.w,
          ),
          8.hb,
          title.text.size(22.sp).color(Color(0xA6000000)).bold.make(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
