import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:akuCommunity/utils/screenutil.dart';
import 'package:akuCommunity/routers/page_routers.dart';
import 'package:akuCommunity/model/aku_shop_model.dart';
import 'package:akuCommunity/widget/cached_image_wrapper.dart';

class SliverGoodsCard extends StatelessWidget {
  final bool isShow;
  final List<AkuShopModel> shoplist;
  const SliverGoodsCard({Key key, this.isShow = false, this.shoplist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Row _rowTag() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.w,
              ),
              color: Color(0xff000000).withOpacity(0.6),
              child: Text(
                '剩余时间:09天13时46分',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xffffffff), fontSize: 20.sp),
              ),
            ),
          ),
        ],
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context, PageName.goods_details_page.toString(),
                  arguments: Bundle()
                    ..putString(
                        'shoplist', json.encode(shoplist[index]).toString()));
            },
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        child: CachedImageWrapper(
                          url: shoplist[index].itempic,
                          width: 333.w,
                          height: 344.w,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 25.w,
                      top: 20.w,
                    ),
                    child: Container(
                      width: 296.w,
                      child: Text(
                        shoplist[index].itemtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Color(0xff4a4b51),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20.w,
                      left: 12.w,
                      right: 8.w,
                      bottom: 17.w,
                    ),
                    child: Row(
                      mainAxisAlignment: isShow
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          child: Text(
                            '￥${shoplist[index].itemprice}',
                            style: TextStyle(
                              color: Color(0xffe60e0e),
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        isShow
                            ? Text(
                                '${shoplist[index].itemsale}人已付款',
                                style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 20.w,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      PageName.goods_details_page.toString(),
                                      arguments: Bundle()
                                        ..putString(
                                            'shoplist',
                                            json
                                                .encode(shoplist[index])
                                                .toString()));
                                },
                                child: Container(
                                  width: 134.w,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                    top: 6.w,
                                    bottom: 5.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffc40c),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.w)),
                                  ),
                                  child: Text(
                                    '立即购买',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: Color(0xff333333),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: shoplist.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 30.w,
          crossAxisSpacing: 20.w,
          childAspectRatio: 343.w / 539.w),
    );
  }
}
