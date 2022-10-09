import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:get/get.dart';

import 'package:aku_community/pages/renovation_manage/new_renovation/new_renovation_add_page.dart';
import 'package:aku_community/pages/renovation_manage/new_renovation/new_renovation_view.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/tab_bar/bee_tab_bar.dart';

class NewRenovationPage extends StatefulWidget {
  NewRenovationPage({Key? key}) : super(key: key);

  @override
  _NewRenovationPageState createState() => _NewRenovationPageState();
}

class _NewRenovationPageState extends State<NewRenovationPage>
    with TickerProviderStateMixin {
  late EasyRefreshController _refreshController;
  List<String> _tabs = [
    '申请中',
    '装修中',
    '申请驳回',
    '申请完工检查',
    '完工检查中',
    '检查通过',
    '检查未通过'
  ];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '装修管理',
      appBarBottom: PreferredSize(
        preferredSize: Size.fromHeight(88.w),
        child: BeeTabBar(
          controller: _tabController,
          tabs: _tabs,
          scrollable: true,
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(
              CupertinoIcons.plus_circle,
              color: Colors.black,
            ),
            onPressed: () async {
              var back =
             await Get.to(() => NewRenovationAddPage());
              if(back!=null&&back){
                print('刷新触发');
                childKey.currentState!.callRefresh();
              }
            }),
      ],
      body: TabBarView(
        children: List.generate(_tabs.length, (index) => _getViews(index)),
        controller: _tabController,
      ),
    );
  }

  _getViews(index) {
    if (index > 2) {
      return NewRenovationView(
        index: index + 1, key: childKey,
      );
    } else {
      return NewRenovationView(
        index: index, key: childKey,
      );
    }
  }
}
