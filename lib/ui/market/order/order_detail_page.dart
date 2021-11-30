import 'dart:async';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/good/good_detail_model.dart';
import 'package:aku_community/model/order/create_order_model.dart';
import 'package:aku_community/model/order/logistics_model.dart';
import 'package:aku_community/model/order/order_list_model.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/models/market/shop_car/shop_car_list_model.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/pages/personal/address/address_list_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/ui/market/search/settlementGoodsDTO.dart';
import 'package:aku_community/ui/market/shop_car/shop_car_func.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/line_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:aku_community/widget/buttons/end_button.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'logistics_page.dart';
import 'order_page.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderListModel orderModel;
  final VoidCallback callRefresh;

  OrderDetailPage(
      {Key? key, required this.orderModel, required this.callRefresh})
      : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<SettlementGoodsDTO> _goodsList = [];

  late Timer? timer;
  List<LogisticsModel> logisticsModels = [];

  _checkTime() {
    if (DateTime.parse(widget.orderModel.createDate!)
            .add(Duration(minutes: 5))
            .difference(DateTime.now())
            .inSeconds <=
        0) {
      Get.back();
      BotToast.showText(text: '订单已过期，自动关闭');
      widget.callRefresh();
    } else {}
  }

  Future _pay() async {
    Function cancel = BotToast.showLoading();
    BaseModel baseModel =
        await NetUtil().post(API.pay.jcookOrderCreateOrder, params: {
      "addressId": widget.orderModel.jcookAddressId,
      "settlementGoodsDTOList": _goodsList.map((v) => v.toJson()).toList(),
      "payType": 1, //暂时写死 等待后续补充
      "payPrice": widget.orderModel.payPrice
    });
    if (baseModel.status ?? false) {
      bool result = await PayUtil()
          .callAliPay(baseModel.message!, API.pay.jcookOrderCheckAlipay);
      if (result) {
        Get.off(() => OrderPage(initIndex: 2));
      }else{
        Get.off(() => OrderPage(initIndex: 1));
      }
    }
    cancel();
  }

  Future _deleteOrder() async {
    bool? result = await Get.dialog(
      CupertinoAlertDialog(
        title: Text('提示'),
        content: Text('您确定要删除该订单吗？'),
        actions: [
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: Text('确定'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if (result == true) {
      Function cancel = BotToast.showLoading();
      BaseModel baseModel =
          await NetUtil().get(API.market.deleteOrder, params: {
        "orderId": widget.orderModel.id,
      });
      if (baseModel.status ?? false) {
        BotToast.showText(text: '删除成功');
        Get.back();
        widget.callRefresh();
      }
      cancel();
    }
  }

  Future _cancelOrder() async {
    bool? result = await Get.dialog(
      CupertinoAlertDialog(
        title: Text('提示'),
        content: Text('您确定要取消该订单吗？'),
        actions: [
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: Text('确定'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if (result == true) {
      Function cancel = BotToast.showLoading();
      BaseModel baseModel = await NetUtil().get(API.market.cancelOrder,
          params: {"orderId": widget.orderModel.id, 'cancelReasonCode': 4});
      if (baseModel.status ?? false) {
        BotToast.showText(text: '取消成功');
        Get.back();
        widget.callRefresh();
      }
      cancel();
    }
  }

  Future _confirmOrder() async {
    bool? result = await Get.dialog(
      CupertinoAlertDialog(
        title: Text('提示'),
        content: Text('确认收到货了吗？'),
        actions: [
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: Text('确定'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if (result == true) {
      Function cancel = BotToast.showLoading();
      BaseModel baseModel =
          await NetUtil().get(API.market.confirmOrder, params: {
        "orderId": widget.orderModel.id,
      });
      if (baseModel.status ?? false) {
        BotToast.showText(text: '收货成功');
        Get.back();
        widget.callRefresh();
      }
      cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.orderModel.myOrderListVoList!.forEach((element) {
      _goodsList
          .add(SettlementGoodsDTO(jcookGoodsId: element.jcookGoodsId, num: element.num));
    });
    if (widget.orderModel.tradeStatus == 0) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _checkTime());
    }
  }

  @override
  void dispose() {
    if(timer!=null)
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: widget.orderModel.tradeStatus == 0
          ? '等待买家付款'
          : widget.orderModel.tradeStatus == 2
              ? '等待卖家发货'
              : widget.orderModel.tradeStatus == 1 ||
                      widget.orderModel.tradeStatus == 3
                  ? '订单已关闭'.text.size(32.sp).black.bold.make()
                  : widget.orderModel.tradeStatus == 4
                      ? '等待买家收货'.text.size(32.sp).black.bold.make()
                      : widget.orderModel.tradeStatus == 5
                          ? '交易成功'.text.size(32.sp).black.bold.make()
                          : widget.orderModel.tradeStatus == 9
                              ? '订单已取消'.text.size(32.sp).black.bold.make()
                              : '',
      titleSpacing: 0,
      body: ListView(
        children: [

          widget.orderModel.tradeStatus == 0
              ? _head()
              : widget.orderModel.tradeStatus == 2
                  ? _headDaifahuo(): widget.orderModel.tradeStatus == 4
              ? _headDaishouhuo()
                  : SizedBox(),
          20.hb,
          _address(context),
          20.hb,
          _goodsCard(),
          20.hb,
          _orderView(),
          20.hb,
        ],
      ),
      bottomNavi: Container(
        width: double.infinity,
        height: 120.w,
        color: Colors.white,
        child: _getBtn()
      ),
    );
  }

  _getBtn() {
    return Row(
      children: [
        Spacer(),
        widget.orderModel.tradeStatus == 0 || widget.orderModel.tradeStatus == 2
            ? LineButton(
                onPressed: () async {
                  _cancelOrder();
                },
                width: 168.w,
                text: '取消订单'.text.size(32.sp).color(Color(0xFF666666)).make(),
                color: Color(0xFFBBBBBB),
              )
            : SizedBox(),
        widget.orderModel.tradeStatus == 1 ||
                widget.orderModel.tradeStatus == 3 ||
                widget.orderModel.tradeStatus == 5 ||
                widget.orderModel.tradeStatus == 9
            ? LineButton(
                onPressed: () async {
                  _deleteOrder();
                },
                width: 168.w,
                text: '删除订单'.text.size(32.sp).color(Color(0xFF666666)).make(),
                color: Color(0xFFBBBBBB),
              )
            : SizedBox(),
        widget.orderModel.tradeStatus == 0 || widget.orderModel.tradeStatus == 5
            ? 32.wb
            : SizedBox(),
        widget.orderModel.tradeStatus == 0
            ? LineButton(
                onPressed: () async {
                  _pay();
                },
                width: 168.w,
                text: '付款'.text.size(32.sp).color(Color(0xFFE52E2E)).make(),
                color: Color(0xFFE52E2E),
              )
            : widget.orderModel.tradeStatus == 4
                ? LineButton(
                    onPressed: () async {
                      _confirmOrder();
                    },
                    width: 168.w,
                    text:
                        '确认收货'.text.size(32.sp).color(Color(0xFFE52E2E)).make(),
                    color: Color(0xFFE52E2E),
                  )
                : SizedBox(),
        20.widthBox,
      ],
    );
  }

  _goodsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24.w)),
      ),
      child: Column(
        children: [
          ...widget.orderModel.myOrderListVoList!.map((e) => _goodCard(e)),

          _priceView(),

        ],
      ),
    );
  }
  _priceView() {
    return Column(
        children: [
          Row(
            children: [
              Spacer(),
              '商品金额：'.text.size(28.sp).color(Color(0xFF666666)).make(),
              '¥${((widget.orderModel.payPrice ?? 0) - (widget.orderModel.freightFee ?? 0)).toStringAsFixed(2)}'
                  .text.size(28.sp).color(Color(0xFF333333)).make(),


            ],
          ),
          8.hb,
          Row(
            children: [
              Spacer(),
              '运费：'.text.size(28.sp).color(Color(0xFF666666)).make(),
              '¥${((widget.orderModel.freightFee ?? 0)).toStringAsFixed(2)}'
                  .text
                  .size(28.sp)
                  .color(Color(0xFF666666))
                  .make(),
            ],
          ),
          8.hb,
          Row(
            children: [
              Spacer(),
              '实付款：'.text.size(32.sp).color(Color(0xFF333333)).bold.make(),
              '¥${((widget.orderModel.payPrice ?? 0)).toStringAsFixed(2)}'
                  .text
                  .size(28.sp)
                  .color(Color(0xFFE52E2E))
                  .make(),
            ],
          ),
          16.hb,
        ],

    );
  }

  _address(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w, bottom: 16.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      height: 182.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white),
      alignment: Alignment.center,
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              R.ASSETS_ICONS_ICON_GOOD_LOCATION_PNG,
              width: 60.w,
              height: 60.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, ),
                      child: SizedBox(
                        width: 518.w,
                        child: Text(
                          widget.orderModel.locationName ?? '',
                          style:
                              TextStyle(fontSize: 24.sp, color: ktextPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    5.hb,
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, ),
                      child: SizedBox(
                        width: 518.w,
                        child: Text(
                          (widget.orderModel.addressDetail ?? ''),
                          style:
                              TextStyle(fontSize: 32.sp, color: ktextPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    5.hb,
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(widget.orderModel.receiverName ?? '',
                              style: TextStyle(
                                  fontSize: 24.sp, color: ktextPrimary)),
                          30.wb,
                          Text(widget.orderModel.receiverTel ?? '',
                              style: TextStyle(
                                  fontSize: 24.sp, color: ktextPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Icon(
              CupertinoIcons.chevron_forward,
              size: 40.w,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  _orderView() {
    return Container(
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 20.w, bottom: 20.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      height: 200.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '订单信息'.text.size(32.sp).color(ktextPrimary).bold.make(),
          20.hb,
          Text(
            '订单编号：${widget.orderModel.code}',
            style: TextStyle(fontSize: 28.sp, color: ktextPrimary),
            maxLines: 1,
          ),
          10.hb,
          Text('创建时间：${widget.orderModel.createDate}',
              style: TextStyle(fontSize: 28.sp, color: ktextPrimary),
              maxLines: 1)
        ],
      ),
    );
  }

  _head() {
    return Container(
      padding:
          EdgeInsets.only(left: 20.w, right: 16.w, top: 20.w, bottom: 20.w),
      margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 20.w),
      width: double.infinity,
      height: 150.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          '待付款'.text.size(32.sp).color(ktextPrimary).bold.make(),
          20.hb,
          '${DateTime.parse(widget.orderModel.createDate!).add(Duration(minutes: 5)).toString().substring(0, 19)}后订单自动关闭'
              .text
              .size(28.sp)
              .color(ktextPrimary)
              .make(),
        ],
      ),
    );
  }

  _headDaifahuo() {
    return Container(
      padding:
          EdgeInsets.only(left: 20.w, right: 16.w, top: 20.w, bottom: 20.w),
      margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 20.w),
      width: double.infinity,
      height: 150.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          '买家已付款'.text.size(32.sp).color(ktextPrimary).bold.make(),
          20.hb,
          '等待卖家发货'.text.size(28.sp).color(ktextPrimary).make(),
        ],
      ),
    );
  }

  _headDaishouhuo() {
    return Container(
      padding:
          EdgeInsets.only(left: 22.w, right: 22.w, top: 20.w, bottom: 20.w),
      margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 20.w),
      width: double.infinity,
      height: 150.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(R.ASSETS_ICONS_ICON_LOGISTICS_PNG,width: 56.w,height: 56.w,),
          20.wb,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              '已发货'.text.size(32.sp).color(ktextPrimary).bold.make(),

              '包裹正在等待揽收'.text.size(28.sp).color(ktextPrimary).make(),
            ],
          ),
          Spacer(),
          LineButton(
            onPressed: () async {
              BaseModel baseModel =
                  await NetUtil().get(API.market.findLogistics, params: {
                "orderId": widget.orderModel.id,
              });
              if (baseModel.status == true && baseModel.data != null) {
                logisticsModels =  (baseModel.data as List)
                    .map((e) => LogisticsModel.fromJson(e))
                    .toList();
                if(logisticsModels.isNotEmpty){
                  Get.to(()=> LogisticsPage(models: logisticsModels,goods: widget.orderModel.myOrderListVoList!.first,orderModel:widget.orderModel));
                }else{
                  BotToast.showText(text: '未获取到物流信息');
                }

              }else{
                BotToast.showText(text: '未获取到物流信息');
              }

            },

            text: '查看物流'.text.size(32.sp).color(Color(0xFFE52E2E)).make(),
            color: Color(0xFFE52E2E),
          ),
        ],
      ),
    );
  }

  Widget _goodCard(MyOrderListVoList model) {
    var top = RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: _getKindWd(model.kind ?? 0),
        ),
        TextSpan(
            text: model.skuName,
            style: TextStyle(fontSize: 28.sp, color: ktextPrimary)),
      ]),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    var mid = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w), color: Color(0xFFF2F3F4)),
      child: '规格：${model.weight}kg/${model.unit}'
          .text
          .size(24.sp)
          .color(Color(0xFFBBBBBB))
          .make(),
    );

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 188.w,
                    height: 188.w,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.w),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                      image: model.mainPhoto ?? '',
                      height: 188.w,
                      width: 188.w,
                    ),
                  ),
                ],
              ),
              20.wb,
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: top,
                      width: (model.payPrice ?? 0) > 9999 ? 300.w : 320.w,
                      alignment: Alignment.topCenter,
                    ),

                    10.hb,
                    mid,
                    //Spacer(),

                    10.hb,
                  ],
                ),
              ),
              Spacer(),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    8.hb,
                    '¥'
                        .richText
                        .withTextSpanChildren([
                          (model.payPrice ?? 0)
                              .toStringAsFixed(2)
                              .textSpan
                              .size(28.sp)
                              .color(ktextPrimary)
                              .make(),
                        ])
                        .color(ktextPrimary)
                        .size(28.sp)
                        .make(),
                    'x ${(model.num ?? 0)}'
                        .text
                        .size(24.sp)
                        .color(Color(0xFFBBBBBB))
                        .make(),
                  ],
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget _getKindWd(int kind) {
    switch (kind) {
      case 1:
        return Container(
            // width: 90.w,
            // height: 26.w,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.w),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFEC5329), Color(0xFFF58123)])),
            child: '京东自营'.text.size(18.sp).color(Colors.white).make());
      case 2:
        return Container(
            width: 90.w,
            height: 26.w,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFEC5329), Color(0xFFF58123)])),
            child: '京东POP'.text.size(18.sp).color(Colors.white).make());
      default:
        return SizedBox();
    }
  }
}
