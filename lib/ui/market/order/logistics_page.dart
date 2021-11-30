import 'dart:ui';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/model/order/logistics_model.dart';
import 'package:aku_community/model/order/order_list_model.dart';
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

class LogisticsPage extends StatefulWidget {
  final List<LogisticsModel> models;
  final OrderListModel orderModel;
  final MyOrderListVoList goods;
  LogisticsPage({Key? key, required this.models, required this.goods, required this.orderModel}) : super(key: key);

  @override
  _LogisticsPageState createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage> {
  List<OperatorNodeList> operatorNodeList = [];

  @override
  void initState() {
    super.initState();
    operatorNodeList.addAll(widget.models[0].operatorNodeList!);
    operatorNodeList.addAll(widget.models[0].operatorNodeList!);
    operatorNodeList.addAll(widget.models[0].operatorNodeList!);
  }

  @override
  Widget build(BuildContext context) {

    return  BeeScaffold(
      title: '物流详情',
      body:ListView(
        children: [
          Column(
            children: [
              Container(
                padding:
                EdgeInsets.only(left: 22.w, right: 22.w, top: 20.w, bottom: 20.w),
                margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 20.w),
                width: double.infinity,
                height: 180.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24.w)),
                    color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 126.w,
                      height: 126.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.w),
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                        image: widget.goods.mainPhoto ?? '',
                        height: 126.w,
                        width: 126.w,
                      ),
                    ),
                    10.wb,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        '已发货'.text.size(32.sp).color(ktextPrimary).bold.make(),
                        Container(
                          width: 520.w,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: widget.goods.skuName,
                                  style: TextStyle(fontSize: 28.sp, color: ktextPrimary)),
                            ]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        '包裹离目的地越来越近了'.text.size(28.sp).color(ktextPrimary).make(),
                      ],
                    ),

                  ],
                ),
              ),

              ...widget.models.map((e) => _logisticsView(
                    e
                ),

              )

            ],
          )
        ],
      ),




    );




  }

  _logisticsView(LogisticsModel model ){
    return
        Container(
          padding:
          EdgeInsets.only(left: 22.w, right: 22.w,  bottom: 20.w,top: 20.w),
          margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 20.w),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24.w)),
              color: Colors.white),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    75.wb,
                    (model.logisticsName??'未获取到快递公司').text.size(28.sp).color(ktextPrimary).make(),
                      50.wb,
                    (model.waybillCode??'未获取到快递单号').text.size(28.sp).color(ktextPrimary).make(),
                  ],
                ),
              ),
              20.hb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text('收',style: TextStyle(color: Color(0xFFBBBBBB),fontSize: 28.sp),),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2.w, color:Color(0xFFBBBBBB)),
                      borderRadius: BorderRadius.all(Radius.circular(28.w))
                    ),
                    width: 56.w,
                    height: 56.w,
                    alignment: Alignment.center,
                  ),
                  20.wb,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 580.w,
                          child: Text(
                            widget.orderModel.locationName ?? '',
                            style:
                            TextStyle(fontSize: 28.sp, color: ktextPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      5.hb,
                      SizedBox(
                          width: 580.w,
                          child: Text(
                            (widget.orderModel.addressDetail ?? ''),
                            style:
                            TextStyle(fontSize: 28.sp, color: ktextPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      5.hb,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(widget.orderModel.receiverName ?? '',
                                style: TextStyle(
                                    fontSize: 28.sp, color: ktextPrimary)),
                            30.wb,
                            Text(widget.orderModel.receiverTel ?? '',
                                style: TextStyle(
                                    fontSize: 28.sp, color: ktextPrimary)),
                          ],
                        ),

                    ],
                  ),
                ],
              ),
              30.hb,
              if(model.operatorNodeList!=null)
              ...model.operatorNodeList!.map((e) =>

              Container(
                color: Colors.white,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 30.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Image.asset(R.ASSETS_ICONS_ICON_MARKET_SUCCESS_PNG,width: 50.w,height: 50.w,),
                    20.wb,
                    Container(
                      width: 500.w,
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: DateTime.fromMillisecondsSinceEpoch(int.parse(e.msgTime.toString()+'000')).toString().substring(0,19),
                              style: TextStyle(fontSize: 28.sp, color: ktextPrimary)),
                          WidgetSpan(
                            child: SizedBox(width: 20.w,),
                          ),
                          TextSpan(
                              text: e.content,
                              style: TextStyle(fontSize: 28.sp, color: ktextPrimary)),
                        ]),
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              )


              ),

            ],
          )
        );


  }


}
