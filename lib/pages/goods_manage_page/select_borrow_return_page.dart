import 'package:akuCommunity/pages/goods_manage_page/goods_manage_page.dart';
import 'package:akuCommunity/widget/bee_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:akuCommunity/const/resource.dart';
import 'package:akuCommunity/extensions/widget_list_ext.dart';

class SelectBorrowReturnPage extends StatefulWidget {
  SelectBorrowReturnPage({Key key}) : super(key: key);

  @override
  _SelectBorrowReturnPageState createState() => _SelectBorrowReturnPageState();
}

class _SelectBorrowReturnPageState extends State<SelectBorrowReturnPage> {
  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '借还管理',
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 36.w),
        children: [
          _buidTile(R.ASSETS_ICONS_GOODS_BORROW_PNG, '物品出借', true),
          _buidTile(R.ASSETS_ICONS_GOODS_RETURN_PNG, '物品归还', false),
        ].sepWidget(separate: 20.w.heightBox),
      ),
    );
  }

  Widget _buidTile(String iconPath, String text, bool isBorrow) {
    return Row(
      children: [
        SizedBox(
          width: 32.w,
          height: 32.w,
          child: Image.asset(iconPath),
        ),
        28.w.widthBox,
        text.text.black.size(30.sp).make(),
        Spacer(),
        Icon(
          CupertinoIcons.chevron_forward,
          size: 32.w,
        ),
      ],
    )
        .box
        .color(Colors.white)
        .padding(EdgeInsets.symmetric(vertical: 40.w, horizontal: 32.w))
        .withRounded(value: 8.w)
        .make()
        .onInkTap(() {
      Get.to(
        () => GoodsManagePage(
          isBorrow: isBorrow,
        ),
      );
    });
  }
}
