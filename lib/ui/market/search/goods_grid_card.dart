import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/models/market/goods_item.dart';
import 'package:aku_community/ui/market/goods/goods_detail_page.dart';
import 'package:aku_community/utils/headers.dart';

class GoodsCard extends StatelessWidget {
  final GoodsItem item;
  final bool? border;
  const GoodsCard({Key? key, required this.item, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.white,
      elevation: 0,
      shape: !(border ?? false)
          ? null
          : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
          side: BorderSide(color: Color(0xFFC4C4C4))),
      padding: EdgeInsets.zero,
      onPressed: () => Get.to(
            () => GoodsDetailPage(id: item.id),
        preventDuplicates: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.w)),
            ),
            child: Stack(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                  image: API.image(ImgModel.first(item.imgList)),
                  fit: BoxFit.fill,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(R.ASSETS_IMAGES_PLACEHOLDER_WEBP);
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 38.w,
                    color: Colors.black54,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      item.recommend,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16.w,right: 16.w,
              top: 10.w,
            ),
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 28.sp,
                  color: ktextPrimary
              ),
            ),
          ),

          Padding(
              padding: EdgeInsets.only(
                left: 16.w,right: 16.w,
                top: 10.w,
              ),
              child: Container(
                child: _getIcon(1),
              )
          ),

          10.hb,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: RichText(
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
                    text: '${item.sellingPrice} ',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '原价：¥',
                    style: TextStyle(
                      color: ktextSubColor,
                      fontSize: 20.sp,

                    ),
                  ),
                  TextSpan(
                    text: '${item.markingPrice}',
                    style: TextStyle(
                      color: ktextSubColor,
                      fontSize: 20.sp,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: RichText(
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
                    text: '9折',
                    style: TextStyle(
                      color: ktextSubColor,
                      fontSize: 20.sp,

                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }


  Widget _getIcon(int type){
    if(type==1){
      return Container(
        width: 86.w,
        height: 26.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.w), ),
          gradient: LinearGradient(
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            colors: <Color>[Color(0xFFEC5329), Color(0xFFF58123)],
          ),
        ),
        child: Text(
          '京东自营',
          style: TextStyle(
              fontSize: 18.sp,
              color: kForeGroundColor
          ),
        ),
      );
    }
    else if(type==2){
      return Container(
        alignment: Alignment.center,
        width: 86.w,
        height: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.w), ),
          gradient: LinearGradient(
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            colors: <Color>[Color(0xFFF59B1C), Color(0xFFF5AF16)],
          ),
        ),
        child: Text(
          '京东POP',
          style: TextStyle(
              fontSize: 18.sp,
              color: kForeGroundColor
          ),
        ),
      );

    }
    else
      return SizedBox();
  }



}
