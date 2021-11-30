import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/community/community_topic_model.dart';
import 'package:aku_community/model/community/event_item_model.dart';
import 'package:aku_community/model/community/hot_news_model.dart';
import 'package:aku_community/models/news/news_category_model.dart';
import 'package:aku_community/ui/community/activity/activity_list_page.dart';
import 'package:aku_community/ui/community/community_func.dart';
import 'package:aku_community/ui/community/community_views/topic/topic_detail_page.dart';
import 'package:aku_community/ui/community/community_views/widgets/chat_card.dart';
import 'package:aku_community/ui/home/home_title.dart';
import 'package:aku_community/ui/home/public_infomation/public_infomation_page.dart';
import 'package:aku_community/ui/home/public_infomation/public_information_detail_page.dart';
import 'package:aku_community/ui/market/search/search_goods_page.dart';
import 'package:aku_community/utils/network/base_list_model.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:aku_community/pages/message_center_page/message_center_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/provider/user_provider.dart';
import 'package:aku_community/ui/community/community_views/add_new_event_page.dart';
import 'package:aku_community/ui/community/community_views/my_community_view.dart';
import 'package:aku_community/ui/community/community_views/new_community_view.dart';
import 'package:aku_community/ui/community/community_views/topic/topic_community_view.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/login_util.dart';
import 'dart:math';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/column_action_button.dart';
import 'package:aku_community/widget/tab_bar/bee_tab_bar.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;
  late EasyRefreshController _easyRefreshController;
  List<String> _tabs = [];
  GlobalKey<TopicCommunityViewState> topicKey =
      GlobalKey<TopicCommunityViewState>();
  GlobalKey<MyCommunityViewState> myKey = GlobalKey<MyCommunityViewState>();
  GlobalKey<NewCommunityViewState> newKey = GlobalKey<NewCommunityViewState>();


  List<EventItemModel> _newItems = [];
  List<CommunityTopicModel> _gambitModels = [];
  List<HotNewsModel> _hotNewsModels = [];

  int _pageNum = 1;
  int _size = 4;
  int _pageCount = 0;
  bool _onload = true;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.isLogin) _tabs = ['最新', '话题', '我的'];
    if (userProvider.isNotLogin) _tabs = ['最新', '话题'];
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 10.0,
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              '附近社区',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.sp,
                color: Color(0xff333333),

              ),
              textAlign: TextAlign.center,
            ),

          ]),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding:  EdgeInsets.only(right: 32.w),
              child: GestureDetector(
                onTap: () async {
                  if (LoginUtil.isNotLogin) return;
                  bool? result = await Get.to(() => AddNewEventPage());
                  if (result == true) {
                    switch (_tabController!.index) {
                      case 0:
                        newKey.currentState!.refresh();
                        break;
                      case 1:
                        // topicKey.currentState!.refresh();
                        break;
                      case 2:
                        myKey.currentState!.refresh();
                        break;
                    }
                  }
                },
                child: Image.asset(R.ASSETS_ICONS_ICON_COMMUNITY_PUSH_PNG,
                    height: 40.w, width: 40.w),
              ),
            )
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(90.w), child: _geSearch()),
        ),
      // floatingActionButton:  FloatingActionButton(
      //     onPressed: () async {
      //       if (LoginUtil.isNotLogin) return;
      //       bool? result = await Get.to(() => AddNewEventPage());
      //       if (result == true) {
      //         switch (_tabController!.index) {
      //           case 0:
      //             newKey.currentState!.refresh();
      //             break;
      //           case 1:
      //             topicKey.currentState!.refresh();
      //             break;
      //           case 2:
      //             myKey.currentState!.refresh();
      //             break;
      //         }
      //       }
      //     },
      //     heroTag: 'event_add',
      //     child: Icon(Icons.add),
      //   ),



        body: EasyRefresh(
          firstRefresh: true,
          header: MaterialHeader(),
          controller: _easyRefreshController,
          onRefresh: () async {
            await (getNewInfo());
            _gambitModels = await  CommunityFunc.getListGambit();
            _hotNewsModels = await CommunityFunc.getHotNews();
            _onload = false;
            setState(() {});
          },
          child: _onload
              ? SizedBox()
              : ListView(
            children: [
                  2.hb,
                  _hotNewsModels.isEmpty?SizedBox():_getInfo(),
                  16.hb,
                  _gambitModels.isEmpty?SizedBox():_getNews(),
                  16.hb,
              ..._newItems.map((e) => ChatCard(
              model: e,

            )).toList()],
          ),
        ),

        // ListView(
        //   children: [

        //   ],
        // )


        // TabBarView(
        //   children: userProvider.isLogin
        //       ? [
        //           NewCommunityView(key: newKey),
        //           TopicCommunityView(key: topicKey),
        //           MyCommunityView(key: myKey),
        //         ]
        //       : [
        //           NewCommunityView(key: newKey),
        //           TopicCommunityView(key: topicKey),
        //         ],
        //   controller: _tabController,
        // ),
        // bodyColor: Colors.white,
        );
  }


  Future getNewInfo() async {
    BaseListModel baseListModel =
    await NetUtil().getList(API.community.newEventList, params: {
      "pageNum": _pageNum,
      "size": _size,
    });
    if (baseListModel.tableList!.isNotEmpty) {
      _newItems = (baseListModel.tableList as List)
          .map((e) => EventItemModel.fromJson(e))
          .toList();
    }
    _pageCount = baseListModel.pageCount!;
  }

  Future loadNewInfo() async {
    BaseListModel baseListModel =
    await NetUtil().getList(API.market.hotTop, params: {
      "pageNum": _pageNum,
      "size": _size,
    });
    if (baseListModel.tableList!.isNotEmpty) {
      _newItems.addAll((baseListModel.tableList as List)
          .map((e) => EventItemModel.fromJson(e))
          .toList());
    }
    _pageCount = baseListModel.pageCount!;
  }


  _getInfo() {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(top: 32.w, bottom: 32.w, left: 32.w, right: 32.w),
      child: Column(
        children: [
          _homeTitle('热门资讯', () async {
            final cancel = BotToast.showLoading();
            BaseModel model = await NetUtil().get(API.news.category);
            List<NewsCategoryModel>? category;
            if (model.status == true && model.data != null) {
              category = (model.data as List)
                  .map((e) => NewsCategoryModel.fromJson(e))
                  .toList();
            }
            cancel();
            Get.to(
                    () => PublicInfomationPage(models: category ?? []));
          }, '更多'),
          32.hb,
          Container(
            height: 204.w,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 24.w,
                );
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 396.w,
                  child: Builder(
                    builder: (context) {
                      return _infoCard(_hotNewsModels[index]);
                    },
                  ),
                );
              },
              itemCount: _hotNewsModels.length,
            ),
          ),
        ],
      ),
    );
  }

  _homeTitle(String title, VoidCallback onTap, String suffixTitle) {
    return Row(
      children: [
        title.text.size(32.sp).bold.make(),
        Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              suffixTitle.text.size(24.sp).color(Color(0xFF999999)).make(),
              8.wb,
              Icon(
                CupertinoIcons.chevron_forward,
                size: 24.w,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
        //24.wb,
      ],
    );
  }


   _next(int min, int max) {
     var rng = new Random();
//将 参数min + 取随机数（最大值范围：参数max -  参数min）的结果 赋值给变量 result;
    var result = min + rng.nextInt(max - min);
//返回变量 result 的值;
    return result;
  }

  _infoCard(HotNewsModel item) {

    return GestureDetector(
      onTap: () async{
        var result = await Get.to(() => PublicInformationDetailPage(id: item.id!));

        CommunityFunc.addViews(item.id!);
        if(result){
          _easyRefreshController.callRefresh();
        }

      },
      child: Stack(
        children: [
          Container(
            width: 396.w,
            height: 204.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(12),
                left: Radius.circular(16),
              ),
              image: DecorationImage(
                image: NetworkImage(
                    API.image(ImgModel.first(item.imgList)),
                ),
                fit: BoxFit.cover,
              ),
              //color: Colors.black38,
            ),


          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              width: 396.w,
              height: 204.w,
              padding:
              EdgeInsets.only(top: 32.w, left: 40.w, right: 40.w, bottom: 32.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(12),
                  left: Radius.circular(16),
                ), //color: Colors.black38,
              ),
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 316.w,
                      alignment: Alignment.center,
                      child: Text(
                        item.title??'',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold),
                      )
                  ),
                  24.hb,
                  Row(
                    children: [
                      Text(
                        '${item.views??0}浏览',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 24.sp,
                        ),
                      ),
                      Spacer(),
                      Text(
                        item.createDate?.substring(0,10)??'',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 24.sp,
                        ),
                      )
                    ],
                  )
                ],



              ),
            ),
          ),
        ],
      ),
    );
  }

  _getNews() {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(top: 32.w, bottom: 32.w,),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 32.w,right: 32.w),
            child: _homeTitle('新鲜话题', () {
              Get.to(() => TopicCommunityView());
            }, '全部'),
          ),
          32.hb,
          _searchHistoryWidget()
        ],
      ),
    );
  }

  _geSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      padding: EdgeInsets.only(bottom: 20.w),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        height: 74.w,
        shape: StadiumBorder(),
        elevation: 0,
        minWidth: double.infinity,
        color: Color(0xFFF3F3F3),
        onPressed: () {
          //Get.to(() => SearchGoodsPage());
        },
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 32.w,
              color: Color(0xFF666666),
            ),
            10.wb,
            '请输入关键字'.text.size(28.sp).color(ktextSubColor).make().expand(),
          ],
        ),
      ),
    );
  }

  _searchHistoryWidget() {

    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            //width: MediaQuery.of(context).size.width,
            //padding: EdgeInsets.only(left: 10, right: 10),
            child: Wrap(
              children: [..._gambitModels.map((e) => _choiceChip(e,0)).toList()]
              // [_choiceChip('EDG夺冠',1),_choiceChip('双十一',2),
              //   _choiceChip('11月吃土',2),_choiceChip('成都疫情',0),_choiceChip('万圣节',0)],
            ),
          ),
          // Spacer()
        ],
      ),
    );
  }

  _choiceChip(CommunityTopicModel item, int type) {
    return  Padding(
      padding:  EdgeInsets.only(right: 12.w,bottom: 24.w),
      child: ChoiceChip(
          backgroundColor: Color(0xFFF4F7FC),
          // disabledColor: Colors.blue,
          labelStyle: TextStyle(fontSize: 15 * 2.sp, color: Colors.black),

          labelPadding: EdgeInsets.only(right: 12.w,left: 12.w),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onSelected: (bool value) {
            Get.to(() => TopicDetailPage(model: item));
          },
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#  ${item.summary??''}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.65),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500),
              ),
              type==1||type==2? 8.wb:SizedBox(),
              type==1||type==2?_chipType(type):SizedBox()
            ],
          ),
          selected: false,
        ),
    );

  }

  _chipType(int type) {
    return Container(
      width: 32.w,
      height: 32.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6.4.w),
        ),
        color:type == 1? Color(0xFFFFD76F):Color(0xFFFF8383),
      ),
      child: Text(
        type == 1 ? '荐' : '热',
        style: TextStyle(
            color: type == 1
                ? Colors.black.withOpacity(0.65)
                : Colors.white.withOpacity(0.85),
            fontSize: 20.sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
