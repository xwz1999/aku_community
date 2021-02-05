// Flutter imports:
import 'package:akuCommunity/model/community/event_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

// Project imports:
import 'package:akuCommunity/constants/api.dart';
import 'package:akuCommunity/model/common/img_model.dart';
import 'package:akuCommunity/provider/user_provider.dart';
import 'package:akuCommunity/ui/community/community_views/event_detail_page.dart';
import 'package:akuCommunity/utils/bee_date_util.dart';
import 'package:akuCommunity/utils/headers.dart';
import 'package:akuCommunity/utils/network/net_util.dart';
import 'package:akuCommunity/widget/picker/bee_image_preview.dart';
import 'package:akuCommunity/widget/views/bee_grid_image_view.dart';

class ChatCard extends StatefulWidget {
  final String name;
  final String topic;
  final List<ImgModel> headImg;
  final List<ImgModel> contentImg;
  final DateTime date;
  final bool initLike;
  final String content;

  ///userID
  final int id;

  final int themeId;

  final VoidCallback onDelete;

  final List<GambitThemeCommentVoList> comments;
  final List<LikeNames> likeNames;

  final bool hideLine;
  final bool canTap;

  ChatCard({
    Key key,
    @required this.name,
    @required this.topic,
    @required this.headImg,
    @required this.contentImg,
    @required this.date,
    @required this.initLike,
    @required this.id,
    @required this.content,
    @required this.themeId,
    this.onDelete,
    @required this.comments,
    this.hideLine = false,
    @required this.likeNames,
    this.canTap = true,
  }) : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool _like = false;

  bool get _isMyself {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return (userProvider?.userInfoModel?.id ?? -1) == widget.id;
  }

  String get firstHead {
    if (widget.headImg == null || widget.headImg.isEmpty)
      return '';
    else
      return widget.headImg.first.url;
  }

  _renderImage() {
    if (widget.contentImg.isEmpty) return SizedBox();
    if (widget.contentImg.length == 1)
      return MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
        ),
        onPressed: () {
          Get.to(
            BeeImagePreview.path(path: widget.contentImg.first.url),
            opaque: false,
          );
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 300.w,
            maxWidth: 300.w,
          ),
          child: Hero(
            tag: widget.contentImg.first.url,
            child: FadeInImage.assetNetwork(
              placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
              image: API.image(widget.contentImg.first.url),
            ),
          ),
        ),
      );
    else
      return BeeGridImageView(
          urls: widget.contentImg.map((e) => e.url).toList());
  }

  _buildMoreButton() {
    return Builder(builder: (context) {
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
                              params: {'themeId': widget.themeId},
                              showMessage: true,
                            );
                            setState(() {
                              _like = !_like;
                            });
                          },
                          child: [
                            _like
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
                          onPressed: () {},
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
          ...widget.likeNames
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
      children: widget.comments.map((e) {
        StringBuffer buffer = StringBuffer();
        buffer.write(e.createName);
        if (e.parentName != null) buffer.write('回复${e.parentName}');
        buffer.write(':${e.content}');
        return InkWell(
          child: buffer.toString().text.make(),
          onTap: () {},
        );
      }).toList(),
    );
  }

  addComment() {}

  _renderLikeAndComment() {
    return Material(
      borderRadius: BorderRadius.circular(8.w),
      color: Color(0xFFF7F7F7),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.likeNames.isEmpty ? SizedBox() : _renderLike(),
            (widget.likeNames.isNotEmpty && widget.comments.isNotEmpty)
                ? Divider(height: 1.w, thickness: 1.w)
                : SizedBox(),
            widget.comments.isEmpty ? SizedBox() : _renderComment(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _like = widget.initLike ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: widget.hideLine ? Colors.transparent : Color(0xFFE5E5E5),
          ),
        ),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: widget.canTap
            ? () {
                Get.to(EventDetailPage(themeId: widget.themeId));
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
                image: API.image(firstHead),
                height: 86.w,
                width: 86.w,
              ),
            ),
            24.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.name.text.black.size(36.sp).make(),
                6.hb,
                widget.content.text.black.make(),
                20.hb,
                _renderImage(),
                widget.topic?.isEmpty ?? true
                    ? SizedBox()
                    : Chip(
                        label: '#${widget.topic}'.text.size(22.sp).make(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 5.w),
                        labelPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shape: StadiumBorder(
                          side: BorderSide(),
                        ),
                      ),
                Row(
                  children: [
                    64.hb,
                    BeeDateUtil(widget.date)
                        .timeAgo
                        .text
                        .size(28.sp)
                        .color(Color(0xFF999999))
                        .make(),
                    _isMyself
                        ? FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            height: 48.w,
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
                                  params: {'themeId': widget.themeId},
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
