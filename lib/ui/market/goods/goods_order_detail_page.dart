import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/extensions/widget_list_ext.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/models/market/goods_detail_model.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:aku_community/ui/profile/house/house_owners_page.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_divider.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/bottom_sheets/pay_bottom_sheet.dart';
import 'package:aku_community/widget/buttons/bee_numberic_button.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:power_logger/power_logger.dart';
import 'package:velocity_x/velocity_x.dart';

class GoodsOrderDetailPage extends StatefulWidget {
  final GoodsDetailModel model;
  final String name;
  final String phone;
  GoodsOrderDetailPage(
      {Key? key, required this.model, required this.name, required this.phone})
      : super(key: key);

  @override
  _GoodsOrderDetailPageState createState() => _GoodsOrderDetailPageState();
}

class _GoodsOrderDetailPageState extends State<GoodsOrderDetailPage> {
  late EasyRefreshController _refreshController;
  bool _onload = true;
  String _payMethod = '支付宝';
  ///商品数量
  int _num = 1;
  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    BotToast.closeAllLoading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '确认订单',
      actions: [
        TextButton(
            onPressed: () {
              Get.to(() => HouseOwnersPage(
                    identify: UserTool.userProvider.userDetailModel!.type ?? 4,
                  ));
            },
            child: '切换房屋'.text.size(28.sp).color(ktextPrimary).make())
      ],
      body: EasyRefresh(
        header: MaterialHeader(),
        firstRefresh: true,
        onRefresh: () async {
          _onload = false;
          setState(() {});
        },
        child: _onload
            ? Container()
            : ListView(
                padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 32.w),
                children: <Widget>[
                  _addressInfo(),
                  _goodsInfoWidget(),
                ].sepWidget(
                  separate: 24.w.heightBox,
                ),
              ),
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
                  BaseModel baseModel = await NetUtil().post(
                    API.pay.shoppingAlipay,
                    params: {
                      'goodsId': widget.model.id,
                      'userName': widget.name,
                      'userTel': widget.phone,
                      'num': _num,
                      'payType': 1,
                      'payPrice': widget.model.sellingPrice,
                    },
                    showMessage: false,
                  );
                  if ((baseModel.status ?? false) &&
                      !baseModel.message.isEmptyOrNull) {
                    bool result = await PayUtil()
                        .callAliPay(baseModel.message!, API.pay.shoppingCheck);
                    if (result) {
                      Get.off(() => PayFinishPage());
                    }
                  } else {
                    BotToast.showText(text: baseModel.message!);
                  }
                }else if(_payMethod=='微信'){
                  await HouseFunc()
                      .shoppingVxPay(widget.model.id,widget.name,widget.phone,_num,2, widget.model.sellingPrice,).then((value) {
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
            }));
          },
          child: '立即支付'.text.size(32.sp).color(ktextPrimary).bold.make()),
    );
  }

  Widget _addressInfo() {
    return Container(
      padding: EdgeInsets.all(24.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.model.title.text
              .size(32.sp)
              .color(ktextPrimary)
              .bold
              .maxLines(2)
              .ellipsis
              .make(),
          20.w.heightBox,
          Row(
            children: [
              widget.name.text.size(24.sp).color(ktextSubColor).make(),
              24.w.widthBox,
              widget.phone.text.size(24.sp).color(ktextSubColor).make(),
              Spacer(),
              '送出时间等待电话联系'.text.size(24.sp).color(ktextPrimary).bold.make(),
            ],
          )
        ],
      ),
    );
  }

  Widget _goodsInfoWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              '商品信息'.text.size(32.sp).bold.color(ktextPrimary).make(),
              Spacer(),
              // widget.model.statusString.text
              //     .size(30.sp)
              //     .bold
              //     .color(widget.model.statusColor)
              //     .make(),
            ],
          ),
          16.w.heightBox,
          BeeDivider.horizontal(),
          24.w.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                clipBehavior: Clip.antiAlias,
                child: FadeInImage.assetNetwork(
                    width: 160.w,
                    height: 160.w,
                    fit: BoxFit.cover,
                    placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                    image:
                        API.image(ImgModel.first(widget.model.goodsImgList))),
              ),
              24.w.widthBox,
              SizedBox(
                height: 160.w,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.model.title.text
                            .size(28.sp)
                            .color(ktextPrimary)
                            .maxLines(2)
                            .overflow(TextOverflow.ellipsis)
                            .bold
                            .maxLines(2)
                            .ellipsis
                            .make()
                            .expand(),
                        '¥${widget.model.sellingPrice}'
                            .text
                            .size(28.sp)
                            .bold
                            .color(Color(0xFFE60E0E))
                            .make(),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        //|${widget.model.levelTwoCategory}
                        ('${widget.model.categoryName}')
                            .text
                            .size(24.sp)
                            .color(ktextSubColor)
                            .make()
                      ],
                    ),
                    12.w.heightBox,
                    Row(
                      children: [
                        ('${widget.model.recommend}')
                            .text
                            .size(24.sp)
                            .color(ktextSubColor)
                            .make()
                      ],
                    ),
                  ],
                ),
              ).expand()
            ],
          ),
          40.w.heightBox,
          ...<Widget>[
            Row(
              children: [
                // (160 + 24).w.widthBox,
                '数量'.text.size(24.sp).color(ktextSubColor).make(),
                Spacer(),
                BeeNumberPickerButton(
                    initValue: 1,
                    minValue: 1,
                    maxValue: 99,
                    onChange: (value) {
                      _num = value;
                    })
              ],
            ),
            _rowTile('配送方式', '商家配送'),
            _rowTile('订单备注', widget.model.arrivalTime ?? ''),
          ].sepWidget(
            separate: 20.w.heightBox,
          ),
        ],
      ),
    );
  }

  // Widget _orderInfo() {
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             '订单信息'.text.size(32.sp).bold.color(ktextPrimary).make(),
  //           ],
  //         ),
  //         24.w.heightBox,
  //         ...<Widget>[
  //           _rowTile('配送方式', '商家配送'),
  //         ].sepWidget(
  //           separate: 20.w.heightBox,
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _rowTile(
    String title,
    String content,
  ) {
    return Row(
      children: [
        // (160 + 24).w.widthBox,
        title.text.size(24.sp).color(ktextSubColor).make(),
        Spacer(),
        content.text.size(24.sp).color(ktextPrimary).make(),
      ],
    );
  }
}
