import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/manager/questinnaire_model.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/ui/manager/questionnaire/questionnaire_detail_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/others/stack_avatar.dart';

class QuestionnairePage extends StatefulWidget {
  QuestionnairePage({Key? key}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  @override
  void initState() {
    super.initState();
  }

  String _getButtonText(int? status) {
    switch (status) {
      case 1:
      case 2:
        return '去投票';
      case 3:
        return '已结束';
      case 4:
        return '已投票';
      default:
        return '';
    }
  }

  Widget _buildCard(QuestionnaireModel model) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => QuestionnaireDetailPage(
        //       id: model.id,
        //       status: model.status,
        //     ));
        if (model.status == 2) {
          Get.to(() => QuestionnaireDetailPage(
            id: model.id,
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: kForeGroundColor,
        ),
        width: double.infinity,
        // height: 236.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.w)),
                  width: 160.w,
                  height: 120.w,
                  child: ClipRRect(
                    child: FadeInImage.assetNetwork(
                      placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                      image: API.image(ImgModel.first(model.imgUrls)),
                    ),
                  ),
                ),
                20.w.widthBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    model.title!.text.black.size(28.sp).make(),
                    6.w.heightBox,
                    model.description!.text
                        .color(ktextSubColor)
                        .size(28.sp)
                        .maxLines(1)
                        .overflow(TextOverflow.ellipsis)
                        .make(),
                    6.w.heightBox,
                    RichText(
                        text: TextSpan(
                            text: '参与时间:',
                            style: TextStyle(
                              color: ktextSubColor,
                              fontSize: 24.sp,
                            ),
                            children: [
                          TextSpan(
                            style: TextStyle(
                              color: ktextPrimary,
                              fontSize: 24.sp,
                            ),
                            text: DateUtil.formatDateStr(model.beginDate!,
                                    format: "MM月dd日 HH:mm") +
                                '至' +
                                DateUtil.formatDateStr(model.endDate!,
                                    format: "MM月dd日 HH:mm"),
                          ),
                        ])),
                  ],
                ).expand()
              ],
            ),
            40.w.heightBox,
            Row(
              children: [
                StackAvatar(
                    avatars: model.headImgURls!.map((e) => e.url).toList()),
                26.w.widthBox,
                '${model.answerNum}人已参加'.text.black.size(20.sp).make(),
                Spacer(),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.w)),
                  color: model.status == 3 ? kDarkSubColor : kPrimaryColor,
                  minWidth: 120.w,
                  height: 44.w,
                  // padding:
                  //     EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.w),
                  elevation: 0,
                  onPressed: () {
                    if (model.status == 2) {
                      Get.to(() => QuestionnaireDetailPage(
                            id: model.id,
                          ));
                    }
                  },
                  child: (_getButtonText(model.status))
                      .text
                      .black
                      .size(20.sp)
                      .bold
                      .make(),
                ),
              ],
            )
          ],
        ),
      ).material(color: Colors.transparent),
    );
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '问卷调查',
      body: BeeListView<QuestionnaireModel>(
          path: API.manager.questionnaireList,
          controller: _easyRefreshController,
          convert: (model) {
            return model.tableList!
                .map((e) => QuestionnaireModel.fromJson(e))
                .toList();
          },
          builder: (items) {
            return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.w),
                itemBuilder: (context, index) {
                  return _buildCard(items[index]);
                },
                separatorBuilder: (_, __) {
                  return 24.w.heightBox;
                },
                itemCount: items.length);
          }),
    );
  }
}
