import 'dart:ui';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/models/market/order/goods_home_model.dart';
import 'package:aku_community/pages/tab_navigator.dart';
import 'package:aku_community/utils/network/base_list_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/end_button.dart';
import 'package:aku_community/widget/buttons/line_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/community/community_topic_model.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/ui/community/community_views/topic/topic_detail_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../market_home_goods_card.dart';

class MarketSuccessPage extends StatefulWidget {
  final int index;
  MarketSuccessPage({Key? key, required this.index}) : super(key: key);

  @override
  _MarketSuccessPageState createState() => _MarketSuccessPageState();
}

class _MarketSuccessPageState extends State<MarketSuccessPage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _refreshController = EasyRefreshController();
  bool _onload = true;
  List<GoodsHomeModel> _goodsHomeModelList = [];
  int _pageNum = 1;
  int _pageCount = 0;
  int _size = 10;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  BeeScaffold(
      title: '返回',
      body:Column(
        children: [

          EasyRefresh(
            firstRefresh: true,
            header: MaterialHeader(),
            controller: _refreshController,
            onRefresh: () async {
              await updateMarketInfo();
              _onload =false;
              setState(() {});
            },
            child: _onload
                ? SizedBox()
                : ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                Container(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [

                          Text(
                            _getTitle(widget.index),
                            style:TextStyle(fontSize: 32.sp,color: ktextPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),


                        ],
                      ),
                      50.hb,

                      Row(
                        children: [
                          LineButton(
                            onPressed: () async {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                  TabNavigator(index: 1,)), (Route<dynamic> route) => false);
                            },
                            width: 168.w,
                            text: '返回首页'.text.size(32.sp).color(Color(0xFFE52E2E)).make(),
                            color: Color(0xFFE52E2E),
                          ),
                          32.wb,
                          EndButton(
                              onPressed:  () async {

                              },
                              text: '查看详情'
                                  .text
                                  .size(32.sp)
                                  .color(Colors.white)
                                  .make()),
                        ],
                      )
                    ],
                  ) ,
                ),
                _buildSliverGrid(),
              ],
            ),
          ),
        ],
      ),

    );




  }

   _buildSliverGrid() {
    return  WaterfallFlow.builder(
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.w,
          crossAxisSpacing: 20.w,
        ),
        padding: EdgeInsets.all(32.w),
        itemBuilder: (context, index) {
          return MarketHomeGoodsCard(item: _goodsHomeModelList[index]);
        },
        itemCount: _goodsHomeModelList.length,

      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      //   mainAxisSpacing: 20.w,
      //   crossAxisSpacing: 20.w,
      //   childAspectRatio: 0.57,
      // ),

      // ///子Item构建器
      // delegate: new SliverChildBuilderDelegate(
      //       (BuildContext context, int index) {
      //     ///每一个子Item的样式
      //     return MarketHomeGoodsCard(item: _goodsHomeModelList[index]);
      //     // return Container(
      //     //   width: 200.w,
      //     //     height: 200.w,
      //     //   color: Colors.blue,
      //     // );
      //   },
      //
      //   ///子Item的个数
      //   childCount: _goodsHomeModelList.length,

    );
  }

  Future updateMarketInfo() async {
    _pageNum =1;
    BaseListModel baseListModel = await NetUtil().getList(
      API.market.findRecommendGoodsList,
      params: {
        'pageNum': _pageNum,
        'size': _size,
        'orderBySalesVolume': null,
        'orderByPrice': null,
      },
    );
    if (baseListModel.tableList!.isNotEmpty) {
      _goodsHomeModelList = (baseListModel.tableList as List)
          .map((e) => GoodsHomeModel.fromJson(e))
          .toList();
    }
    _pageCount = baseListModel.pageCount!;
  }

  Future loadMarketInfo() async {
    BaseListModel baseListModel = await NetUtil().getList(
      API.market.findRecommendGoodsList,
      params: {
        'pageNum': _pageNum,
        'size': _size,
        'orderBySalesVolume': null,
        'orderByPrice': null,
      },
    );
    if (baseListModel.tableList!.isNotEmpty) {
      _goodsHomeModelList.addAll((baseListModel.tableList as List)
          .map((e) => GoodsHomeModel.fromJson(e))
          .toList());
    }
    _pageCount = baseListModel.pageCount!;
  }

  _getTitle(int index){
    switch(index){
      case 1:
        return '支付成功';
      case 2:
        return '取消成功';
      case 3:
        return '收货成功';
      case 4:
        return '删除成功';
      default:
        return '';
    }
  }
  @override
  bool get wantKeepAlive => true;
}
