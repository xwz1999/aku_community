import 'package:aku_community/model/good/category_model.dart';
import 'package:aku_community/ui/market/search/search_goods_page.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/models/market/market_category_model.dart';
import 'package:aku_community/ui/market/goods/goods_list_view.dart';
import 'package:aku_community/utils/headers.dart';

class NewCategorySubCard extends StatelessWidget {
  final CategoryListSecond subModels;
  const NewCategorySubCard({
    Key? key,

    required this.subModels,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Column(
        children: [
          Spacer(),
          FadeInImage.assetNetwork(
            image:API.image(subModels.imgUrls!.isNotEmpty? subModels.imgUrls!.first :''),//subModels.imgUrls!.isNotEmpty? subModels.imgUrls!.first :'',
            placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
            height: 75.w,
            width: 75.w,
          ),
          12.hb,
          Container(
            alignment: Alignment.center,
            width: 110.w,
            child: Text(
              subModels.name??'',
              style: TextStyle(
                fontSize: 24.sp,
                color: Color(0xFF4A4B51),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
        ],
      ),
      onPressed: () async {
        Get.to(()=> SearchGoodsPage(categoryName:subModels.name ,categoryId:subModels.id ,));
        // await Get.to(
        //   () => GoodsListView(
        //     model: model,
        //     subModels: subModels,
        //     selectSubModel: selectModel,
        //   ),
        // );
      },
    );
  }
}
