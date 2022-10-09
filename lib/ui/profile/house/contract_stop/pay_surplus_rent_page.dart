import 'package:aku_community/widget/bottom_sheets/pay_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:power_logger/power_logger.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/extensions/widget_list_ext.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/bottom_sheets/pay_mothod_bottom_sheet.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/others/bee_input_row.dart';
import 'package:aku_community/widget/others/house_head_card.dart';

class PaySuerplusRentPage extends StatefulWidget {
  ///不再计租时间
  final String time;

  ///剩余需结清房租
  final num amount;

  final int id;
  PaySuerplusRentPage(
      {Key? key, required this.time, required this.amount, required this.id})
      : super(key: key);

  @override
  _PaySuerplusRentPageState createState() => _PaySuerplusRentPageState();
}

class _PaySuerplusRentPageState extends State<PaySuerplusRentPage> {
  String _payMethod = '支付宝';
  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '核对信息',
      bodyColor: Colors.white,
      body: ListView(
        children: [
          HouseHeadCard(context: context),
          Column(
            children: [
              BeeInputRow.button(
                  title: '不再计租时间',
                  hintText:
                      DateUtil.formatDateStr(widget.time, format: 'yyyy-MM-dd'),
                  onPressed: () {}),
              widget.amount <= 0
                  ? BeeInputRow.button(
                      title: '房租余额（请联系物业退款）',
                      hintText: widget.amount.abs().toStringAsFixed(2),
                      onPressed: () {})
                  : BeeInputRow.button(
                      title: '剩余需结清房租（元）',
                      hintText: widget.amount.toStringAsFixed(2),
                      onPressed: () {}),
              BeeInputRow.button(
                  title: '支付方式',
                  hintText: _payMethod,
                  onPressed: () {
                    Get.bottomSheet(PayMethodBottomSheet(onChoose: (value) {
                      _payMethod = value;
                      Get.back();
                      setState(() {});
                    }));
                  })
            ].sepWidget(separate: 24.w.heightBox),
          ).paddingSymmetric(horizontal: 32.w)
        ],
      ),
      bottomNavi: BottomButton(
          onPressed: () async {
            Get.bottomSheet(PayBottomSheet(onChoose: (value) async {
              _payMethod = value;
              Get.back();
              setState(() {});
              Function cancel = BotToast.showLoading();
              try {
                if( _payMethod=='支付宝')
                {
                  if (widget.amount > 0) {
                    String code = await HouseFunc()
                        .leaseRentOrder(widget.id, 1, widget.amount.toDouble());
                    bool result =
                    await PayUtil().callAliPay(code, API.pay.leaseRentCheck);
                    if (result) {
                      Get.back();
                      Get.off(() => PayFinishPage());
                    }
                  } else {
                    bool result = await HouseFunc().leaseRentOrderNegative(
                        widget.id, widget.amount.toDouble());
                    if (result) {
                      Get.back();
                      Get.back();
                      BotToast.showText(text: '退款成功');
                    }
                  }
                }else if(_payMethod=='微信'){
                  if(widget.amount > 0){
                    await HouseFunc()
                        .leaseRentOrderVxPay(widget.id, 2, widget.amount.toDouble()).then((value) {
                      if(value!=null){
                        PayUtil().callWxPay(payModel: value);
                      }
                    });
                  }else{
                    bool result = await HouseFunc().leaseRentOrderNegative(
                        widget.id, widget.amount.toDouble());
                    if (result) {
                      Get.back();
                      Get.back();
                      BotToast.showText(text: '退款成功');
                    }
                  }
                }else{
                  BotToast.showText(text: '请先选择支付方式');
                }

              } catch (e) {
                print(e.toString());
                LoggerData.addData(e);
              }
              cancel();
            }));
          },
          child: '${widget.amount > 0 ? '点击支付' : '点击退款'}'
              .text
              .size(32.sp)
              .color(ktextPrimary)
              .bold
              .make()),
    );
  }
}
