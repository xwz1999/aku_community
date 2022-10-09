import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/constants/app_theme.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/community/community_topic_model.dart';
import 'package:aku_community/model/community/event_item_model.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/ui/community/community_views/add_new_event_page.dart';
import 'package:aku_community/ui/community/community_views/topic/topic_sliver_header.dart';
import 'package:aku_community/ui/community/community_views/widgets/chat_card.dart';
import 'package:aku_community/utils/login_util.dart';

class TopicDetailPage extends StatefulWidget {
  final CommunityTopicModel? model;

  TopicDetailPage({Key? key, this.model}) : super(key: key);

  @override
  _TopicDetailPageState createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  EasyRefreshController _refreshController = EasyRefreshController();
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemStyle.initial,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'event_add',
          onPressed: () async {
            if (LoginUtil.isNotLogin) return;
            await Get.to(() => AddNewEventPage.topic(
                  topicName: widget.model!.summary,
                  initTopic: widget.model!.id,
                ));
          },
          child: Icon(Icons.add),
        ),
        body: BeeListView(
          convert: (model) {
            return model.tableList!
                .map((e) => EventItemModel.fromJson(e))
                .toList();
          },
          path: API.community.eventByTopicId,
          extraParams: {'gambitId': widget.model!.id,'orderBy':1},
          controller: _refreshController,
          builder: (items) {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: TopicSliverHeader(
                    id: widget.model!.id,
                    title: widget.model!.summary,
                    imgPath: ImgModel.first(widget.model!.imgUrl),
                    subTitle: widget.model!.content,
                  ),
                  pinned: true,
                  floating: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index] as EventItemModel;
                      return ChatCard(
                        model: item,
                        onDelete: () {
                          _refreshController.callRefresh();
                        },
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
