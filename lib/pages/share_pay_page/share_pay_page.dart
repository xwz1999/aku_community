import 'dart:convert';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/extensions/widget_list_ext.dart';
import 'package:aku_community/models/life_pay/share_pay_list_model.dart';
import 'package:aku_community/pages/life_pay/life_pay_page.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/pages/share_pay_page/share_pay_detail_page.dart';
import 'package:aku_community/pages/share_pay_page/share_record_page.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_divider.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/bee_check_radio.dart';
import 'package:aku_community/widget/others/house_head_card.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SharePayPage extends StatefulWidget {
  const SharePayPage({Key? key}) : super(key: key);

  @override
  _SharePayPageState createState() => _SharePayPageState();
}

class _SharePayPageState extends State<SharePayPage> {
  EasyRefreshController? _controller;
  List<SharePayListModel> _models = []; //原model,禁止修改
  double _prePrice = 0;
  List<int> _selectYears = []; //选择的年份，存储其数组下标
  List<SharePayListModel> _selectModels = []; //选中的models

  bool get allSelect =>
      ((_models.length == _selectYears.length) && (_models.length != 0));

  SelectPay get total {
    int count = 0;
    double price = 0;
    List<int> ids = [];
    for (var i in _selectYears) {
      SelectPay _select = selectCount(_selectModels[i]);
      count += _select.payCount;
      price += _select.payTotal;
      ids.addAll(_select.ids);
    }
    return SelectPay(payCount: count, payTotal: price, ids: ids);
  }

  SelectPay selectCount(SharePayListModel model) {
    int count = 0;
    double price = 0;
    List<int> ids = [];
    model.appMeterShareDetailsVos.forEach((element) {
      count++;
      price += element.remainingUnpaidAmount;
      ids.add(element.id);
    });
    return SelectPay(payCount: count, payTotal: price, ids: ids);
  }

