import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/pages/renovation_manage/renovation_manage_detail_page.dart';
import 'package:aku_community/pages/renovation_manage/renovation_map.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class RenovationManageCard extends StatefulWidget {
  final int index;
  RenovationManageCard({Key? key, required this.index}) : super(key: key);

  @override
  _RenovationManageCardState createState() => _RenovationManageCardState();
}

class _RenovationManageCardState extends State<RenovationManageCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RenovationManageDetailPage());
      },
      child: Container(
        margin: EdgeInsets.only(top: 16.w),
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Row(
              children: [
                _akuChipBox('装修管理'),
                16.w.widthBox,
                Text(
                  DateUtil.formatDateStr('2020-10-23 10:24:56',
                      format: 'yyyy-MM-dd HH:mm:ss'),
                  style: TextStyle(
                    color: ktextSubColor,
                    fontSize: 22.w,
                  ),
                ),
                Spacer(),
                Text(
                  RenovationMap.getTagName(
                    widget.index,
                    widget.index,
                  ),
                  style: TextStyle(
                    color: RenovationMap.getTagColor(widget.index),
                    fontSize: 24.w,
                  ),
                ),
              ],
            ),
            24.w.heightBox,
            _buildTile(R.ASSETS_ICONS_ARTICLE_NAME_PNG, '小区名称',
                '${S.of(context)!.tempPlotName}'),
            12.w.heightBox,
            _buildTile(
              R.ASSETS_ICONS_APPOINTMENT_ADDRESS_PNG,
              '详细地址',
              '1幢-1单元-302室',
            ),
            12.w.heightBox,
            _buildTile(
              R.ASSETS_ICONS_APPOINTMENT_CODE_PNG,
              '装修公司',
              '深圳莫川装修有限公司',
            ),
            12.w.heightBox,
            _buildTile(
              R.ASSETS_ICONS_APPOINTMENT_DATE_PNG,
              '装修状态',
              RenovationMap().getDecorationStatus(widget.index),
            ),
            Divider(
              height: 48.w,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: () {
                  // Get.to(DecorationManagerDetailPage(model: widget.model));
                },
                height: 64.w,
                minWidth: 160.w,
                color: kPrimaryColor,
                child: Text(
                  '查看详情',
                  style: TextStyle(
                    color: ktextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.w,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.w)),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
      ),
    );
  }

  _buildTile(String path, String title, String subTitle) {
    return Row(
      children: [
        Image.asset(
          path,
          height: 40.w,
          width: 40.w,
        ),
        Text(
          title,
          style: TextStyle(
            color: ktextSubColor,
            fontSize: 28.sp,
          ),
        ),
        Spacer(),
        Text(
          subTitle,
          style: TextStyle(
            color: ktextPrimary,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _akuChipBox(String title) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          width: 2.w,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
