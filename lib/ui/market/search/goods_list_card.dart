import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/models/search/search_goods_model.dart';
import 'package:aku_community/ui/market/collection/collection_func.dart';
import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';

import 'package:aku_community/utils/headers.dart';

import 'good_detail_page.dart';

class GoodsListCard extends StatefulWidget {
  final SearchGoodsModel model;
  final EasyRefreshController? refreshController;

  GoodsListCard({Key? key, required this.model, this.refreshController})
      : super(key: key);

  @override
  GoodsListCardState createState() => GoodsListCardState();
}

class GoodsListCardState extends State<GoodsListCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(() => GoodDetailPage(goodId: widget.model.id!,));
      },
      child: Container(
        height: 280.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.w),
            ),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(16.w),
              ),
              child: FadeInImage.assetNetwork(
                image: widget.model.mainPhoto ?? '',
                placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                height: 280.w,
                width: 280.w,
                fit: BoxFit.fill,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                    height: 280.w,
                    width: 280.w,
                  );
                },
              ),
            ),
            16.wb,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.hb,
                SizedBox(
                  width: 400.w,
                  child: Text(
                    widget.model.skuName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: ktextPrimary,
                    ),
                  ),
                ),
                5.hb,
                _getIcon(2),
                //_getIcon(model.kind??0),
                Spacer(),
                20.hb,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '¥',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 28.sp,
                        ),
                      ),
                      TextSpan(
                        text: '${widget.model.sellPrice ?? 0} ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 40.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '官方指导价：¥',
                                style: TextStyle(
                                  color: ktextSubColor,
                                  fontSize: 20.sp,
                                ),
                              ),
                              TextSpan(
                                text: '${widget.model.discountPrice ?? 0}',
                                style: TextStyle(
                                  color: ktextSubColor,
                                  fontSize: 20.sp,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '折扣：',
                                style: TextStyle(
                                  color: ktextSubColor,
                                  fontSize: 20.sp,
                                ),
                              ),
                              TextSpan(
                                text: (widget.model.discountPrice??0)>(widget.model.sellPrice??0)
                                    ? _getDiscount(widget.model.sellPrice ?? -1,
                                    widget.model.discountPrice ?? -1)
                                    : '暂无折扣',
                                style: TextStyle(
                                  color: ktextSubColor,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await CollectionFunc.collection(widget.model.id!);

                        if (widget.refreshController != null) {
                          widget.refreshController!.callRefresh();
                        }
                      },
                      child: (widget.model.isCollection ?? 0) != 0
                          ? Image.asset(
                              R.ASSETS_ICONS_SHOP_FAVORFILL_PNG,
                              width: 42.w,
                              height: 42.w,
                            )
                          : Image.asset(
                              R.ASSETS_ICONS_ICON_FAVOR_CHOOSE_PNG,
                              width: 42.w,
                              height: 42.w,
                            ),
                    ),
                    24.wb,
                  ],
                ),
                16.hb,
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }

  _getDiscount(double sellPrice, double discountPrice) {
    String count = '';
    count = ((sellPrice / discountPrice) * 10).toStringAsFixed(1);

    return count + '折';
  }

  Widget _getIcon(int type) {
    if (type == 1) {
      return Container(
        width: 86.w,
        height: 26.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4.w),
          ),
          gradient: LinearGradient(
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            colors: <Color>[Color(0xFFEC5329), Color(0xFFF58123)],
          ),
        ),
        child: Text(
          '京东自营',
          style: TextStyle(fontSize: 18.sp, color: kForeGroundColor),
        ),
      );
    } else if (type == 2) {
      return Container(
        alignment: Alignment.center,
        width: 86.w,
        height: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4.w),
          ),
          gradient: LinearGradient(
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            colors: <Color>[Color(0xFFF59B1C), Color(0xFFF5AF16)],
          ),
        ),
        child: Text(
          '京东POP',
          style: TextStyle(fontSize: 18.sp, color: kForeGroundColor),
        ),
      );
    } else
      return SizedBox();
  }


}
