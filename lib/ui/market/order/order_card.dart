import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/order/order_list_model.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/ui/market/search/settlementGoodsDTO.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/buttons/line_button.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/utils/headers.dart';

import 'package:flutter/cupertino.dart';

import 'order_detail_page.dart';

class OrderCard extends StatefulWidget {
  final OrderListModel model;
  final VoidCallback callRefresh;

  OrderCard({
    Key? key,
    required this.model,
    required this.callRefresh,
  }) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  List<SettlementGoodsDTO> _goodsList = [];
  @override
  Widget build(BuildContext context) {
    switch (widget.model.tradeStatus) {
      case 0:
        return _daifukuan();
      case 1:
        return _yiguanbi();
      case 2:
        return _daifahuo();
      case 3:
        return _yiguanbi();
      case 4:
        return _daishouhuo();
      case 5:
        return _yiwancheng();
      case 9:
        return _yiquxiao();
      default:
        return SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.model.myOrderListVoList!.forEach((element) {
      _goodsList.add(SettlementGoodsDTO(jcookGoodsId: element.jcookGoodsId,num: element.num));
    });

  }

  Future _pay() async {
    Function cancel = BotToast.showLoading();
    BaseModel baseModel = await NetUtil()
        .post(API.pay.jcookOrderCreateOrder, params: {
      "addressId":widget.model.jcookAddressId,
      "settlementGoodsDTOList": _goodsList.map((v) => v.toJson()).toList(),
      "payType": 1, //???????????? ??????????????????
      "payPrice":  widget.model.payPrice
    });
    if (baseModel.status ?? false) {
      bool result = await PayUtil().callAliPay(
          baseModel.message!, API.pay.sharePayOrderCodeCheck);
      if (result) {
        Get.off(() => PayFinishPage());
      }
    }
    cancel();
  }



  Future _deleteOrder() async {
    bool? result = await Get.dialog(
      CupertinoAlertDialog(
        title: Text('??????'),
        content: Text('?????????????????????????????????'),
        actions: [
          CupertinoDialogAction(
            child: Text('??????'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: Text('??????'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if(result==true){

      Function cancel = BotToast.showLoading();
      BaseModel baseModel = await NetUtil()
          .get(API.market.deleteOrder, params: {
        "orderId":widget.model.id,
      });
      if (baseModel.status ?? false) {
        BotToast.showText(text: '????????????');
        widget.callRefresh();
      }
      cancel();
    }
  }

  Future _cancelOrder() async {
    bool? result = await Get.dialog(
      CupertinoAlertDialog(
        title: Text('??????'),
        content: Text('?????????????????????????????????'),
        actions: [
          CupertinoDialogAction(
            child: Text('??????'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: Text('??????'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if(result==true){

      Function cancel = BotToast.showLoading();
      BaseModel baseModel = await NetUtil()
          .get(API.market.cancelOrder, params: {
        "orderId":widget.model.id,
        'cancelReasonCode':4
      });
      if (baseModel.status ?? false) {
        BotToast.showText(text: '????????????');
        widget.callRefresh();
      }
      cancel();
    }
  }

  Future _confirmOrder() async {
    bool? result = await Get.dialog(
      CupertinoAlertDialog(
        title: Text('??????'),
        content: Text('????????????????????????'),
        actions: [
          CupertinoDialogAction(
            child: Text('??????'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: Text('??????'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if (result == true) {
      Function cancel = BotToast.showLoading();
      BaseModel baseModel = await NetUtil().get(API.market.confirmOrder,
          params: {"orderId": widget.model.id,});
      if (baseModel.status ?? false) {
        BotToast.showText(text: '????????????');
        Get.back();
        widget.callRefresh();
      }
      cancel();
    }
  }

  _yiquxiao() {
    return GestureDetector(
      onTap: (){
        Get.to(()=>OrderDetailPage(orderModel: widget.model,callRefresh: widget.callRefresh,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                '????????????'.text.size(32.sp).color(ktextPrimary).bold.make(),
                Spacer(),
                '???????????????'.text.size(24.sp).color(ktextSubColor).make(),
              ],
            ),
            16.hb,
            Container(
              width: double.infinity,
              height: 1.w,
              color: Color(0xFFD9D9D9),
            ),
            16.hb,
            ...widget.model.myOrderListVoList!.map((e) => _goodCard(e)),
            20.hb,
            _priceView(),
            20.hb,
            Row(
              children: [
                Spacer(),
                LineButton(
                  onPressed: ()async {

                    _deleteOrder();


                  },
                  text: ('????????????').text.size(28.sp).color(Color(0xFF666666)).make(),
                  color: Color(0xFFBBBBBB),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _yiwancheng() {
    return GestureDetector(
      onTap: (){
        Get.to(()=>OrderDetailPage(orderModel: widget.model,callRefresh: widget.callRefresh,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                '????????????'.text.size(32.sp).color(ktextPrimary).bold.make(),
                Spacer(),
                '???????????????'.text.size(24.sp).color(ktextSubColor).make(),
              ],
            ),
            16.hb,
            Container(
              width: double.infinity,
              height: 1.w,
              color: Color(0xFFD9D9D9),
            ),
            16.hb,
            ...widget.model.myOrderListVoList!.map((e) => _goodCard(e)),
            20.hb,
            _priceView(),
            20.hb,
            Row(
              children: [
                Spacer(),
                // LineButton(
                //   onPressed: () {
                //
                //   },
                //   text:
                //       ('??????/??????').text.size(28.sp).color(Color(0xFFBBBBBB)).make(),
                //   color: Color(0xFFBBBBBB),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _daishouhuo() {
    return GestureDetector(
      onTap: (){
        Get.to(()=>OrderDetailPage(orderModel: widget.model,callRefresh: widget.callRefresh,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                '????????????'.text.size(32.sp).color(ktextPrimary).bold.make(),
                Spacer(),
                '???????????????'.text.size(24.sp).color(ktextSubColor).make(),
              ],
            ),
            16.hb,
            Container(
              width: double.infinity,
              height: 1.w,
              color: Color(0xFFD9D9D9),
            ),
            16.hb,
            ...widget.model.myOrderListVoList!.map((e) => _goodCard(e)),
            20.hb,
            _priceView(),
            20.hb,
            Row(
              children: [
                Spacer(),
                // LineButton(
                //   onPressed: () {},
                //   text: ('????????????').text.size(28.sp).color(Color(0xFFBBBBBB)).make(),
                //   color: Color(0xFFBBBBBB),
                // ),
                // 32.wb,
                LineButton(
                  onPressed: () {
                    _confirmOrder();
                  },
                  text: ('????????????').text.size(28.sp).color(Color(0xFFE52E2E)).make(),
                  color: Color(0xFFE52E2E),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _daifahuo() {
    return GestureDetector(
      onTap: (){
        Get.to(()=>OrderDetailPage(orderModel: widget.model,callRefresh: widget.callRefresh,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                '????????????'.text.size(32.sp).color(ktextPrimary).bold.make(),
                Spacer(),
                '???????????????'.text.size(24.sp).color(ktextSubColor).make(),
              ],
            ),
            16.hb,
            Container(
              width: double.infinity,
              height: 1.w,
              color: Color(0xFFD9D9D9),
            ),
            16.hb,
            ...widget.model.myOrderListVoList!.map((e) => _goodCard(e)),
            20.hb,
            _priceView(),
            20.hb,
            Row(
              children: [
                Spacer(),
                LineButton(
                  onPressed: () {
                    _cancelOrder();
                  },
                  text: ('????????????').text.size(28.sp).color(Color(0xFF666666)).make(),
                  color: Color(0xFFBBBBBB),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _yiguanbi() {
    return GestureDetector(
      onTap: (){
        Get.to(()=>OrderDetailPage(orderModel: widget.model,callRefresh: widget.callRefresh,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                '????????????'.text.size(32.sp).color(ktextPrimary).bold.make(),
                Spacer(),
                '???????????????'.text.size(24.sp).color(ktextSubColor).make(),
              ],
            ),
            16.hb,
            Container(
              width: double.infinity,
              height: 1.w,
              color: Color(0xFFD9D9D9),
            ),
            16.hb,
            ...widget.model.myOrderListVoList!.map((e) => _goodCard(e)),
            20.hb,
            _priceView(),
            20.hb,
            Row(
              children: [
                Spacer(),
                LineButton(
                  onPressed: () {
                    _deleteOrder();
                  },
                  text: ('????????????').text.size(28.sp).color(Color(0xFF666666)).make(),
                  color: Color(0xFFBBBBBB),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _daifukuan() {
    return GestureDetector(
      onTap: (){
        Get.to(()=>OrderDetailPage(orderModel: widget.model,callRefresh: widget.callRefresh,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                '????????????'.text.size(32.sp).color(ktextPrimary).bold.make(),
                Spacer(),
                '???????????????'.text.size(24.sp).color(ktextSubColor).make(),
              ],
            ),
            16.hb,
            Container(
              width: double.infinity,
              height: 1.w,
              color: Color(0xFFD9D9D9),
            ),
            16.hb,
            ...widget.model.myOrderListVoList!.map((e) => _goodCard(e)),
            20.hb,
            _priceView(),
            20.hb,
            Row(
              children: [
                Spacer(),
                LineButton(
                  onPressed: () {
                    _cancelOrder();
                  },
                  text: ('????????????').text.size(28.sp).color(Color(0xFF666666)).make(),
                  color: Color(0xFFBBBBBB),
                  width: 168.w,
                ),
                32.wb,
                LineButton(
                  onPressed: () async {
                    _pay();
                  },
                  text: ('??????').text.size(28.sp).color(Color(0xFFE52E2E)).make(),
                  color: Color(0xFFE52E2E),
                  width: 168.w,
                ),
              ],
            )
          ],
        ),
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
      child: '?????????${model.weight}kg/${model.unit}'
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
                    '??'
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
            child: '????????????'.text.size(18.sp).color(Colors.white).make());
      case 2:
        return Container(
            width: 90.w,
            height: 26.w,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFEC5329), Color(0xFFF58123)])),
            child: '??????POP'.text.size(18.sp).color(Colors.white).make());
      default:
        return SizedBox();
    }
  }

  _priceView() {
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            '???????????????'.text.size(28.sp).color(Color(0xFF666666)).make(),
            '??${((widget.model.payPrice ?? 0) - (widget.model.freightFee ?? 0)).toStringAsFixed(2)}'
                .text
                .size(28.sp)
                .color(Color(0xFF666666))
                .make(),
          ],
        ),
        Row(
          children: [
            Spacer(),
            '?????????'.text.size(28.sp).color(Color(0xFF666666)).make(),
            '??${((widget.model.freightFee ?? 0)).toStringAsFixed(2)}'
                .text
                .size(28.sp)
                .color(Color(0xFF666666))
                .make(),
          ],
        ),
        Row(
          children: [
            Spacer(),
            '????????????'.text.size(32.sp).color(Color(0xFF333333)).make(),
            '??${((widget.model.payPrice ?? 0)).toStringAsFixed(2)}'
                .text
                .size(28.sp)
                .color(Color(0xFFE52E2E))
                .make(),
          ],
        ),
      ],
    );
  }
}
