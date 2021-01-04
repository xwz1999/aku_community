import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:akuCommunity/base/assets_image.dart';
import 'package:akuCommunity/widget/container_comment.dart';
import 'package:akuCommunity/widget/app_bar_action.dart';
import 'package:akuCommunity/widget/single_ad_space.dart';
import 'package:akuCommunity/widget/grid_button.dart';
import 'package:akuCommunity/utils/screenutil.dart';
import 'package:akuCommunity/widget/search_bar_delegate.dart';
import 'widget/market_sticky_bar.dart';
import 'widget/market_list.dart';

class MarketPage extends StatefulWidget {
  MarketPage({Key key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  TabController _controller;

  List<Map<String, dynamic>> actionsList = [
    {
      'title': '购物车',
      'icon': AntDesign.shoppingcart,
    },
    {
      'title': '分类',
      'icon': AntDesign.appstore_o,
    }
  ];
  //导航标签
  List<Map<String, dynamic>> treeList = [
    {'name': '社区商城', 'isGroup': false},
    {'name': '社区团购', 'isGroup': true}
  ];

  List<Widget> _listActions() {
    return actionsList
        .map((item) => AppBarAction(
              title: item['title'],
              icon: item['icon'],
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: treeList.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double _appBarHeight = ScreenUtil().setHeight(506);
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xfff9f9f9),
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(24),
            vertical: ScreenUtil().setHeight(12),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(36)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: InkWell(
            onTap: () {
              showSearch(context: context, delegate: searchBarDelegate());
            },
            child: Container(
              child: Row(children: [
                Icon(
                  AntDesign.search1,
                  size: ScreenUtil().setSp(29),
                  color: Color(0xff999999),
                ),
                SizedBox(width: 5),
                Text(
                  '搜索宝贝',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xff999999)),
                )
              ]),
            ),
          ),
        ),
        actions: _listActions(),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 676.w,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        SingleAdSpace(
                          imagePath: 'assets/example/guanggao5.png',
                          radius: 36,
                        ),
                        ContainerComment(
                          radius: 8,
                          customWidget: GridButton(
                            gridList: AssetsImage.shopGridList,
                            count: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MarketStickyBar(
              treeList: treeList,
              controller: _controller,
            )
          ];
        },
        body: TabBarView(
            controller: _controller,
            children: List.generate(
                treeList.length,
                (index) => MarketList(
                      isGroup: treeList[index]['isGroup'],
                    ))),
      ),
    );
  }
}
