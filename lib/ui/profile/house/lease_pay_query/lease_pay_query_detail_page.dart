import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:get/get.dart';
import 'package:power_logger/power_logger.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/house/lease_fee_list_model.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_divider.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/others/user_tool.dart';

class LeasePayQueryDetailPage extends StatefulWidget {
  final LeaseFeeListModel model;
  LeasePayQueryDetailPage({Key? key, required this.model}) : super(key: key);

  @override
  _LeasePayQueryDetailPageState createState() =>
      _LeasePayQueryDetailPageState();
}

class _LeasePayQueryDetailPageState extends State<LeasePayQueryDetailPage> {
  String _payMethod = '支付宝';
  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '缴费详情',
      bodyColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            72.w.heightBox,
            widget.model.price.text.size(48.sp).bold.black.make(),
            16.w.heightBox,
            widget.model.payStatusString.text
                .size(32.sp)
                .color(widget.model.payStatus == 0 ? Colors.red : Colors.black)
                .bold
                .make(),
            80.w.heightBox,
            _buildInfo(),
            Offstage(
              offstage: widget.model.payStatus == 0,
              child: _buildFinishInfo(),
            )
          ],
        ),
      ),
      bottomNavi: Offstage(
        offstage: widget.model.payStatus != 0,
        child: BottomButton(
            onPressed: () async {
              Function cancel = BotToast.showLoading();

              try {
                if( _payMethod=='支付宝')
                {
                  String code = await HouseFunc().leaseRentBillOrder(
                      UserTool.appProveider.selectedHouse!.sysLeaseId!,
                      1, //写死为支付宝
                      widget.model.price.toDouble()
                  );
                  bool result = false;
                  result = await PayUtil()
                      .callAliPay(code, API.pay.leaseRentBillOrderCheck);
                  if (result) {
                    Get.off(() => PayFinishPage());
                  }

                }else if(_payMethod=='微信'){
                  await HouseFunc()
                      .leaseRentBillOrderVxPay(   UserTool.appProveider.selectedHouse!.sysLeaseId!,
                      2, //写死为支付宝
                      widget.model.price.toDouble()).then((value) {
                    if(value!=null){
                      PayUtil().callWxPay(payModel: value);
                    }
                  });
                }else{
                  BotToast.showText(text: '请先选择支付方式');
                }

              } catch (e) {
                print(e.toString());
                LoggerData.addData(e);
              }
              cancel();

            },
            child: '立即支付'.text.size(32.sp).bold.black.make()),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Row(
            children: [
              '付款方式'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              //暂时写死为支付宝
              '支付宝'.text.size(28.sp).black.make()
            ],
          ),
          Row(
            children: [
              '月份'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              '${widget.model.createDateTime.month.toString()}月'
                  .text
                  .size(28.sp)
                  .black
                  .make()
            ],
          ),
          Row(
            children: [
              '类型'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              widget.model.typeString.text.size(28.sp).black.make()
            ],
          ),
          Row(
            children: [
              '截止时间'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              DateUtil.formatDate(
                      DateTime(
                        widget.model.createDateTime.year,
                        widget.model.createDateTime.month + 1,
                        0,
                      ),
                      format: 'yyyy-MM-dd')
                  .toString()
                  .text
                  .size(28.sp)
                  .black
                  .make()
            ],
          ),
          Row(
            children: [
              '对应房屋'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              '${S.of(context)!.tempPlotName}·${UserTool.appProveider.selectedHouse!.roomName}'
                  .text
                  .size(28.sp)
                  .black
                  .make()
            ],
          ),
        ].sepWidget(separate: 32.w.heightBox),
      ),
    );
  }

  Widget _buildFinishInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          32.w.heightBox,
          BeeDivider.horizontal(),
          32.w.heightBox,
          Row(
            children: [
              '缴费人'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              '${UserTool.userProvider.userInfoModel!.name}'
                  .text
                  .size(28.sp)
                  .black
                  .make()
            ],
          ),
          32.w.heightBox,
          Row(
            children: [
              '缴纳时间'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              '${DateUtil.formatDate(widget.model.createDateTime)}'
                  .text
                  .size(28.sp)
                  .black
                  .make()
            ],
          ),
        ],
      ),
    );
  }
}