  Map<int, String> getType = {
    1: '水费',
    2: '电费',
  };

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    BotToast.closeAllLoading();
    super.dispose();
  }

  Widget _buildCard(SharePayListModel model, int index) {
    SelectPay _select = selectCount(_selectModels[index]);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: kForeGroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectYears.contains(index)) {
                      _selectYears.remove(index);
                    } else {
                      _selectYears.add(index);
                    }
                  });
                },
                child: BeeCheckRadio(
                  value: index,
                  groupValue: _selectYears,
                ),
              ),
            ],
          ),
          24.w.widthBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              '公摊${getType[model.type]}(${model.months})'
                  .text
                  .color(ktextSubColor)
                  .size(28.sp)
                  .make(),
              24.w.heightBox,
              '待缴：${model.num}项  已选${_select.payCount}项'
                  .text
                  .color(ktextPrimary)
                  .size(28.sp)
                  .make(),
              24.w.heightBox,
              RichText(
                  text: TextSpan(
                      text: '合计：',
                      style: TextStyle(
                          color: ktextPrimary,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text: '¥ ${_select.payTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: kDangerColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold)),
                  ]))
            ],
          ).expand(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  if (_selectYears.contains(index)) {}
                  dynamic payMent = await (Get.to(() => SharePayDetailPage(
                        model: _models[index],
                        selectModel: _selectModels[index],
                        months: model.months,
                      )));
                  if (payMent.runtimeType == SharePayListModel) {
                    _selectModels[index] = payMent;
                  }
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(22.w),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                  child: '选择明细'.text.color(Colors.white).size(22.sp).make(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _payButton() {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(37.w)),
      color: kPrimaryColor,
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.w),
      onPressed: () async {
        Function cancel = BotToast.showLoading();
        BaseModel baseModel =
            await NetUtil().post(API.pay.sharePayOrderCode, params: {
          "ids": total.ids,
          "payType": 1, //暂时写死 等待后续补充
          "payPrice": total.payTotal.toDoubleStringAsFixed()
      });
        if (baseModel.status ?? false) {
          bool result = await PayUtil()
              .callAliPay(baseModel.message!, API.pay.sharePayOrderCodeCheck);
          if (result) {
            Get.off(() => PayFinishPage());
          }
        }
        cancel();
      },
      child: '去缴费'.text.black.size(32.sp).bold.make(),
    );
  }

  Widget _buildPrePayment() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 32.w),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '当前预缴'.text.size(28.sp).color(ktextSubColor).make(),
          30.w.heightBox,
          Row(
            children: [
              '¥'.text.size(28.sp).black.make(),
              16.w.widthBox,
              _prePrice.text.size(40.sp).black.bold.make(),
              Spacer(),
              MaterialButton(
                elevation: 0,
                height: 50.w,
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 25.w),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.w),
                    side: BorderSide(color: Color(0xFF979797), width: 1.w)),
                color: Colors.white,
                onPressed: () {
                  // Get.to(() => LifePrePayPage(
                  //       prePay: _prePrice,
                  //     ));
                },
                child: '预缴充值'.text.size(28.sp).black.make(),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Future<double> _dailyPaymentPrePay() async {
  //   BaseModel baseModel =
  //       await NetUtil().get(API.manager.dailyPaymentPrePay, params: {
  //     "estateId": UserTool.appProveider.selectedHouse!.estateId,
  //   });
  //   if (baseModel.status ?? false) {
  //     return (baseModel.data as num).toDouble();
  //   } else {
  //     return 0;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '公摊缴费',
      actions: [
        InkWell(
          onTap: () {
            Get.to(() => ShareRecordPage());
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(32.w, 28.w, 32.w, 20.w),
            alignment: Alignment.center,
            child: '缴费记录'.text.black.size(28.sp).make(),
          ),
        ),
      ],
      body: EasyRefresh(
        firstRefresh: true,
        header: MaterialHeader(),
        controller: _controller,
        onRefresh: () async {
          BaseModel baseModel =
              await NetUtil().get(API.manager.sharePayList, params: {
            'estateId': UserTool.appProveider.selectedHouse?.estateId,
          });
          _models = (baseModel.data as List)
              .map((e) => SharePayListModel.fromJson(e))
              .toList();
          // _selectPay.clear();
          _selectYears.clear();
          _selectModels = _models
              .map((e) => SharePayListModel.fromJson(jsonDecode(jsonEncode(e))))
              .toList();

          for (var i = 0; i < _selectModels.length; i++) {
            _selectYears.add(i);
          }
          // _prePrice = await _dailyPaymentPrePay();
          if (mounted) setState(() {});
        },
        child: Column(
          children: [
            HouseHeadCard(
                onChanged: () {
                  _controller!.callRefresh();
                },
                context: context),
            16.w.heightBox,
            //隐藏预缴
            // _buildPrePayment(),
            // 16.w.heightBox,
            Container(
              padding: EdgeInsets.all(32.w),
              width: double.infinity,
              color: kForeGroundColor,
              constraints: BoxConstraints(minHeight: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '缴费账单'.text.color(ktextPrimary).size(28.sp).make(),
                  ...List.generate(_models.length,
                          (index) => _buildCard(_models[index], index))
                      .sepWidget(separate: BeeDivider.horizontal()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavi: Container(
        color: kForeGroundColor,
        padding: EdgeInsets.fromLTRB(
            32.w, 16.w, 32.w, 12.w + MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (allSelect) {
                  _selectYears.clear();
                  setState(() {});
                } else {
                  _selectYears.clear();
                  for (var i = 0; i < _selectModels.length; i++) {
                    _selectYears.add(i);
                  }
                  setState(() {});
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.w,
                        color: allSelect ? kPrimaryColor : kDarkSubColor),
                    color: allSelect ? kPrimaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.w)),
                curve: Curves.easeInOutCubic,
                width: 40.w,
                height: 40.w,
                child: allSelect
                    ? Icon(
                        CupertinoIcons.check_mark,
                        size: 25.w,
                        color: Colors.white,
                      )
                    : SizedBox(),
              ).material(color: Colors.transparent),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                    text: TextSpan(
                        text: '合计：',
                        style: TextStyle(
                            color: ktextPrimary,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: '¥${total.payTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: kDangerColor,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold)),
                    ])),
                '已选${total.payCount}项'
                    .text
                    .color(ktextSubColor)
                    .size(20.sp)
                    .make(),
              ],
            ),
            24.w.widthBox,
            _payButton(),
          ],
        ),
      ),
    );
  }
}
