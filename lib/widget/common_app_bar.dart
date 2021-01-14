import 'package:akuCommunity/pages/address_page/address_edit_page.dart';
import 'package:akuCommunity/pages/goods_manage_page/mine_goods_page/mine_goods_page.dart';
import 'package:akuCommunity/pages/life_pay/life_pay_record_page/life_pay_record_page.dart';
import 'package:akuCommunity/pages/things_page/things_evaluate_page/things_evaluate_page.dart';
import 'package:akuCommunity/pages/visitor_access_page/visitor_record_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:akuCommunity/utils/headers.dart';
import 'package:akuCommunity/routers/page_routers.dart';
import 'package:akuCommunity/pages/one_alarm/widget/explain_template.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget {
  final String title, subtitle;
  final List<Map<String, dynamic>> treeList;
  final TabController tabController;
  const CommonAppBar({
    Key key,
    @required this.title,
    this.subtitle,
    this.treeList,
    this.tabController,
  }) : super(key: key);

  void showExplain(BuildContext context) {
    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => ExplainTemplate(options),
    );
    popup.show(
        title: Text(
          '功能说明',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32.sp,
            color: Color(0xff15c0ec),
          ),
        ),
        content: Text(
          '点击“呼叫110”后,您可以直接拨打本地110。页面中提供了您当前所在位置,以便您与警方沟通。(GPS信号弱时，位置可能存在偏移)',
          style: TextStyle(
            fontSize: 28.sp,
            color: Color(0xff666666),
          ),
        ),
        actions: [
          MaterialButton(
            color: Color(0xff15c0ec),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Text('关闭'),
            onPressed: Navigator.of(context).pop,
          )
        ],
        close: SizedBox());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        elevation: 0,
        backgroundColor: (title == '访客通行证' || title == '出户二维码')
            ? Color(0xff333333)
            : Colors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            AntDesign.left,
            size: 45.sp,
            color: (title == '访客通行证' || title == '出户二维码')
                ? Colors.white
                : Color(0xff333333),
          ),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: (title == '访客通行证' || title == '出户二维码')
                ? Colors.white
                : Color(0xff333333),
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          subtitle != null
              ? InkWell(
                  onTap: () {
                    switch (subtitle) {
                      case '访客记录':
                        VisitorRecordPage().to;
                        break;
                      case '缴费记录':
                        LifePayRecordPage().to;
                        break;
                      case '我的借还物品':
                        MineGoodsPage().to;
                        break;
                      case '添加新地址':
                        AddressEditPage(
                          bundle: Bundle()
                            ..putMap('details',
                                {'title': '添加新地址', 'isDelete': false}),
                        ).to;
                        break;
                      case '功能说明':
                        showExplain(context);
                        break;
                      case '评价':
                        ThingsEvaluatePage(
                          bundle: Bundle()
                            ..putMap(
                                'details', {'title': '评价', 'isShow': true}),
                        ).to;
                        break;
                      default:
                    }
                  },
                  child: Container(
                    height: kToolbarHeight,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 32.w),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
        bottom: treeList != null
            ? TabBar(
                unselectedLabelStyle: TextStyle(
                  fontSize: 28.sp,
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28.sp,
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 131.5.w),
                indicatorColor: Color(0xffffc40c),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 21.w),
                isScrollable: true,
                controller: tabController,
                tabs: List.generate(
                  treeList.length,
                  (index) => Tab(text: treeList[index]['name']),
                ),
              )
            : PreferredSize(
                child: SizedBox(),
                preferredSize: Size.fromHeight(0),
              ),
      ),
    );
  }
}
