import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/community/activity_item_model.dart';
import 'package:aku_community/ui/community/activity/activity_detail_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/others/stack_avatar.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItemModel? model;

  const ActivityCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  bool get outdate => model!.end!.compareTo(DateTime.now()) == -1;

  Widget build(BuildContext context) {
    return MaterialButton(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      padding: EdgeInsets.zero,
      onPressed: () => Get.to(() => ActivityDetailPage(id: model!.id)),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.w),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: ImgModel.first(model!.imgUrls),
            child: Material(
              color: Colors.grey,
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                image: API.image(ImgModel.first(model!.imgUrls)),
                height: 197.w,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 24.w, top: 24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 340.w),
                  child: Text(
                    model==null?'':model!.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(0xD9000000),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  child: Container(

                    //color: Color(0x80FEBF76),

                    // shape: StadiumBorder(),
                    alignment: Alignment.center,
                    height: 39.w,
                    width: 98.w,
                    decoration: BoxDecoration(
                        color: outdate ? Color(0xFFABABAB) : Color(0x80FEBF76),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),

                    child: outdate
                        ? '?????????'
                            .text
                            .size(22.sp)
                            .color(Color(0xFF666666))

                            .make()
                        : '?????????'
                            .text
                            .size(22.sp)
                            .color(Color(0xFFF48117))

                            .make(),
                  ),
                  onTap: () {
                    outdate
                        ? null
                        : () {
                            Get.to(() => ActivityDetailPage(id: model!.id));
                          };
                  },
                ),
              24.wb
              ],
            ),
          ),
          // [
          //   '???        ???:'.text.size(24.sp).color(Color(0xFF999999)).make(),
          //   model!.location!.text.size(24.sp).make(),
          // ].row().pSymmetric(h: 24.w),
          20.hb,
          [
            '???????????????'.text.size(22.sp).color(Color(0x73000000)).make(),
            '${DateUtil.formatDate(
              model!.end,
              format: 'yyyy???MM???dd??? HH:mm',
            )}'
                .text
                .size(22.sp)
                .color(Color(0x73000000))
                .make(),
          ].row().pSymmetric(h: 24.w),
          // [
          //   // StackAvatar(
          //   //     avatars: model!.headImgURls!.map((e) => e.url).toList()),
          //   Spacer(),
          //   MaterialButton(
          //     elevation: 0,
          //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //     color: Color(0xFFFFC40C),
          //     shape: StadiumBorder(),
          //     height: 44.w,
          //     minWidth: 120.w,
          //     disabledColor: Color(0xFFABABAB),
          //     onPressed: outdate
          //         ? null
          //         : () {
          //             Get.to(() => ActivityDetailPage(id: model!.id));
          //           },
          //     child: outdate
          //         ? '?????????'.text.size(20.sp).bold.make()
          //         : '?????????'.text.size(20.sp).bold.make(),
          //   ),
          // ].row().p(24.w),
        ],
      ),
    );
  }
}
