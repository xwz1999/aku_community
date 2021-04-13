import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:akuCommunity/constants/api.dart';
import 'package:akuCommunity/model/common/img_model.dart';
import 'package:akuCommunity/model/community/event_item_model.dart';
import 'package:akuCommunity/provider/user_provider.dart';
import 'package:akuCommunity/ui/community/community_views/event_detail_page.dart';
import 'package:akuCommunity/ui/community/community_views/widgets/send_a_chat.dart';
import 'package:akuCommunity/utils/bee_date_util.dart';
import 'package:akuCommunity/utils/headers.dart';
import 'package:akuCommunity/utils/login_util.dart';
import 'package:akuCommunity/utils/network/net_util.dart';
import 'package:akuCommunity/widget/picker/bee_image_preview.dart';
import 'package:akuCommunity/widget/views/bee_grid_image_view.dart';

class ChatCard extends StatefulWidget {
  final EventItemModel model;

  final VoidCallback onDelete;

  final bool hideLine;
  final bool canTap;

  ChatCard({
    Key key,
    @required this.model,
    this.onDelete,
    this.hideLine = false,
    this.canTap = true,
  }) : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool get _isMyself {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return (userProvider?.userInfoModel?.id ?? -1) == widget.model.createId;
  }

  _renderImage() {
    if (widget.model.imgUrls.isEmpty) return SizedBox();
    if (widget.model.imgUrls.length == 1)
      return MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        minWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
        ),
        onPressed: () {
          BeeImagePreview.toPath(
            path: ImgModel.first(widget.model.imgUrls),
            tag: ImgModel.first(widget.model.imgUrls),
          );
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 300.w,
            maxWidth: 300.w,
          ),
          child: Hero(
            tag: ImgModel.first(widget.model.imgUrls),
            child: FadeInImage.assetNetwork(
              placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
              image: API.image(ImgModel.first(widget.model.imgUrls)),
            ),
          ),
        ),
      );
    else
      return BeeGridImageView(
          urls: widget.model.imgUrls.map((e) => e.url).toList());
  }

  _buildMoreButton() {
    return Builder(builder: (context) {
      final userProvider = Provider.of<UserProvider>(context);
      return MaterialButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.w),
        ),
        padding: EdgeInsets.zero,
        height: 40.w,
        minWidth: 0,
        color: Color(0xFFD8D8D8),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          if (LoginUtil.isNotLogin) return;
          BotToast.showAttachedWidget(
            targetContext: context,
            preferDirection: PreferDirection.leftCenter,
            attachedBuilder: (cancel) {
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Material(
                  color: Color(0xFFD8D8D8),
                  borderRadius: BorderRadius.circular(8.w),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    height: 78.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MaterialButton(
                          height: 78.w,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () async {
                            cancel();
                            await NetUtil().get(
                              API.community.like,
                              params: {'themeId': widget.model.id},
                              showMessage: true,
                            );
                            setState(() {
                              if (widget.model.isLike == 0) {
                                widget.model.likeNames.add(
                                  LikeNames(
                                    id: Random().nextInt(1000),
                                    name: userProvider.userInfoModel.nickName,
                                  ),
                                );
                              } else {
                                widget.model.likeNames.removeWhere((element) =>
                                    element.name ==
                                    userProvider.userInfoModel.nickName);
                              }
                              widget.model.isLike =
                                  (widget.model.isLike == 1) ? 0 : 1;
                            });
                          },
                          child: [
                            widget.model.isLike == 1
                                ? Icon(Icons.favorite,
                                    size: 30.w, color: Colors.red)
                                : Icon(Icons.favorite_border, size: 30.w),
                            10.wb,
                            '赞'.text.make(),
                          ].row(),
                        ),
                        VerticalDivider(width: 1.w, thickness: 1.w),
                        MaterialButton(
                          height: 78.w,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            if (widget.model.isComment == 1)
                              SendAChat.send(
                                parentId: 0,
                                themeId: widget.model.id,
                              );
                            else
                              BotToast.showText(text: '不可评论');
                          },
                          child: [
                            Icon(CupertinoIcons.bubble_right, size: 30.w),
                            10.wb,
                            '评论'.text.make(),
                          ].row(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Row(
          children: [
            20.wb,
            Container(
              height: 8.w,
              width: 8.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.w),
              ),
            ),
            8.wb,
            Container(
              height: 8.w,
              width: 8.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.w),
              ),
            ),
            20.wb,
          ],
        ),
      );
    });
  }

  _renderLike() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Icon(Icons.favorite_border_rounded, size: 24.w),
          14.wb,
          ...widget.model.likeNames
              .map((e) => e.name.text.make())
              .toList()
              .sepWidget(separate: ','.text.make()),
        ],
      ),
    );
  }

  _renderComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.model.gambitThemeCommentVoList.map((e) {
        StringBuffer buffer = StringBuffer();
        buffer.write(e.createName);
        if (e.parentName != null) buffer.write('回复${e.parentName}');
        buffer.write(':${e.content}');
        return InkWell(
          child: Text(
            buffer.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          onTap: () {
            SendAChat.send(parentId: e.id, themeId: widget.model.id);
          },
        );
      }).toList(),
    );
  }

  _renderLikeAndComment() {
    if (widget.model.likeNames.isEmpty &&
        widget.model.gambitThemeCommentVoList.isEmpty) return SizedBox();
    return Material(
      borderRadius: BorderRadius.circular(8.w),
      color: Color(0xFFF7F7F7),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.model.likeNames.isEmpty ? SizedBox() : _renderLike(),
            (widget.model.likeNames.isNotEmpty &&
                    widget.model.gambitThemeCommentVoList.isNotEmpty)
                ? Divider(height: 1.w, thickness: 1.w)
                : SizedBox(),
            widget.model.gambitThemeCommentVoList.isEmpty
                ? SizedBox()
                : _renderComment(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: widget.hideLine
                ? Colors.transparent
                : Color(0xFFE5E5E5).withOpacity(0.5),
          ),
        ),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: widget.canTap
            ? () {
                Get.to(() => EventDetailPage(themeId: widget.model.id));
              }
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(6.w),
              clipBehavior: Clip.antiAlias,
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                image:
                    API.image(ImgModel.first(widget.model.headSculptureImgUrl)),
                height: 86.w,
                width: 86.w,
                fit: BoxFit.cover,
              ),
            ),
            24.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                [
                  widget.model.createName.text.black
                      .size(36.sp)
                      .make()
                      .expand(),
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.w)),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: '举报'.text.isIntrinsic.make(),
                          value: 0,
                        ),
                      ];
                    },
                    onSelected: (_) async {
                      if (LoginUtil.isNotLogin) return;
                      VoidCallback cancel = BotToast.showLoading();
                      await Future.delayed(
                          Duration(milliseconds: 500 + Random().nextInt(500)));
                      cancel();
                      BotToast.showText(text: '举报成功');
                    },
                  ),
                ].row(),
                6.hb,
                widget.model.content.text.size(32.sp).black.make(),
                20.hb,
                _renderImage(),
                widget.model.gambitTitle?.isEmpty ?? true
                    ? SizedBox()
                    : Chip(
                        label: '#${widget.model.gambitTitle}'
                            .text
                            .size(22.sp)
                            .make(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 5.w),
                        labelPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shape: StadiumBorder(
                          side: BorderSide(),
                        ),
                      ).pOnly(top: 10.w),
                Row(
                  children: [
                    64.hb,
                    BeeDateUtil(widget.model.date)
                        .timeAgo
                        .text
                        .size(28.sp)
                        .color(Color(0xFF999999))
                        .make(),
                    _isMyself
                        ? TextButton(
                            onPressed: () async {
                              bool result =
                                  await Get.dialog(CupertinoAlertDialog(
                                title: '你确定删除吗'.text.isIntrinsic.make(),
                                actions: [
                                  CupertinoDialogAction(
                                    child: '取消'.text.black.isIntrinsic.make(),
                                    onPressed: () => Get.back(),
                                  ),
                                  CupertinoDialogAction(
                                    child: '确定'
                                        .text
                                        .color(Colors.orange)
                                        .isIntrinsic
                                        .make(),
                                    onPressed: () => Get.back(result: true),
                                  ),
                                ],
                              ));

                              if (result == true) {
                                await NetUtil().get(
                                  API.community.deleteMyEvent,
                                  params: {'themeId': widget.model.id},
                                  showMessage: true,
                                );
                                if (widget.onDelete != null) widget.onDelete();
                              }
                            },
                            child: '删除'.text.black.size(28.sp).make(),
                          )
                        : SizedBox(),
                    Spacer(),
                    _buildMoreButton(),
                  ],
                ),
                _renderLikeAndComment(),
              ],
            ).expand(),
          ],
        ).p(20.w),
      ),
    );
  }
}
