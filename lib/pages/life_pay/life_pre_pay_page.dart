import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:power_logger/power_logger.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_divider.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/bottom_sheets/pay_mothod_bottom_sheet.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/others/house_head_card.dart';
import 'package:aku_community/widget/others/user_tool.dart';

class LifePrePayPage extends StatefulWidget {
  final double prePay;
  LifePrePayPage({Key? key, required this.prePay}) : super(key: key);

  @override
  _LifePrePayPageState createState() => _LifePrePayPageState();
}

class _LifePrePayPageState extends State<LifePrePayPage> {
  late TextEditingController _editingController;
  String _payMethod = '支付宝';
  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '预缴充值',
      body: ListView(
        children: [
          HouseHeadCard(context: context),
          16.w.heightBox,
          Container(
            padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 32.w),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '预缴金额'.text.size(28.sp).black.make(),
                30.w.heightBox,
                Row(
                  children: [
                    '¥'.text.size(28.sp).black.bold.make(),
                    16.w.widthBox,
                    TextField(
                      controller: _editingController,
                      decoration: InputDecoration(
                        hintText: '0.0',
                        hintStyle: TextStyle(
                          fontSize: 56.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontSize: 56.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"^[0-9][\.\d]*(,\d+)?$"))
                      ],
                      keyboardType: TextInputType.number,
                    ).expand(),
                  ],
                ),
                16.w.heightBox,
                BeeDivider.horizontal(),
                16.w.heightBox,
                '当前房屋下的预缴金额为 '
                    .richText
                    .withTextSpanChildren([
                      widget.prePay
                          .toDoubleStringAsFixed()
                          .textSpan
                          .bold
                          .size(28.sp)
                          .color(kPrimaryColor)
                          .make(),
                      ' 元'.textSpan.size(28.sp).black.make()
                    ])
                    .black
                    .size(28.sp)
                    .make(),
                16.w.heightBox,
                '当账单到期时，将会自动从当前房屋下的预缴金额中扣除相应费用。'
                    .text
                    .size(24.sp)
                    .color(ktextSubColor)
                    .make(),
              ],
            ),
          ),
          16.w.heightBox,
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 32.w),
            child: Row(
              children: [
                '缴费方式'.text.size(28.sp).black.make(),
                Spacer(),
                Image.asset(
                  _payMethod=='微信'? R.ASSETS_ICONS_IC_WX_PNG:R.ASSETS_ICONS_IC_ZFB_PNG,
                  width: 48.w,
                  height: 48.w,
                ),
                16.w.widthBox,
                TextButton(
                    onPressed: () async {
                      Get.bottomSheet(PayMethodBottomSheet(onChoose: (value) {
                        _payMethod = value;
                        Get.back();
                        setState(() {});
                      }));
                    },
                    child: _payMethod.text.size(28.sp).black.make()),
                24.w.widthBox,
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 40.w,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavi: BottomButton(
          onPressed: () async {
            Function cancel = BotToast.showLoading();
            try {
              if( _payMethod=='支付宝')
              {
                BaseModel baseModel =
                await NetUtil().post(API.pay.dailPaymentPrePay, params: {
                  "estateId": UserTool.appProveider.selectedHouse!.estateId,
                  "payType": 1,
                  "payPrice": _editingController.text
                });
                if (baseModel.status ?? false) {
                  bool result = await PayUtil().callAliPay(
                      baseModel.message!, API.pay.dailPaymentPrePayCheck);
                  if (result) {
                    Get.off(() => PayFinishPage());
                  }
                } else {
                  BotToast.showText(text: baseModel.message ?? "");
                }
              }else if(_payMethod=='微信'){
                await HouseFunc()
                    .dailPaymentPreVxPay(UserTool.appProveider.selectedHouse!.estateId, 2, _editingController.text).then((value) {
                  if(value!=null){
                    PayUtil().callWxPay(payModel: value);
                  }
                });
              }else{
                BotToast.showText(text: '请先选择支付方式');
              }


            } catch (e) {
              LoggerData.addData(e);
            }
            cancel();
          },
          child: '立即充值'.text.size(32.sp).bold.black.make()),
    );
  }
}
