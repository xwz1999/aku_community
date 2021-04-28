import 'package:aku_community/ui/market/_market_data.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/tab_bar/bee_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarketPage extends StatefulWidget {
  MarketPage({Key? key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaWidth = MediaQuery.of(context).size.width;
    print({
      'height': MediaQuery.of(context).size.height,
      'width': MediaQuery.of(context).size.width,
    });
    return BeeScaffold(
      title: '商城',
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              //AppBar top Widget height
              //bottom height: 48
              // flexibleSpace的高为 (设备宽 - 边距)/4*2 + 外边距 + bottom高
              expandedHeight: (mediaWidth - 32.w * 2) / 4 * 2 + 16.w * 2 + 48,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Color(0xFFF9F9F9),
                  padding: EdgeInsets.only(
                    top: 16.w,
                    left: 32.w,
                    right: 32.w,
                    bottom: 16.w + 48, //底部边距需要加上bottom高
                  ),
                  child: Material(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(8.w),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                      ),
                      shrinkWrap: true,
                      children: mockableMarketData
                          .map((e) => MockableMarketWidget(data: e))
                          .toList(),
                    ),
                  ),
                ),
              ),
              pinned: true,
              toolbarHeight: 0,
              bottom: PreferredSize(
                child: Material(
                  color: Color(0xFFF9F9F9),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BeeTabBar(
                      scrollable: true,
                      controller: _tabController,
                      tabs: ['社区商城', '二手市场'],
                    ),
                  ),
                ),
                preferredSize: Size.fromHeight(48),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            MockableMarketList(),
            MockableMarketList(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
