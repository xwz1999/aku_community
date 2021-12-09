// // import 'package:aku_community/base/base_style.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:waterfall_flow/waterfall_flow.dart';
//
// import 'package:aku_community/constants/api.dart';
// import 'package:aku_community/models/market/display_category_model.dart';
// import 'package:aku_community/models/market/goods_item.dart';
// import 'package:aku_community/models/market/market_category_model.dart';
// import 'package:aku_community/ui/market/category/category_card.dart';
// import 'package:aku_community/ui/market/category/category_page.dart';
// import 'package:aku_community/ui/market/goods/goods_card.dart';
// import 'package:aku_community/ui/market/order/my_order_page.dart';
// import 'package:aku_community/ui/market/search/search_goods_page.dart';
// import 'package:aku_community/utils/headers.dart';
// import 'package:aku_community/utils/network/base_list_model.dart';
// import 'package:aku_community/utils/network/net_util.dart';
// import 'package:aku_community/widget/bee_scaffold.dart';
//
// // import 'package:aku_community/ui/market/goods/goods_detail_page.dart';
//
// // import 'package:aku_community/widget/tab_bar/bee_tab_bar.dart';
//
// class MarketPage111 extends StatefulWidget {
//   MarketPage111({Key? key}) : super(key: key);
//
//   @override
//   _MarketPageState createState() => _MarketPageState();
// }
//
// class _MarketPageState extends State<MarketPage111>
//     with AutomaticKeepAliveClientMixin {
//   List<MarketCategoryModel> _marketModels = [];
//   List<GoodsItem> _hotItems = [];
//   late EasyRefreshController _refreshController;
//   int _pageNum = 1;
//   int _size = 4;
//   int _pageCount = 0;
//
//   Future updateMarketInfo() async {
//     BaseListModel baseListModel =
//         await NetUtil().getList(API.market.hotTop, params: {
//       "pageNum": _pageNum,
//       "size": _size,
//     });
//     if (baseListModel.tableList!.isNotEmpty) {
//       _hotItems = (baseListModel.tableList as List)
//           .map((e) => GoodsItem.fromJson(e))
//           .toList();
//     }
//     _pageCount = baseListModel.pageCount!;
//   }
//
//   Future loadMarketInfo() async {
//     BaseListModel baseListModel =
//         await NetUtil().getList(API.market.hotTop, params: {
//       "pageNum": _pageNum,
//       "size": _size,
//     });
//     if (baseListModel.tableList!.isNotEmpty) {
//       _hotItems.addAll((baseListModel.tableList as List)
//           .map((e) => GoodsItem.fromJson(e))
//           .toList());
//     }
//     _pageCount = baseListModel.pageCount!;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshController = EasyRefreshController();
//     Future.delayed(Duration(milliseconds: 0), () async {
//       _marketModels = await DisplayCategoryModel.top8;
//       await updateMarketInfo();
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _refreshController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final mediaWidth = MediaQuery.of(context).size.width;
//     return BeeScaffold(
//       leading: IconButton(
//         icon: Icon(CupertinoIcons.search),
//         onPressed: () {
//           Get.to(() => SearchGoodsPage());
//         },
//       ),
//       title: '商城',
//       actions: [
//         MaterialButton(
//           minWidth: 108.w,
//           padding: EdgeInsets.zero,
//           onPressed: () async {
//             // Get.to(() => SecondHandPage());
//             Get.to(() => MyOrderPage());
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Image.asset(
//                 R.ASSETS_ICONS_SECOND_HAND_PNG,
//                 width: 48.w,
//                 height: 48.w,
//               ),
//               4.hb,
//               // '二手'.text.size(20.sp).black.make(),
//               '订单'.text.size(20.sp).black.make(),
//             ],
//           ),
//         ),
//         MaterialButton(
//           minWidth: 108.w,
//           padding: EdgeInsets.zero,
//           onPressed: () async {
//             final cancel = BotToast.showLoading();
//             List<MarketCategoryModel> models =
//                 await DisplayCategoryModel.fetchCategory(0);
//             cancel();
//             Get.to(() => CategoryPage(models: models));
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Image.asset(
//                 R.ASSETS_ICONS_CATEGORY_PNG,
//                 width: 48.w,
//                 height: 48.w,
//               ),
//               4.hb,
//               '分类'.text.size(20.sp).black.make(),
//             ],
//           ),
//         ),
//       ],
//       body:
//       NestedScrollView(
//         headerSliverBuilder: (context, value) {
//           var gridItems = Material(
//             color: Colors.white,
//             clipBehavior: Clip.antiAlias,
//             borderRadius: BorderRadius.circular(8.w),
//             child: GridView(
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 childAspectRatio: 1,
//               ),
//               shrinkWrap: true,
//               children:
//                   _marketModels.map((e) => CategoryCard(model: e)).toList(),
//             ),
//           );
//           return [
//             SliverAppBar(
//               //AppBar top Widget height
//               //bottom height: 48
//               // flexibleSpace的高为 (设备宽 - 边距)/4*2 + 外边距 + bottom高 + top热搜栏
//               // * 热搜栏
//               //expandedHeight:
//               //(mediaWidth - 32.w * 2) / 4 * 2 + 16.w * 2 + 48 + 68.w,
//               //
//               expandedHeight: (mediaWidth - 32.w * 2) / 4 * 2 + 16.w * 2,
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Container(
//                   color: Color(0xFFF9F9F9),
//                   padding: EdgeInsets.only(
//                     top: 16.w,
//                     left: 32.w,
//                     right: 32.w,
//                     bottom: 16.w, //底部边距需要加上bottom高
//                   ),
//                   child: Column(
//                     children: [
//                       // SizedBox(
//                       //   height: 58.w,
//                       //   child: Row(
//                       //     children: [
//                       //       Text(
//                       //         '热搜:',
//                       //         style: TextStyle(
//                       //           fontSize: 20.sp,
//                       //         ),
//                       //       ),
//                       //       20.wb,
//                       //       ListView.separated(
//                       //         scrollDirection: Axis.horizontal,
//                       //         separatorBuilder: (_, __) => 20.wb,
//                       //         itemBuilder: (context, index) {
//                       //           final item = _hotItems[index];
//                       //           return MaterialButton(
//                       //             padding:
//                       //                 EdgeInsets.symmetric(horizontal: 40.w),
//                       //             minWidth: 0,
//                       //             shape: StadiumBorder(
//                       //               side: BorderSide(
//                       //                 color: ktextSubColor,
//                       //                 width: 1,
//                       //               ),
//                       //             ),
//                       //             materialTapTargetSize:
//                       //                 MaterialTapTargetSize.shrinkWrap,
//                       //             onPressed: () {
//                       //               Get.to(() => GoodsDetailPage(id: item.id));
//                       //             },
//                       //             child: Text(
//                       //               item.title,
//                       //               style: TextStyle(
//                       //                 color: ktextSubColor,
//                       //               ),
//                       //             ),
//                       //           );
//                       //         },
//                       //         itemCount: _hotItems.length,
//                       //       ).expand(),
//                       //     ],
//                       //   ),
//                       // ),
//                       // 10.hb,
//                       gridItems.expand(),
//                     ],
//                   ),
//                 ),
//               ),
//               pinned: true,
//               toolbarHeight: 0,
//               // bottom: PreferredSize(
//               //   child: Material(
//               //     color: Color(0xFFF9F9F9),
//               //     child: Align(
//               //       alignment: Alignment.centerLeft,
//               //       child: BeeTabBar(
//               //         scrollable: true,
//               //         controller: _tabController,
//               //         tabs: ['社区商城', '二手市场'],
//               //       ),
//               //     ),
//               //   ),
//               //   preferredSize: Size.fromHeight(48),
//               // ),
//             ),
//           ];
//         },
//         body: EasyRefresh(
//           firstRefresh: false,
//           enableControlFinishLoad: false,
//           header: MaterialHeader(),
//           footer: MaterialFooter(),
//           controller: _refreshController,
//           onRefresh: () async {
//             _pageNum = 1;
//             await updateMarketInfo();
//             setState(() {});
//           },
//           onLoad: () async {
//             _pageNum++;
//             await loadMarketInfo();
//             if (_pageCount <= _pageNum) {
//               _refreshController.finishLoad(noMore: false);
//             }
//             setState(() {});
//           },
//           child: WaterfallFlow.builder(
//             gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 20.w,
//               crossAxisSpacing: 20.w,
//             ),
//             padding: EdgeInsets.all(32.w),
//             itemBuilder: (context, index) {
//               return SizedBox();
//               //final item = _hotItems[index];
//               // return GoodsCard(item: item);
//             },
//             itemCount: _hotItems.length,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
