// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:akuCommunity/model/community/hot_topic_model.dart';
import 'package:akuCommunity/provider/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

// Project imports:
import 'package:akuCommunity/base/base_style.dart';
import 'package:akuCommunity/constants/api.dart';
import 'package:akuCommunity/utils/headers.dart';
import 'package:akuCommunity/utils/network/base_model.dart';
import 'package:akuCommunity/utils/network/net_util.dart';
import 'package:akuCommunity/widget/picker/grid_image_picker.dart';

class AddNewEventPage extends StatefulWidget {
  AddNewEventPage({Key key}) : super(key: key);

  @override
  _AddNewEventPageState createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  bool _commentable = true;
  List<File> _files = [];
  TextEditingController _textEditingController = TextEditingController();
  HotTopicModel _hotTopicModel;

  ///发表动态
  _addEvent() async {
    VoidCallback cancel = BotToast.showLoading();
    final String content = _textEditingController.text;
    List<String> imgs;
    if (_files.isNotEmpty) {
      imgs = await NetUtil().uploadFiles(_files, API.upload.uploadEvent);
    }

    Map<String, dynamic> params = {
      'gambitId': _hotTopicModel == null ? -1 : _hotTopicModel.id,
      'content': content,
      'isComment': _commentable ? 1 : 0,
      'isPublic': 1,
      'imgUrls': imgs,
    };

    BaseModel baseModel = await NetUtil().post(
      API.community.addEvent,
      params: params,
      showMessage: true,
    );
    cancel();
    if (baseModel.status) {
      Get.back(result: true);
    }
  }

  _buildSelectable() {
    return MaterialButton(
      onPressed: () {
        setState(() {
          _commentable = !_commentable;
        });
      },
      height: 96.w,
      child: Row(
        children: [
          Icon(
            CupertinoIcons.bubble_left,
            size: 32.w,
          ),
          8.wb,
          '不可评论'.text.size(28.sp).make(),
          Spacer(),
          AnimatedOpacity(
            opacity: _commentable ? 0 : 1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: Icon(
              Icons.check_rounded,
              color: Colors.black,
              size: 40.w,
            ),
          ),
        ],
      ),
    );
  }

  _pickTopic() {
    final appProvider = Provider.of<AppProvider>(context);
    return Wrap(
      direction: Axis.horizontal,
      children: [
        '选择话题：'.text.black.size(34.sp).make(),
        ...appProvider.hotTopicModels
            .map((e) => _renderTopic(e))
            .toList()
            .sepWidget(separate: 20.wb),
      ],
    );
  }

  Widget _renderTopic(HotTopicModel model) {
    bool sameModel = model.id == _hotTopicModel?.id ?? -1;
    return MaterialButton(
      elevation: 0,
      color: sameModel ? kPrimaryColor : Colors.white,
      onPressed: () {
        _hotTopicModel = model;
        setState(() {});
      },
      child: model.name.text.size(34.sp).black.make(),
      shape: StadiumBorder(
        side: BorderSide(
          color: Color(0xFF999999),
          width: 1.w,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.updateHotTopicModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: Get.back,
          child: '取消'.text.size(34.sp).make(),
        ),
        leadingWidth: 108.w,
        centerTitle: true,
        title: '社区'.text.make(),
        actions: [
          Hero(
            tag: 'event_add',
            child: MaterialButton(
              elevation: 0,
              minWidth: 116.w,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.w),
              ),
              color: kPrimaryColor,
              onPressed: _addEvent,
              child: '发表'.text.size(34.sp).make(),
            ).centered(),
          ),
          32.wb,
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 32.w),
        children: [
          TextField(
            minLines: 3,
            maxLines: 99,
            controller: _textEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: '这一刻的想法',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 34.sp,
              ),
            ),
          ),
          GridImagePicker(onChange: (files) => _files = files),
          100.hb,
          Divider(height: 1.w),
          _buildSelectable(),
          Divider(height: 1.w),
          28.hb,
          _pickTopic(),
        ],
      ).material(color: Colors.white),
    );
  }
}
