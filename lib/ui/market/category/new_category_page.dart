import 'package:aku_community/model/good/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/models/market/market_category_model.dart';
import 'package:aku_community/ui/market/category/category_sub_view.dart';
import 'package:aku_community/ui/market/search/search_goods_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';

import 'new_category_sub_view.dart';

class NewCategoryPage extends StatefulWidget {
  final List<CategoryModel> models;
  final int index;
  NewCategoryPage({Key? key, required this.models, required this.index}) : super(key: key);

  @override
  _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage>
    with TickerProviderStateMixin {
  int _index = 0;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _index=widget.index;
    _tabController = TabController(length: widget.models.length, vsync: this,initialIndex: widget.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '分类',
      // actions: [
      //   IconButton(
      //     icon: Icon(CupertinoIcons.search),
      //     onPressed: () {
      //       Get.to(() => SearchGoodsPage());
      //     },
      //   ),
      // ],
      bgColor: Colors.white,
      appBarBottom: PreferredSize(
        child: Divider(height: 1),
        preferredSize: Size.fromHeight(1),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 203.w,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                bool sameIndex = index == _index;
                final item = widget.models[index];
                return Stack(
                  children: [
                    MaterialButton(
                      height: 100.w,
                      minWidth: double.infinity,
                      onPressed: () {
                        _index = index;
                        _tabController.animateTo(index);
                        setState(() {});
                      },
                      child: Text(
                        item.name??'',
                        style: TextStyle(
                          color: sameIndex ? kPrimaryColor : ktextPrimary,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      left: sameIndex ? 0 : -8.w,
                      top: sameIndex ? 20.w : 30.w,
                      bottom: sameIndex ? 20.w : 30.w,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      child: Container(
                        color: kPrimaryColor,
                        width: 8.w,
                        height: 40.w,
                      ),
                    ),
                  ],
                );
              },
              itemCount: widget.models.length,
            ),
          ),
          VerticalDivider(
            color: Color(0xFFE8E8E8),
            width: 1,
            thickness: 1,
          ),
          TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children:
                widget.models.map((e) => NewCategorySubView(model: e)).toList(),
          ).expand(),
        ],
      ),
    );
  }
}
