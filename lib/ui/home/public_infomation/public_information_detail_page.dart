import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/news/news_detail_model.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '公共资讯',
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
                      .size(36.sp)
                      .color(ktextPrimary)
                      .bold
                      .align(TextAlign.center)
                      .make(),
                  24.w.heightBox,
                  SizedBox(
                    width: double.infinity,
                    child: _detailModel.content.text
                        .size(28.sp)
                        .color(ktextPrimary)
                        .make(),
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