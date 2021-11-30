import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/tab_bar/bee_tab_bar.dart';
import 'order_view.dart';

class OrderPage extends StatefulWidget {
  final int initIndex;
  OrderPage({Key? key, required this.initIndex}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _tabs = [
    '全部',
    '待付款',
    '待发货',
    '待收货',
    '已完成'
  ];

  @override
  void initState() {
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initIndex,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int? _transIndes(int index) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return 0;
      case 2:
        return 2;
      case 3:
        return 4;
      case 4:
        return 5;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '我的订单',
      appBarBottom: PreferredSize(
        preferredSize: Size.fromHeight(60.w),
        child: BeeTabBar(
            scrollable: true, controller: _tabController, tabs: _tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          _tabs.length,
          (index) => OrderView(
            index: _transIndes(index),
          ),
        ),
      ),
    );
  }
}
