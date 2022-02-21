import 'dart:math';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/pages/renovation_manage/renovation_map.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class RenovationManageDetailPage extends StatefulWidget {
  RenovationManageDetailPage({Key? key}) : super(key: key);

  @override
  _RenovationManageDetailPageState createState() =>
      _RenovationManageDetailPageState();
}

class _RenovationManageDetailPageState
    extends State<RenovationManageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '装修详情',
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24.w),
        children: [
          _buildInfo(),
          _buildFinishWorkCheck(),
          _buildCycleCheck(),
        ],
      ),
    );
  }

  Widget _akuTitleBox(
      String title, Widget suffix, double spacing, List<Widget> children) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ktextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 36.sp,
                ),
              ),
              Spacer(),
              suffix,
            ],
          ),
          spacing.w.heightBox,
          ...children,
        ],
      ),
    );
  }

  _buildInfoCard({
    String? tag,
    String? midTop,
    String? midBottom,
    String? name,
    String? phone,
    Widget rightTopWidget = const SizedBox(),
  }) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              Expanded(
                  child: Row(
                children: [
                  32.w.widthBox,
                  Container(
                    height: 96.w,
                    width: 96.w,
                    alignment: Alignment.center,
                    child: Text(
                      tag!,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.sp,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFE9F2FF),
                      borderRadius: BorderRadius.circular(48.w),
                    ),
                  ),
                  24.w.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          midTop!,
                          style: TextStyle(
                            color: ktextPrimary,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        midBottom == null
                            ? SizedBox()
                            : Text(
                                midBottom,
                                style: TextStyle(
                                  color: ktextPrimary,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              )),
              Divider(
                height: 1.w,
                thickness: 1.w,
              ),
              Row(
                children: [
                  88.w.heightBox,
                  32.w.widthBox,
                  Image.asset(
                    R.ASSETS_ICONS_ARTICLE_COUNT_PNG,
                    height: 40.w,
                    width: 40.w,
                  ),
                  Text(
                    name!,
                    style: TextStyle(
                      color: ktextSubColor,
                      fontSize: 24.sp,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    R.ASSETS_ICONS_ARTICLE_COUNT_PNG,
                    height: 40.w,
                    width: 40.w,
                  ),
                  Text(
                    '电话：$phone',
                    style: TextStyle(
                      color: ktextSubColor,
                      fontSize: 24.sp,
                    ),
                  ),
                  42.w.heightBox,
                ],
              ),
            ],
          ),
          height: 248.w,
          decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(8.w),
          ),
        ),
        Positioned(
          top: -30.w,
          right: -30.w,
          width: 140.w,
          height: 140.w,
          child: rightTopWidget,
        ),
      ],
    );
  }

  _buildInfo() {
    return _akuTitleBox(
      '装修信息',
      Text(
        RenovationMap.getTagName(1, 2),
        style: TextStyle(
          color: RenovationMap.getTagColor(1),
          fontSize: 24.w,
        ),
      ),
      24,
      [
        _buildInfoCard(
          tag: '家',
          midTop: '${S.of(context)!.tempPlotName}',
          midBottom: '1幢-1单元-302',
          name: '业主：' + '马泽鹏',
          phone: '13720183183',
          rightTopWidget: Transform.rotate(
            angle: pi / 4,
            child: Image.asset(R.ASSETS_IMAGES_PLACEHOLDER_WEBP),
          ),
        ),
        16.w.heightBox,
        _buildInfoCard(
          tag: '装',
          midTop: '莫川装修公司',
          name: '负责人：刘一发',
          phone: '1876276274',
        ),
      ],
    );
  }

  _buildFinishWorkCheck() {
    return _akuTitleBox(
      '完工检查',
      SizedBox(),
      24,
      [
        _buildRow(
          title: '开始装修时间',
          subTitle: DateUtil.formatDateStr(
            '2020-10-23 10:24:56',
            format: 'yyyy-MM-dd',
          ),
        ),
        _buildRow(
          title: '接受人',
          subTitle: '黄鑫',
        ),
        _buildRow(title: '所属项目', subTitle: '装修管理'),
        _buildRow(
          title: '开始日期',
          subTitle: DateUtil.formatDateStr(
            '2020-10-23 10:24:56',
            format: 'yyyy-MM-dd',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 28.w,
          ),
          child: Text(
            '检查内容',
            style: TextStyle(
              color: ktextPrimary,
              fontSize: 28.w,
            ),
          ),
        ),
        // DecorationCheckRow(
        //   details: widget.model.workFinishCheck?.checkDetails,
        //   onChange: (details) {},
        // ),
      ],
    );
  }

  _buildCycleCheck() {
    return _akuTitleBox(
      '周期检查',
      SizedBox(),
      24,
      [
        _buildRow(
          title: '开始装修时间',
          subTitle: DateUtil.formatDateStr(
            '2020-10-23 10:24:56',
            format: 'yyyy-MM-dd',
          ),
        ),
        _buildRow(title: '接受人', subTitle: '黄鑫', onTap: () {}),
        _buildRow(title: '所属项目', subTitle: '装修管理'),
        _buildRow(
          title: '开始日期',
          subTitle: DateUtil.formatDateStr(
            '2020-10-23 10:24:56',
            format: 'yyyy-MM-dd',
          ),
          onTap: () {
            // showBottomSheet(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Row(
            //         children: [
            //           AkuBox.h(96),
            //           AkuBackButton.text(),
            //           Spacer(),
            //           Text(
            //             '开始日期',
            //             style: TextStyle(
            //               color: AppStyle.primaryTextColor,
            //               fontSize: 32.sp,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           Spacer(),
            //           AkuMaterialButton(
            //             minWidth: (64 + 56).w,
            //             onPressed: () {
            //               Get.back();
            //             },
            //             child: Text(
            //               '确定',
            //               style: TextStyle(
            //                 color: AppStyle.secondaryColor,
            //                 fontSize: 28.sp,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //       Container(
            //         height: 500.w,
            //         child: CupertinoDatePicker(
            //           onDateTimeChanged: (dateTime) {
            //             widget.model.cycleCheck.startDate = dateTime;
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ).then((value) {
            //   setState(() {});
            // });
          },
        ),
        _buildRow(
            title: '检查周期',
            subTitle: '2020-10-23 10:24:56',
            onTap: () {
              // showAkuSheet(
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Row(
              //         children: [
              //           AkuBox.h(96),
              //           AkuBackButton.text(),
              //           Spacer(),
              //           Text(
              //             '检查周期',
              //             style: TextStyle(
              //               color: AppStyle.primaryTextColor,
              //               fontSize: 32.sp,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Spacer(),
              //           AkuMaterialButton(
              //             minWidth: (64 + 56).w,
              //             onPressed: () {
              //               Get.back();
              //             },
              //             child: Text(
              //               '确定',
              //               style: TextStyle(
              //                 color: AppStyle.secondaryColor,
              //                 fontSize: 28.sp,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Container(
              //         height: 500.w,
              //         child: CupertinoPicker(
              //           children: [
              //             Center(
              //               child: Text('1天'),
              //             ),
              //             Center(
              //               child: Text('3天'),
              //             ),
              //             Center(
              //               child: Text('7天'),
              //             ),
              //             Center(
              //               child: Text('14天'),
              //             ),
              //             Center(
              //               child: Text('30天'),
              //             ),
              //           ],
              //           itemExtent: 88.w,
              //           onSelectedItemChanged: (int value) {
              //             int realValue = 0;
              //             switch (value) {
              //               case 0:
              //                 realValue = 1;
              //                 break;
              //               case 1:
              //                 realValue = 3;
              //                 break;
              //               case 2:
              //                 realValue = 7;
              //                 break;
              //               case 3:
              //                 realValue = 14;
              //                 break;
              //               case 4:
              //                 realValue = 30;
              //                 break;
              //             }
              //             widget.model.cycleCheck.checkCycle = realValue;
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ).then((value) {
              //   setState(() {});
              // });
            }),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 28.w,
          ),
          child: Text(
            '检查内容',
            style: TextStyle(
              color: ktextPrimary,
              fontSize: 28.w,
            ),
          ),
        ),
        // DecorationCheckRow(
        //   details: [
        //     CHECK_TYPE.ELECTRIC,
        //     CHECK_TYPE.WATER,
        //     CHECK_TYPE.WALL,
        //     CHECK_TYPE.DOOR_AND_WINDOWS,
        //     CHECK_TYPE.SECURITY,
        //   ],
        //   onChange: (details) {
        //     widget.model.cycleCheck.checkDetails = details;
        //   },
        //   canTap: isWaitHandOut,
        // )
      ],
    );
  }

  _buildRow({
    String? title,
    String? subTitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xFFE8E8E8), width: 1.w)),
          ),
          child: InkWell(
            child: Row(
              children: [
                96.w.heightBox,
                Text(
                  title!,
                  style: TextStyle(
                    color: ktextPrimary,
                    fontSize: 28.w,
                  ),
                ),
                Spacer(),
                Text(
                  (TextUtil.isEmpty(subTitle) ? '请选择' : subTitle)!,
                  style: TextStyle(
                    color: TextUtil.isEmpty(subTitle)
                        ? ktextSubColor
                        : ktextPrimary,
                    fontSize: 28.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap == null ? SizedBox() : 24.w.widthBox,
                onTap == null
                    ? SizedBox()
                    : Icon(
                        Icons.arrow_forward_ios,
                        size: 32.w,
                        color: ktextPrimary,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
