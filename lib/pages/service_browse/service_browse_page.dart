import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/service_browse/service_browse_list_mode.dart';
import 'package:aku_community/pages/service_browse/service_browse_detail_page.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceBrowsePage extends StatefulWidget {
  ServiceBrowsePage({Key? key}) : super(key: key);

  @override
  _ServiceBrowsePageState createState() => _ServiceBrowsePageState();
}

class _ServiceBrowsePageState extends State<ServiceBrowsePage> {
  late EasyRefreshController _easyRefreshController;
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
      title: '服务浏览',
      body: BeeListView(
          path: API.manager.serviceBrowseList,
          controller: _easyRefreshController,
          convert: (models) {
            return models.tableList!
                .map((e) => ServiceBrowseListModel.fromJson(e))
                .toList();
          },
          builder: (items) {
            return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.w),
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

  Widget _buildCard(ServiceBrowseListModel model) {
    return MaterialButton(
      onPressed: () {
        Get.to(() => ServiceBrowseDetailPage(
              model: model,
            ));
      },
      elevation: 0,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 32.w),
      minWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          model.name.text
              .size(32.sp)
              .color(ktextPrimary)
              .maxLines(1)
              .overflow(TextOverflow.ellipsis)
              .bold
              .make(),
          32.w.heightBox,
          model.content.text
              .size(24.sp)
              .color(ktextSubColor)
              .maxLines(3)
              .overflow(TextOverflow.ellipsis)
              .make(),
          32.w.heightBox,
          Row(
            children: [
              '${S.of(context)!.tempPlotName}'
                  .text
                  .size(20.sp)
                  .color(ktextSubColor)
                  .make(),
              Spacer(),
              '发布于 ${DateUtil.formatDateStr(model.createDate, format: 'MM-dd HH:mm')}'
                  .text
                  .size(20.sp)
                  .color(ktextSubColor)
                  .make(),
            ],
          ),
        ],
      ),
    );
  }
}
