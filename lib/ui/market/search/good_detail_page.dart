
import 'package:aku_community/model/good/good_detail_model.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/pages/personal/address/address_list_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/ui/market/collection/collection_func.dart';
import 'package:aku_community/ui/market/search/search_func.dart';
import 'package:aku_community/ui/market/search/submit_order_page.dart';
import 'package:aku_community/ui/market/search/submit_order_page_normal.dart';
import 'package:aku_community/ui/market/shop_car/shop_car_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';


import 'good_detail_bottomSheet.dart';

class GoodDetailPage extends StatefulWidget {
  final int goodId;

  GoodDetailPage({Key? key, required this.goodId}) : super(key: key);

  @override
  _GoodDetailPageState createState() => _GoodDetailPageState();
}

class _GoodDetailPageState extends State<GoodDetailPage> {
  late EasyRefreshController _refreshController;
  bool _showList = true;

  late PageController _pageController;
  int _currentIndex = 0;
  late GoodDetailModel? _goodDetail;
  bool _onload = true;
  late ScrollController _sliverListController;
   AddressModel? _addressModel;
   List _imageList = [];

  @override
  void initState() {
    final appProvider = Provider.of<AppProvider>(Get.context!);
    super.initState();
    // Future.delayed(Duration(milliseconds: 0), () async {
    //   _imageList = await SearchFunc.getGoodDetailImage(widget.goodId);
    //   setState(() {
    //
    //   });
    // });
    _pageController = PageController();
    _sliverListController = ScrollController();
    _refreshController = EasyRefreshController();
    if(appProvider.addressModel!=null){
      _addressModel = appProvider.addressModel!;
    }else{
      _addressModel = null;
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _pageController.dispose();
    _sliverListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return BeeScaffold(
      titleSpacing: 0,
      bgColor: Color(0xFFF9F9F9),
      bodyColor: Color(0xFFF9F9F9),
      // title: Row(
      //   children: [
      //   ],
      // ),
      bottomNavi: _onload?SizedBox(): _bottomButton(),

      body: Stack(
        children: [
          EasyRefresh(
              firstRefresh: true,
              header: MaterialHeader(),
              controller: _refreshController,
              onRefresh: () async {
                _goodDetail = await SearchFunc.getGoodDetail(widget.goodId);
                _imageList = await SearchFunc.getGoodDetailImage(widget.goodId);
                if (_goodDetail != GoodDetailModel.fail()) {
                  _onload = false;
                }

                setState(() {});
              },
              child: _onload?SizedBox():_buildBody(context)),
          Positioned(
            top: (kToolbarHeight+16).w,
            left: 24.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(52.w)),
                        color: Color(0x80000000)),
                    child: GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Image.asset(R.ASSETS_ICONS_ICON_BACK_PNG,width: 52.w,height: 52.w,),
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _imageView(_goodDetail!.goodsDetailImageVos??[]),
        20.hb,
        _goodInfo(),
        20.hb,
        _address(context),
        20.hb,
        _getDetailImage(),
      ],
    );
  }

  _goodInfo(){
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.symmetric(horizontal:20.w ),
      width: double.infinity,
      height: 256.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24.w)),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              16.wb,
              '¥'.text.color(Color(0xFFE52E2E)).size(28.sp).make(),
              Text(
                _goodDetail!.sellPrice==null?'':(_goodDetail!.sellPrice!).toStringAsFixed(2),
                style: TextStyle(fontSize: 40.sp,color: Color(0xFFE52E2E)),
              ),
              Spacer(),
              '已售：'.text.color(Color(0xFFBBBBBB)).size(24.sp).make(),
              Text(
                (_goodDetail!.sellNum??0).toString(),
                style: TextStyle(fontSize: 24.sp,color: Color(0xFFBBBBBB)),
              ),
              16.wb,
            ],
          ),
          10.hb,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 80.w,
            width: double.infinity,
            child:
            Text(
                (_goodDetail!.skuName??''),
              style: TextStyle(fontSize: 28.sp,color: ktextPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          _getIcon(_goodDetail!.kind??0),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              16.wb,
              '原价：'.text.color(Color(0xFFBBBBBB)).size(24.sp).make(),
              Text(
                _goodDetail!.discountPrice==null?'':(_goodDetail!.discountPrice!).toStringAsFixed(2),
                style: TextStyle(fontSize: 24.sp,color: Color(0xFFBBBBBB)),
              ),
              50.wb,

              '折扣：'.text.color(Color(0xFFBBBBBB)).size(24.sp).make(),
              Text(
                (_goodDetail!.discountPrice??0)>(_goodDetail!.sellPrice??0)
                    ? _getDiscount(_goodDetail!.sellPrice ?? -1,
                    _goodDetail!.discountPrice ?? -1)
                    : '暂无折扣',
                style: TextStyle(fontSize: 24.sp,color: Color(0xFFBBBBBB)),
              ),
              16.wb,
            ],
          ),

        ],
      ),
    );
  }


  _address(BuildContext context){

    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.symmetric(horizontal:20.w ),
      width: double.infinity,
      height: 184.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async{
              //跳转到地址界面，点击地址然后返回地址
              var result =  await  Get.to(()=>AddressListPage(canBack: true,));
              if(result!=null){
                _addressModel = result;
              }
              setState(() {

              });
            },
            child: Container(
              color: Colors.white,
              child: Column(

                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      16.wb,
                      '送至'.text.color(Color(0xFFBBBBBB)).size(28.sp).make(),
                      20.wb,
                      Image.asset(R.ASSETS_ICONS_ICON_GOOD_LOCATION_PNG,width: 30.w,height: 30.w,),

                      Container(
                        width: 430.w,
                        child: Text(
                          _addressModel==null?'请先选择地址':(_addressModel!.locationName??'')
                              +(_addressModel!.addressDetail??''),
                          style: TextStyle(fontSize: 24.sp,color: ktextPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ),

                      Spacer(),
                      Icon(
                        CupertinoIcons.chevron_forward,
                        size: 32.w,
                        color: Color(0xFF999999),
                      ),

                      16.wb,
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      120.wb,
                      _goodDetail!.stockStatus==1?'有货'.text.color(Color(0xFFE52E2E)).size(28.sp).make()
                          :'无货'.text.color(Color(0xFFE52E2E)).size(28.sp).make(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          20.hb,

          GestureDetector(
            onTap: (){
                 showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return GoodDetailBottomSheet(goodDetail:_goodDetail!);
                      });
            },
            child: Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  16.wb,
                  '参数'.text.color(Color(0xFFBBBBBB)).size(28.sp).make(),
                 48.wb,
                  Text(
                    '品牌、规格',
                    style: TextStyle(fontSize: 24.sp,color: ktextPrimary),
                  ),
                  Spacer(),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 32.w,
                    color: Color(0xFF999999),
                  ),
                  16.wb,
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }

  _getDetailImage(){
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.symmetric(horizontal:20.w ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white
      ),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              16.wb,
              Container(
                width: 8.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Color(0xFFE52E2E),
                  borderRadius: BorderRadius.all(Radius.circular(4.w)),
                ),
              ),
              2.wb,
              Text(
                '商品详情',
                style: TextStyle(fontSize: 28.sp,color: ktextPrimary),
              ),
              Spacer(),
            ],
          ),
          10.hb,
          ..._imageList.map((e) => _image(_getRightUrl(e)??''))
        ],
      ),
    );
  }

  _image(String url){
    print(url);
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onLongPress: () {
          //保存图片
        },
        child: FadeInImage.assetNetwork(
          placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
          image: 'https://'+url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  ///获取的地址//img30.360buyimg.com/sku/jfs/t1/144443/40/4086/433571/5f22204bEd3a409dc/3090e34cf8c4187c.jpg
  ///多两个斜杠
  _getRightUrl(String url){
    return url.substring(2);
  }



  Widget _getIcon(int type){
    if(type==1){
      return Container(
        margin: EdgeInsets.only(left: 15.w),
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




  _bottomButton() {
    return  Container(
      width: double.infinity,
      height: 100.w,

      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x4D000000),
                offset: Offset(0.0, -1), //阴影xy轴偏移量
                blurRadius: 0, //阴影模糊程度
                spreadRadius: 0 //阴影扩散程度
            )
          ]
        // border: Border(top:BorderSide( width: 2.w,
        //   color: kPrimaryColor,))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          40.wb,
          GestureDetector(
            onTap: () async{
              await CollectionFunc.collection(_goodDetail!.id!);
              _refreshController.callRefresh();

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_goodDetail!.isCollection==0? R.ASSETS_ICONS_ICON_GOOD_FAVOR_PNG:R.ASSETS_ICONS_SHOP_FAVORFILL_PNG,width: 48.w,height: 48.w,),
                Text(
                  '加入收藏',
                  style: TextStyle(fontSize: 20.sp,color: ktextPrimary),
                ),
              ],
            ),
          ),
          40.wb,
          GestureDetector(
            onTap: ()async{
              //跳转到购物车界面
              Get.to(()=> ShopCarPage());

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(R.ASSETS_ICONS_ICON_GOOD_CAR_PNG,width: 48.w,height: 48.w,),
                Text(
                  '购物车',
                  style: TextStyle(fontSize: 20.sp,color: ktextPrimary),
                ),
              ],
            ),
          ),
          40.wb,
          Row(
            children: [
              GestureDetector(
                onTap: () async{

                  await SearchFunc.addGoodsCar(_goodDetail!.id!);
                },
                child: Container(
                  width: 230.w,
                  height: 84.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(84.w)),
                    border: Border.all(color: Color(0xFFE52E2E),width: 2.w)
                    // border: Border(top:BorderSide(color: Color(0xFFE52E2E),width: 2.w),
                    // left: BorderSide(color: Color(0xFFE52E2E),width: 2.w),bottom: BorderSide(color: Color(0xFFE52E2E),width: 2.w))
                  ),
                  alignment: Alignment.center,
                  child:Text(
                    '加入购物车',
                    style: TextStyle(fontSize: 32.sp,color:  Color(0xFFE52E2E)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(_goodDetail!.stockStatus==0){
                    BotToast.showText(text: '商品库存不足');
                  }else{
                    Get.to(()=>SubmitOrderNormalPage(goodModel: _goodDetail!,));
                  }
                },
                child: Container(
                  width: 230.w,
                  height: 84.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(84.w)),
                      color:Color(0xFFE52E2E),

                  ),
                  alignment: Alignment.center,
                  child:Text(
                    '立即购买',
                    style: TextStyle(fontSize: 32.sp,color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),

    );
  }

  Widget _imageView(List<GoodsDetailImageVos> imgList) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 725.w,
          child: PageView.builder(
              itemCount: imgList.length,
              onPageChanged: (value) {
                _pageController.jumpToPage(value);
                _currentIndex = value;
                setState(() {});
              },
              controller: _pageController,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: double.infinity,
                  height: 725.w,
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.fill,
                      placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                      image: imgList[index].url ?? ''),
                );
              }),
        ),
        Positioned(
          bottom: 24.w,
          right: 5.w,
          child: Container(
            alignment: Alignment.center,
            width: 69.w,
            height: 39.w,
            decoration: BoxDecoration(
                color: Color(0x80000000),
                borderRadius: BorderRadius.circular(40.w)),
            child: '${_currentIndex + 1}/${imgList.length}'
                .text
                .size(24.sp)
                .color(Colors.white)
                .make(),
          ),
        ),
      ],
    );
  }
  _getDiscount(double sellPrice, double discountPrice) {
    String count = '';
    count = ((sellPrice / discountPrice) * 10).toStringAsFixed(1);

    return count + '折';
  }

  _getSpecifications(){

  }
}
