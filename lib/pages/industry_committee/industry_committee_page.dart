import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/constants/app_theme.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/user/committee_item_model.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';

class IndustryCommitteePage extends StatefulWidget {
  IndustryCommitteePage({Key? key}) : super(key: key);

  @override
  _IndustryCommitteePageState createState() => _IndustryCommitteePageState();
}

class _IndustryCommitteePageState extends State<IndustryCommitteePage> {
  EasyRefreshController _refreshController = EasyRefreshController();
  String phone = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () async {
      phone = await HouseFunc().getPhone();
      setState(() {});
    });
  }

  Widget _buildBottomNavi() {
    return [
      MaterialButton(
        onPressed: () {
          Get.dialog(CupertinoAlertDialog(
            title: phone.text.isIntrinsic.make(),
            actions: [
              CupertinoDialogAction(
                child: '取消'.text.isIntrinsic.make(),
                onPressed: Get.back,
              ),
              CupertinoDialogAction(
                child: '呼叫'.text.isIntrinsic.orange500.make(),
                onPressed: () {
                  launch('tel:$phone');
                  Get.back();
                },
              ),
            ],
          ));
        },
        height: 98.w,
        color: Color(0xFF2A2A2A),
        child: '业委会电话'.text.white.size(32.sp).make(),
      )
          .box
          .color(Color(0xFF2A2A2A))
          .padding(EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ))
          .make()
          .expand(),
      // MaterialButton(
      //   onPressed: CommitteeMailboxPage().to,
      //   height: 98.w,
      //   color: kPrimaryColor,
      //   child: '业委会信箱'.text.size(32.sp).color(ktextPrimary).make(),
      // )
      //     .box
      //     .color(kPrimaryColor)
      //     .padding(EdgeInsets.only(
      //       bottom: MediaQuery.of(context).viewPadding.bottom,
      //     ))
      //     .make()
      //     .expand(),
    ].row();
  }

  Widget _buildCard(CommitteeItemModel model) {
    return VxBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.w),
            child: FadeInImage.assetNetwork(
              placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
              image: API.image(ImgModel.first(model.imgUrls)),
              height: 150.w,
              width: 150.w,
              fit: BoxFit.cover,
            ),
          ),
          24.wb,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              [
                model.name!.text.size(28.sp).color(ktextPrimary).make(),
                Spacer(),
                Container(
                  height: 44.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.w),
                  child: model.positionValue.text
                      .size(24.sp)
                      .color(ktextPrimary)
                      .make(),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(22.w),
                    border: Border.all(color: Color(0xFFFFC40C), width: 1.w),
                  ),
                ),
              ].row(),
              6.hb,
              ...[
                '住址：${model.roomName}'
                    .text
                    .size(24.sp)
                    .color(ktextSubColor)
                    .make(),
                // '任职期限：XXXXX'.text.size(24.sp).color(ktextSubColor).make(),
                '从事岗位：${model.profession}'
                    .text
                    .size(24.sp)
                    .color(ktextSubColor)
                    .make(),
              ].sepWidget(separate: 10.hb),
            ],
          ).expand(),
        ],
      ),
    ).padding(EdgeInsets.all(20.w)).white.withRounded(value: 8.w).make();
  }

  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '业委会',
      systemStyle: SystemStyle.genStyle(bottom: Color(0xFF2A2A2A)),
      body: BeeListView<CommitteeItemModel>(
        path: API.manager.commiteeStaff,
        convert: (model) {
          return model.tableList!
              .map((e) => CommitteeItemModel.fromJson(e))
              .toList();
        },
        controller: _refreshController,
        builder: (items) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.w),
            itemBuilder: (context, index) {
              return _buildCard(items[index]);
            },
            separatorBuilder: (context, index) => 20.hb,
            itemCount: items.length,
          );
        },
      ),
      bottomNavi: _buildBottomNavi(),
    );
  }
}
