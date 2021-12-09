import 'dart:ui';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/community/community_topic_model.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/ui/community/community_views/topic/topic_detail_page.dart';
import 'package:aku_community/utils/headers.dart';

class TopicCommunityView extends StatefulWidget {
  TopicCommunityView({Key? key}) : super(key: key);

  @override
  TopicCommunityViewState createState() => TopicCommunityViewState();
}

class TopicCommunityViewState extends State<TopicCommunityView>{
  EasyRefreshController _refreshController = EasyRefreshController();

  _buildItem(CommunityTopicModel model,int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TopicDetailPage(model: model));
      },
      child: Container(

        padding: EdgeInsets.symmetric(vertical: 20.w,horizontal: 32.w),
        decoration: BoxDecoration(

          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    index<=2?Container(
                      width: 36.w,
                      height: 35.w,
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(index==0? R.ASSETS_ICONS_ICON_TOPIC_FIRST_PNG:index==1? R.ASSETS_ICONS_ICON_TOPIC_SECOND_PNG:
                           R.ASSETS_ICONS_ICON_TOPIC_THIRD_PNG),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child:(index+1)
                          .text
                          .white
                          .size(24.sp)
                          .bold
                          .make(),

                    ):Container(
                      width: 32.w,
                      height: 32.w,
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFC4C4C4),
                        borderRadius: BorderRadius.all(Radius.circular(4.w)),

                      ),
                      child:(index+1)
                          .text
                          .white
                          .size(24.sp)
                          .bold
                          .make(),
                    ),
                    15.wb,

                    Container(
                      width: 400.w,
                      child:('#'+model.summary!)
                          .text
                          .maxLines(1)
                          .size(30.sp)
                          .bold
                          .isIntrinsic
                          .overflow(TextOverflow.ellipsis)
                          .make(),
                    )

                  ],
                ),
                20.hb,
                (model.content ?? '')
                    .text
                    .maxLines(2)
                    .size(22.sp)
                    .color(Color(0xFF666666))
                    .overflow(TextOverflow.ellipsis)
                    .make(),
                21.hb,
                [
                  Spacer(),
                  Image.asset(
                    R.ASSETS_ICONS_HOT_FIRE_PNG,
                    height: 24.w,
                    width: 24.w,
                  ),
                  12.wb,
                  '${model.activityNum}'
                      .text
                      .maxLines(1)
                      .size(22.sp)
                      .overflow(TextOverflow.ellipsis)
                      .make()
                ].row(),
              ],
            ).box.make().expand(),
            12.wb,
            Hero(
              // tag: "${model.firstImg}_${model.id}",
              tag: model.hashCode.toString(),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  color: Colors.black12,
                ),
                child: Stack(
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                      image: API.image(ImgModel.first(model.imgUrl)),
                      height: 160.w,
                      width: 160.w,
                      fit: BoxFit.cover,
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   right: 0,
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.vertical(
                    //       bottom: Radius.circular(8.w),
                    //     ),
                    //     child: BackdropFilter(
                    //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    //       child: ('#${model.summary}')
                    //           .text
                    //           .center
                    //           .size(28.sp)
                    //           .white
                    //           .make()
                    //           .material(color: Colors.black26),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return  BeeScaffold(
      title: '所有话题'.text.color(ktextPrimary).size(32.sp).normal.make(),
      body:BeeListView<CommunityTopicModel>(
        path: API.community.topicList,
        controller: _refreshController,
        convert: (model) {
          return model.tableList!
              .map((e) => CommunityTopicModel.fromJson(e))
              .toList();
        },
        builder: (items) {
          return ListView.separated(
            padding: EdgeInsets.only(top: 20.w),
            itemBuilder: (context, index) {
              return _buildItem(items[index],index
              );
            },
            separatorBuilder: (_, __) => 20.hb,
            itemCount: items.length,
          );
        },
      ),
    );


  }

  @override
  bool get wantKeepAlive => true;
}
