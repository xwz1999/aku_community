import 'package:flutter/material.dart';

import 'package:aku_community/ui/home/public_infomation/public_infomation_view.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/tab_bar/bee_tab_bar.dart';

class PublicInfomationPage extends StatefulWidget {
  PublicInfomationPage({Key? key}) : super(key: key);

  @override
  _PublicInfomationPageState createState() => _PublicInfomationPageState();
}

class _PublicInfomationPageState extends State<PublicInfomationPage>
    with TickerProviderStateMixin {
  static const pubTabs = <String>['全部', '政务', '生活', '医疗', '教育'];
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pubTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '公共资讯',
      appBarBottom: BeeTabBar(controller: _tabController, tabs: pubTabs),
      body: PublicInfomationView(),
    );
  }
}
