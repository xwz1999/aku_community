import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/constants/app_theme.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/models/surrounding_enterprises/surrounding_enterprises_model.dart';
import 'package:aku_community/pages/surrounding_enterprises/surrounding_enterprises_detail_page.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SurroundingEnterprisesPage extends StatefulWidget {
  SurroundingEnterprisesPage({Key? key}) : super(key: key);

  @override
  _SurroundingEnterprisesPageState createState() =>
      _SurroundingEnterprisesPageState();
}

class _SurroundingEnterprisesPageState
    extends State<SurroundingEnterprisesPage> {
  EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCard(SurroundingEnterprisesModel model) {
    return GestureDetector(
      onTap: () {
        Get.to(SurroundingEnterprisesDetailPage(
          surroundingEnterprisesModel: model,
        ));
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        color: Colors.white,
        width: 750.w,
        height: 250.w,
        child: Row(
          //  .padding(EdgeInsets.all(20.w)).white.withRounded(value: 8.w).make()

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                image: API.image(ImgModel.first(model.imgList)),
                height: 194.w,
                width: 209.w,
                fit: BoxFit.fill,
              ),
            ),
            24.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 430.w,
                  child: Text(
                    '${model.name}',
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: ktextPrimary),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                20.hb,
                Container(
                  width: 400.w,
                  child: Text(
                    '${model.content}',
                    style: TextStyle(fontSize: 24.sp, color: ktextPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    '${S.of(context)!.tempPlotName}'
                        .text
                        .size(20.sp)
                        .color(ktextThirdColor)
                        .make(),
                    Spacer(),
                    '发布于${model.getReleaseDate.toString().substring(5, 16)}'
                        .text
                        .size(20.sp)
                        .color(ktextThirdColor)
                        .make(),
                  ],
                )
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '周边企业',
      systemStyle: SystemStyle.genStyle(bottom: Color(0xFF2A2A2A)),
      body: BeeListView<SurroundingEnterprisesModel>(
        path: API.manager.surroundingEnterprises,
        convert: (model) {
          return model.tableList!
              .map((e) => SurroundingEnterprisesModel.fromJson(e))
              .toList();
        },
        controller: _refreshController,
        builder: (items) {
          return ListView.separated(
            itemBuilder: (context, index) {
              return _buildCard(items[index]);
            },
            separatorBuilder: (context, index) => 20.hb,
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
