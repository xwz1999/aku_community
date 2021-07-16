import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/models/house_keeping/house_keeping_list_model.dart';
import 'package:aku_community/models/house_keeping/house_keeping_process_model.dart';
import 'package:aku_community/ui/manager/house_keeping/evaluate_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_divider.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/views/bee_grid_image_view.dart';

class HouseKeepingDetailPage extends StatefulWidget {
  final HouseKeepingListModel model;
  final List<HouseKeepingProcessModel> processModels;
  HouseKeepingDetailPage(
      {Key? key, required this.model, required this.processModels})
      : super(key: key);

  @override
  _HouseKeepingDetailPageState createState() => _HouseKeepingDetailPageState();
}

class _HouseKeepingDetailPageState extends State<HouseKeepingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '服务详情',
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24.w),
        children: [
          _buildInfo(),
          16.w.heightBox,
          _buildProcess(),
          16.w.heightBox,
          Offstage(
            offstage: widget.model.handlingTime == null,
            child: Column(
              children: [
                16.w.heightBox,
                _serviceFeedBack(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
            color: Colors.white,
            child: Row(
              children: [
                '服务费用'.text.size(28.sp).black.make(),
                Spacer(),
                '¥ ${widget.model.payFee ?? 0}'
                    .text
                    .size(32.sp)
                    .color(Colors.red)
                    .make()
              ],
            ),
          ),
          Offstage(
            offstage: widget.model.evaluationTime == null,
            child: Column(
              children: [
                16.w.heightBox,
                _buildEvaluate(),
              ],
            ),
          ),
          // 40.w.heightBox,
          // _background(),
        ],
      ),
      bottomNavi: _getBottomButton(),
    );
  }

  Widget _getBottomButton() {
    switch (widget.model.status) {
      case 2:
      case 3:
      case 4:
        return BottomButton(
            onPressed: () {}, child: '立即支付'.text.size(32.sp).bold.black.make());
      case 5:
        return BottomButton(
            onPressed: () {
              Get.to(() => EvaluatePage());
            },
            child: '立即评价'.text.size(28.sp).bold.black.make());
      default:
        return SizedBox();
    }
  }

  Widget _buildInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 24.w),
      child: Column(
        children: [
          Row(
            children: [
              '服务信息'.text.size(36.sp).bold.black.make(),
              Spacer(),
              widget.model.statusString.text
                  .size(32.sp)
                  .color(widget.model.statusColor)
                  .make()
            ],
          ),
          40.w.heightBox,
          _buildTile(R.ASSETS_ICONS_ARTICLE_COUNT_PNG, '申请人',
              widget.model.proposerName),
          16.w.heightBox,
          _buildTile(
              R.ASSETS_ICONS_PHONE_PNG, '联系电话', widget.model.proposerTel),
          16.w.heightBox,
          _buildTile(R.ASSETS_ICONS_APPOINTMENT_ADDRESS_PNG, '地址',
              '${S.of(context)!.tempPlotName}·${widget.model.roomName}'),
          56.w.heightBox,
          BeeGridImageView(
              urls: widget.model.submitImgList.map((e) => e.url).toList()),
        ],
      ),
    );
  }

  Widget _buildTile(String iconPath, String title, String suffix) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 40.w,
          height: 40.w,
        ),
        8.w.widthBox,
        title.text.size(28.sp).color(ktextSubColor).make(),
        Spacer(),
        suffix.text.size(28.sp).black.make(),
      ],
    );
  }

  Widget _buildProcess() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 24.w),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              '服务进程'.text.size(36.sp).bold.black.make(),
            ],
          ),
          24.w.heightBox,
          ...widget.processModels
              .map((e) => _buildProcessTile(e.operatorContent, e.operationDate))
              .toList()
              .sepWidget(separate: 24.w.heightBox)
        ],
      ),
    );
  }

  Widget _buildProcessTile(String content, String date) {
    return Row(children: [
      content.text.size(28.sp).color(ktextSubColor).make(),
      Spacer(),
      '${DateUtil.formatDateStr(date, format: 'yyyy-MM-dd HH:mm:ss')}'
          .text
          .size(28.sp)
          .black
          .make(),
    ]);
  }

  Widget _buildEvaluate() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 24.w),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '服务评价'.text.size(36.sp).bold.black.make(),
          40.w.heightBox,
          Row(
            children: [
              '综合评价'.text.size(28.sp).color(ktextSubColor).make(),
              40.w.widthBox,
              RatingBar(
                  ignoreGestures: true,
                  allowHalfRating: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemSize: 32.w,
                  initialRating: (widget.model.evaluation ?? 0).toDouble(),
                  ratingWidget: RatingWidget(
                      empty: Icon(
                        CupertinoIcons.star,
                      ),
                      full: Icon(
                        CupertinoIcons.star_fill,
                        color: kPrimaryColor,
                      ),
                      half: Icon(
                        CupertinoIcons.star_lefthalf_fill,
                        color: kPrimaryColor,
                      )),
                  onRatingUpdate: (value) {})
            ],
          ),
          40.w.heightBox,
          BeeDivider.horizontal(),
          40.w.heightBox,
          (widget.model.evaluationContent ?? '')
              .text
              .size(28.sp)
              .black
              .softWrap(true)
              .make(),
          BeeGridImageView(urls: [])
        ],
      ),
    );
  }

  Widget _serviceFeedBack() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 24.w),
      child: Column(
        children: [
          '服务反馈'.text.size(36.sp).bold.black.make(),
          40.w.heightBox,
          Row(
            children: [
              '完成情况'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              widget.model.completionString.text.size(32.sp).black.make()
            ],
          ),
          40.w.heightBox,
          Row(
            children: [
              Image.asset(
                R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                width: 40.w,
                height: 40.w,
              ),
              8.w.widthBox,
              '维修人'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              widget.model.proposerName.text.size(28.sp).black.make(),
            ],
          ),
          16.w.heightBox,
          Row(
            children: [
              Image.asset(
                R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                width: 40.w,
                height: 40.w,
              ),
              8.w.widthBox,
              '联系电话'.text.size(28.sp).color(ktextSubColor).make(),
              Spacer(),
              widget.model.proposerTel.text.size(28.sp).black.make(),
            ],
          ),
          16.w.heightBox,
          40.w.heightBox,
          '处理描述'.text.size(28.sp).color(ktextSubColor).make(),
          24.w.heightBox,
          (widget.model.processDescription ?? '')
              .text
              .size(2)
              .black
              .softWrap(true)
              .make(),
          BeeGridImageView(urls: [])
        ],
      ),
    );
  }

  // int _airPlane = 1;
  // int _train = 2;
  // int _xxx = 3;
  // int _select = 1;

  // Widget _background() {
  //   return Center(
  //     child: Container(
  //       width: 600.w,
  //       height: 600.w,
  //       decoration: BoxDecoration(
  //           color: Colors.transparent,
  //           borderRadius: BorderRadius.circular(16.w)),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               _header(
  //                 _airPlane,
  //                 _select,
  //                 'aaa',
  //                 'left'
  //               ).expand(),
  //               _header(_train, _select, 'bbb', 'mid').expand(),
  //               _header(_xxx, _select, 'ccc', 'right').expand(),
  //             ],
  //           ),
  //           Container(
  //             width: double.infinity,
  //             alignment: Alignment.center,
  //             child: 'xxxxxxxx'.text.size(36.sp).black.make(),
  //             color: Colors.white,
  //           ).expand(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _header(int value, int selectValue, String title, String position) {
  //   bool isSelect = value == selectValue;
  //   return Column(
  //     children: [
  //       isSelect
  //           ? Container(
  //               height: 40.w,
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: position == 'left'
  //                           ? Radius.zero
  //                           : Radius.circular(20.w),
  //                       topRight: position == 'right'
  //                           ? Radius.zero
  //                           : Radius.circular(20.w))),
  //             )
  //           : Container(height: 40.w, color: Colors.transparent),
  //       isSelect
  //           ? Container(
  //               height: 120.w,
  //               alignment: Alignment.center,
  //               width: double.infinity,
  //               child: title.text.size(32.sp).red500.make(),
  //               color: Colors.white,
  //             )
  //           : GestureDetector(
  //               onTap: () {
  //                 _select = value;
  //                 setState(() {});
  //               },
  //               child: Container(
  //                 height: 120.w,
  //                 width: double.infinity,
  //                 alignment: Alignment.center,
  //                 child: title.text.size(30.sp).black.make(),
  //                 decoration: BoxDecoration(
  //                     color: Colors.pinkAccent,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft:!(position=='right')? Radius.circular(16.w):Radius.zero,
  //                         topRight: !(position=='left')?Radius.circular(16.w):Radius.zero,
  //                         bottomLeft: !(position=='left')?Radius.circular(16.w):Radius.zero,
  //                         bottomRight:!(position=='right')?Radius.circular(16.w):Radius.zero)),
  //               ),
  //             ),
  //     ],
  //   );
  // }
}