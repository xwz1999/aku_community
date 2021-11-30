import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/models/collection/collection_goods_model.dart';
import 'package:aku_community/models/search/search_goods_model.dart';
import 'package:aku_community/ui/market/collection/collection_func.dart';
import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';

import 'package:aku_community/utils/headers.dart';

class CollectionListCard extends StatelessWidget {
  final CollectionGoodsModel model;
  final EasyRefreshController refreshController;
  const CollectionListCard({Key? key, required this.model, required this.refreshController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 280.w,
        margin: EdgeInsets.only(top: 20.w),
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
                image: model.mainPhoto ?? '',
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
                    model.skuName ?? '',
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
                          text: '${model.sellPrice ?? 0} ',
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
                                text: '${model.discountPrice ?? 0}',
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
                                text: (model.discountPrice??0)>(model.sellPrice??0)
                                    ? _getDiscount(model.sellPrice ?? -1,
                                        model.discountPrice ?? -1)
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
                    Row(
                      children: [
                        // GestureDetector(
                        //   child: Image.asset(R.ASSETS_ICONS_COLLECTION_SHARE_PNG,width: 44.w,height: 44.w,),
                        //   onTap: (){
                        //
                        //   },
                        // ),
                        // 24.wb,
                        GestureDetector(
                          onTap: () async {
                            await CollectionFunc.collection(model.id!);


                              refreshController.callRefresh();

                          },
                          child:Image.asset(
                            R.ASSETS_ICONS_DELETE_PNG,
                            width: 44.w,
                            height: 44.w,
                          )
                        ),
                      ],
                    ),
                    44.wb,
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
