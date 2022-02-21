import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/extensions/widget_list_ext.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/models/market/order/my_order_list_model.dart';
import 'package:aku_community/ui/market/order/my_order_detail_page.dart';
import 'package:aku_community/ui/market/order/my_order_evaluation_page.dart';
import 'package:aku_community/ui/market/order/my_order_func.dart';
import 'package:aku_community/ui/market/order/my_order_refund_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_divider.dart';
import 'package:aku_community/widget/buttons/card_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyOrderCard extends StatefulWidget {
  final MyOrderListModel model;
  final VoidCallback callRefresh;
  MyOrderCard({Key? key, required this.model, required this.callRefresh})
      : super(key: key);

  @override
  _MyOrderCardState createState() => _MyOrderCardState();
}

class _MyOrderCardState extends State<MyOrderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MyOrderDetailPage(
              model: widget.model,
            ));
      },
      child: Container(
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
                widget.model.goodsName.text
                    .size(32.sp)
                    .bold
                    .color(ktextPrimary)
                    .make(),
                Spacer(),
                widget.model.statusString.text
                    .size(30.sp)
                    .bold
                    .color(widget.model.statusColor)
                    .make(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.model.goodsName.text
                              .size(28.sp)
                              .color(ktextPrimary)
                              .maxLines(2)
                              .overflow(TextOverflow.ellipsis)
                              .bold
                              .make(),
                          Spacer(),
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
                          ('${widget.model.levelOneCategory}|${widget.model.levelTwoCategory}')
                              .text
                              .size(24.sp)
                              .color(ktextSubColor)
                              .make()
                        ],
                      ),
                      // 12.w.heightBox,
                      // Row(
                      //   children: [
                      //     ('${widget.model.levelTwoCategory}')
                      //         .text
                      //         .size(24.sp)
                      //         .color(ktextSubColor)
                      //         .make()
                      //   ],
                      // ),
                    ],
                  ),
                ).expand()
              ],
            ),
            40.w.heightBox,
            ...[
              _rowTile('下单时间', widget.model.arrivalDateString),
              _rowTile('到达地点', '${S.of(context)!.tempPlotName}北侧门口'),
              _rowTile('发货时间', widget.model.sendDateString),
            ].sepWidget(separate: 16.w.heightBox),
            ..._bottomWidget(),
          ],
        ),
      ),
    );
  }

  List<Widget> _bottomWidget() {
    List<Widget> _buttons = _getBottomButton(widget.model.status);

    return _buttons.isEmpty
        ? []
        : [
            40.w.heightBox,
            Row(
              children: [Spacer(), ..._buttons],
            ),
          ];
  }

  List<Widget> _getBottomButton(int status) {
    switch (status) {
      case 1:
        return [
          CardBottomButton.white(
              text: '取消预约',
              onPressed: () async {
                await MyOrderFunc.cancelOrder(widget.model.id);
                widget.callRefresh();
              }),
        ].sepWidget(separate: 24.w.widthBox);
      case 2:
        return <Widget>[
          CardBottomButton.yellow(
              text: '查看详情',
              onPressed: () {
                Get.to(MyOrderDetailPage(model: widget.model));
              }),
        ].sepWidget(separate: 24.w.widthBox);
      case 3:
        return [
          CardBottomButton.yellow(
              text: '确认收货',
              onPressed: () async {
                await MyOrderFunc.confirmReceive(widget.model.id);
                widget.callRefresh();
              }),
        ].sepWidget(separate: 24.w.widthBox);
      case 4:
        return <Widget>[
          CardBottomButton.white(
              text: '评价商品',
              onPressed: () async {
                await Get.to(() => MyOrderEvaluationPage(model: widget.model));
                widget.callRefresh();
              }),
          CardBottomButton.white(
              text: '申请退换',
              onPressed: () async {
                await Get.to(() => MyOrderRefundPage(
                      model: widget.model,
                    ));
                widget.callRefresh();
              }),
        ].sepWidget(separate: 24.w.widthBox);
      case 6:
        return <Widget>[
          CardBottomButton.yellow(text: '查看详情', onPressed: () {}),
        ];
      case 8:
        return <Widget>[
          CardBottomButton.yellow(text: '查看详情', onPressed: () {}),
        ];
      default:
        return [];
    }
  }

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
