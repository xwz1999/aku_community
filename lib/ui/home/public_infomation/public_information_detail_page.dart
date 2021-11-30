import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/news/news_detail_model.dart';
import 'package:aku_community/utils/link_text_parase.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';

class PublicInformationDetailPage extends StatefulWidget {
  final int id;
  PublicInformationDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _PublicInformationDetailPageState createState() =>
      _PublicInformationDetailPageState();
}

class _PublicInformationDetailPageState
    extends State<PublicInformationDetailPage> {
  late EasyRefreshController _easyRefreshController;
  bool _onload = true;
  late NewsDetailModel _detailModel;
  late List<String> _parasedText;
  late TapGestureRecognizer _tapLinkUrlLancher; //设置单击手势识别器
  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    _tapLinkUrlLancher = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    _tapLinkUrlLancher.dispose(); //释放手势识别器资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      leading:Navigator.canPop(context)
          ? IconButton(
        onPressed: () => Get.back(result: true),
        icon: Icon(
          CupertinoIcons.chevron_back,
          color: Colors.black,
        ),
      )
          : SizedBox(),
      title: _onload ? '' : _detailModel.newsCategoryName,
      bodyColor: Colors.white,
      body: EasyRefresh(
        firstRefresh: true,
        header: MaterialHeader(),
        onRefresh: () async {
          BaseModel baseModel = await NetUtil()
              .get(API.manager.getPublicInformationDetail, params: {
            "newsId": widget.id,
          });
          if (baseModel.status! && baseModel.data != null) {
            _detailModel = NewsDetailModel.fromJson(baseModel.data);
            _parasedText = LinkTextParase.stringParase(_detailModel.content);
          } else {
            BotToast.showText(text: '无法获取信息');
          }
          _onload = false;
          setState(() {});
        },
        child: _onload
            ? _emptyWidget()
            : ListView(
                padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
                children: [
                  _detailModel.title.text
                      .size(32.sp)
                      .color(ktextPrimary)
                      .bold
                      .align(TextAlign.center)
                      .make(),
                  24.w.heightBox,
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      text: TextSpan(
                          children: List.generate(_parasedText.length, (index) {
                        if (index.isEven) {
                          return TextSpan(
                            text: _parasedText[index],
                            style:
                                TextStyle(fontSize: 28.sp, color: ktextPrimary),
                          );
                        } else {
                          return TextSpan(
                              text: _parasedText[index],
                              style: TextStyle(
                                fontSize: 28.sp,
                                color: Colors.lightBlue,
                              ),
                              recognizer: _tapLinkUrlLancher
                                ..onTap = () {
                                  launch(_parasedText[index]);
                                });
                        }
                      })),
                    ),
                  ),
                  40.w.heightBox,
                  Row(
                    children: [
                      Spacer(),
                      '发布于 ${DateUtil.formatDateStr(_detailModel.createDate, format: 'MM-dd HH:mm')}'
                          .text
                          .size(24.sp)
                          .color(ktextSubColor)
                          .make(),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Widget _emptyWidget() {
    return Container();
  }
}
