import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/order/create_order_model.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/models/market/shop_car/shop_car_list_model.dart';
import 'package:aku_community/pages/life_pay/pay_finish_page.dart';
import 'package:aku_community/pages/life_pay/pay_util.dart';
import 'package:aku_community/pages/personal/address/address_list_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/ui/market/order/order_page.dart';
import 'package:aku_community/ui/market/search/settlementGoodsDTO.dart';
import 'package:aku_community/ui/market/shop_car/shop_car_func.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:aku_community/widget/buttons/end_button.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SubmitOrderPage extends StatefulWidget {
  final List<ShopCarListModel> models;
   SubmitOrderPage({Key? key, required this.models}) : super(key: key);

  @override
  _SubmitOrderPageState createState() => _SubmitOrderPageState();
}

class _SubmitOrderPageState extends State<SubmitOrderPage> {

  List<TextEditingController> _controllers = [];
  List<SettlementGoodsDTO> _goodsList = [];
  AddressModel? _addressModel;
  CreateOrderModel? _createOrderModel;
  double _allPrice = 0;
  bool haveStock = true;

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(Get.context!);


    _controllers.forEach((element) {
      element.dispose();
    });
    _controllers.clear();
    widget.models.forEach((element) {
      _controllers.add(
          TextEditingController(text: element.num.toString()));
      _goodsList.add(SettlementGoodsDTO(jcookGoodsId: element.id,num: element.num));
    });


    if(appProvider.addressModel!=null){
      _addressModel = appProvider.addressModel!;
      createOrder(_addressModel!.id!,_goodsList);
    }else{
      _addressModel = null;
    }

}
  @override
  void dispose() {

    super.dispose();
  }


    Future<bool> createOrder(int addressId,List<SettlementGoodsDTO> goodsList) async {

      BaseModel model = await NetUtil().post(
        API.market.shopCarSettlement,
        params: {'addressId': addressId,'settlementGoodsDTOList':goodsList.map((v) => v.toJson()).toList()},
      );
      if (model.data == null){
        _createOrderModel = null;
        setState(() {

        });
        return false;

      }else{
        _createOrderModel = CreateOrderModel.fromJson(model.data);
        setState(() {

        });
        return true;
      }


    }


  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title:  '确认订单'.text.size(32.sp).black.bold.make(),
      titleSpacing: 0,

      body:  ListView(
          children: [
            20.hb,
            _address(context),
            20.hb,
            ...widget.models.mapIndexed((currentValue, index) => _goodCard(currentValue,index,_createOrderModel)),
            20.hb,
            _priceView(),
            20.hb,
            _payWay(),
            20.hb,
          ],
        ),

      bottomNavi: Container(
        width: double.infinity,
        height: 120.w,
        color: Colors.white,
        child: Row(
          children: [
            Spacer(),

            EndButton(
                onPressed:  () async {
                  if(_addressModel==null){
                    BotToast.showText(text: '请先选择地址');
                    return;
                  }
                  if(!haveStock){
                    BotToast.showText(text: '下单失败，订单内有商品无库存');
                    return;
                  }
                  Function cancel = BotToast.showLoading();
                  BaseModel baseModel =
                  await NetUtil().post(API.pay.jcookOrderCreateOrder, params: {
                    "addressId": _addressModel!.id!,
                    "settlementGoodsDTOList": _goodsList.map((v) => v.toJson()).toList(),
                    "payType": 1, //暂时写死 等待后续补充
                    "payPrice": _allPrice
                  });
                  if (baseModel.status ?? false) {
                    bool result = await PayUtil()
                        .callAliPay(baseModel.message!, API.pay.jcookOrderCheckAlipay);
                    if (result) {
                      Get.off(() => OrderPage(initIndex: 2));
                    }else{
                      ///跳到待付款页面
                      Get.off(() => OrderPage(initIndex: 1));
                    }
                  }
                  cancel();
                },
                text: '提交订单'
                    .text
                    .size(32.sp)
                    .color(Colors.white)
                    .make()),
            10.widthBox,
          ],
        ),
      ),
    );
  }

  _address(BuildContext context){

    return Container(
      padding: EdgeInsets.only(left: 16.w,right: 16.w,top: 20.w,bottom: 20.w),
      margin: EdgeInsets.symmetric(horizontal:20.w ),
      width: double.infinity,
      height: 182.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white
      ),
      child:
          GestureDetector(
            onTap: () async{
              //跳转到地址界面，点击地址然后返回地址
              var result =  await  Get.to(()=>AddressListPage(canBack: true,));
              if(result!=null){
                _addressModel = result;
                createOrder(_addressModel!.id!,_goodsList);
              }else{
                _addressModel =null;
              }
              setState(() {

              });
            },
            child:  Container(
              color: Colors.white,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(R.ASSETS_ICONS_ICON_GOOD_LOCATION_PNG,width: 60.w,height: 60.w,),

                    _addressModel!=null?Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 20.w, vertical:6.w),
                              child: SizedBox(
                                width: 518.w,
                                child: Text(
                                  _addressModel!.locationName??'',
                                  style:TextStyle(fontSize: 24.sp,color: ktextPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 20.w, vertical:6.w),
                              child: SizedBox(
                                width: 518.w,
                                child: Text(
                                  ( _addressModel!.addressDetail??''),
                                  style:TextStyle(fontSize: 32.sp,color: ktextPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical:6.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      _addressModel!.name??'',
                                      style: TextStyle(fontSize: 24.sp,color: ktextPrimary)
                                  ),
                                  30.wb,
                                  Text(
                                      _addressModel!.tel??'',
                                      style: TextStyle(fontSize: 24.sp,color: ktextPrimary)
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ):Center(
                      child: Text(
                       '请先选择地址',
                        style:TextStyle(fontSize: 32.sp,color: ktextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                      )
                    ),

                    Spacer(),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      size: 40.w,
                      color: Color(0xFF999999),
                    ),


                  ],
                ),
            ),

          ),
    );
  }

  _priceView(){
    double allPrice = 0;
    int allNum = 0;
    double fee = 0;
    if(_createOrderModel!=null){
      fee =_createOrderModel!.fee??0;
    }

    _controllers.forEachIndexed((index, element) {
      int num = int.parse(_controllers[index].text);
      print(num);
      allNum += num;
      allPrice += ((widget.models[index].sellPrice??0) * num);
      print(allPrice);
    });
    _allPrice = allPrice+fee;


    return Container(
      padding: EdgeInsets.only(left: 16.w,right: 16.w,top: 20.w,bottom: 20.w),
      margin: EdgeInsets.symmetric(horizontal:20.w ),
      width: double.infinity,
      height: 200.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white
      ),
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              '共${allNum}件'
                  .text
                  .size(28.sp)
                  .color(Color(0xFFBBBBBB))
                  .make(),
              5.wb,
              '商品金额：'
                  .text
                  .size(28.sp)
                  .color(Color(0xFF333333))
                  .make(),
              '¥${(_allPrice).toStringAsFixed(2)}'
                  .text
                  .size(28.sp)
                  .color(Color(0xFF333333))
                  .make(),
              16.wb,
            ],
          ),
          16.hb,
          _createOrderModel!=null? Row(
            children: [
              Spacer(),
              '运费：'
                  .text
                  .size(28.sp)
                  .color(Color(0xFF333333))
                  .make(),
              (   '¥${_createOrderModel!.fee}')
                  .text
                  .size(28.sp)
                  .color(Color(0xFF333333))
                  .make(),
              16.wb,
            ],
          ):SizedBox(),
          16.hb,
          // Row(
          //   children: [
          //     Spacer(),
          //     '(小提示：京东自营商品加入购物车后一起下单，运费会更划算)'
          //         .text
          //         .size(18.sp)
          //         .color(Color(0xFFBBBBBB))
          //         .make(),
          //   ],
          // ),
          //16.hb,
          Row(
            children: [
              Spacer(),
              '应付金额：'
                  .text
                  .size(32.sp)
                  .color(Color(0xFF333333)).bold
                  .make(),
              '¥${_allPrice+fee}'
                  .text
                  .size(32.sp)
                  .color(Color(0xFFE52E2E)).bold
                  .make(),
              16.wb,
            ],
          )
        ],
      ),

    );
  }


  _payWay(){
    return Container(
      padding: EdgeInsets.only(left: 16.w,right: 16.w,top: 20.w,bottom: 20.w),
      margin: EdgeInsets.symmetric(horizontal:20.w ),
      width: double.infinity,
      height: 72.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
          color: Colors.white
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          '支付方式'
              .text
              .size(28.sp)
              .color(Color(0xFF333333))
              .make(),
          Spacer(),
          Image.asset(R.ASSETS_ICONS_ALIPAY_ROUND_PNG,width: 40.w,height: 40.w,),
          16.wb,
          '支付宝'
              .text
              .size(28.sp)
              .color(Color(0xFF333333))
              .make(),
        ],
      ),

    );
  }


  Widget _goodCard(ShopCarListModel model, int index,CreateOrderModel? createOrderModel) {
    bool haveGoods = true;
    if(createOrderModel!=null){
      if(createOrderModel.myShoppingCartVoList![index].stockStatus==0){
        haveGoods = false;
        haveStock = false;
      }

    }
    var top = RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: _getKindWd(model.kind??0),
        ),
        TextSpan(
            text: model.skuName,
            style: TextStyle(fontSize: 28.sp, color: ktextPrimary)),
      ]),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    var mid = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w), color: Color(0xFFF2F3F4)),
      child: '规格：${model.weight}kg/${model.unit}'
          .text
          .size(24.sp)
          .color(Color(0xFFBBBBBB))
          .make(),
    );
    var bottom =
    Column(
      children: [
        Row(
          children: [
            92.wb,
            '购买数量'
                .text
                .size(28.sp)
                .color(Color(0xFF333333))
                .make(),
            Spacer(),
            haveGoods?
            _getBottomSuffix(model.goodStatus, model.id!, index):
            '该规格商品无库存'
                .text
                .size(24.sp)
                .color(Color(0xFFF58123))
                .make(),
          ],
        ),
        48.hb,
        Row(
          children: [
            92.wb,
            '配送方式'
                .text
                .size(28.sp)
                .color(Color(0xFF333333))
                .make(),
            Spacer(),
            '快递配送'
                .text
                .size(28.sp)
                .color(Color(0xFFBBBBBB))
                .make(),
            10.wb,
          ],
        ),
      ],
    );
    int num = int.parse(_controllers[index].text);
    double sellPrice = model.sellPrice??0;
    var price =
        Row(
          children: [
            Spacer(),
            '共${_controllers[index].text}件'
                .text
                .size(28.sp)
                .color(Color(0xFFBBBBBB))
                .make(),
            5.wb,
            '商品金额：'
                .text
                .size(28.sp)
                .color(Color(0xFF333333))
                .make(),
            '¥${(num * sellPrice).toStringAsFixed(2)}'
                .text
                .size(28.sp)
                .color(Color(0xFF333333))
                .make(),
            16.wb,
          ],
    );
    return Container(
      alignment: Alignment.center,
      height: 500.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: 188.w,
              //   height: 188.w,
              //   clipBehavior: Clip.antiAlias,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(16.w),
              //       image: DecorationImage(
              //           fit: BoxFit.scaleDown,
              //           image: NetworkImage(model.mainPhoto??''))),
              //   child: _getGoodsStatusImg(model.goodStatus),
              // ),
              Stack(
                children: [
                  Container(
                    width: 188.w,
                    height: 188.w,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.w),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                      image: model.mainPhoto??'',
                      height: 188.w,
                      width: 188.w,
                    ),
                  ),
                  Positioned(
                      child: Container(
                          height: 188.w,
                          width: 188.w,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          child: _getGoodsStatusImg(model.goodStatus) ??
                              SizedBox()))
                ],

              ),
              20.wb,
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(child: top,width:sellPrice>9999?300.w:320.w,alignment: Alignment.topCenter,),

                    10.hb,
                    mid,
                    //Spacer(),

                    10.hb,
                  ],
                ),
              ),
              Spacer(),

              Container(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    8.hb,
                    '¥'
                        .richText
                        .withTextSpanChildren([
                      sellPrice.toStringAsFixed(2)
                          .textSpan
                          .size(28.sp)
                          .color(ktextPrimary)
                          .make(),
                    ])
                        .color(ktextPrimary)
                        .size(28.sp)
                        .make(),
                    'x ${_controllers[index].text}'
                        .text
                        .size(24.sp)
                        .color(Color(0xFFBBBBBB))
                        .make(),
                  ],
                ),
              )

            ],
          ),
          bottom,
          Spacer(),
          price,
          30.hb,
        ],
      ),
    );
  }

  String _getPointBehind(double num) {
    var str = (num - num.toInt().toDouble()).toStringAsFixed(2);
    return str.substring(str.length - 2);
  }

  Widget _getKindWd(int kind) {
    switch (kind) {
      case 1:
        return Container(
            // width: 90.w,
            // height: 26.w,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.w),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFEC5329), Color(0xFFF58123)])),
            child: '京东自营'.text.size(18.sp).color(Colors.white).make());
      case 2:
        return Container(
            width: 90.w,
            height: 26.w,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFEC5329), Color(0xFFF58123)])),
            child: '京东POP'.text.size(18.sp).color(Colors.white).make());
      default:
        return SizedBox();
    }
  }

  Widget? _getGoodsStatusImg(GoodStatus status) {
    switch (status) {
      case GoodStatus.unSell:
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFF000000).withOpacity(0.5),
          alignment: Alignment.center,
          child: Text(
            '已下架',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
                color: Colors.white),
          ),
        );
      case GoodStatus.onSell:
        return null;
    }
  }

  Widget _getBottomSuffix(GoodStatus status, int id, int index) {
    switch (status) {
      case GoodStatus.onSell:
        return Container(
          width: 108.w + 64.w,
          height: 40.w,
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  int num = int.parse(_controllers[index].text);
                  if(num>1){
                    var result = await changeNum(id, num - 1);
                    if (result) {
                      _controllers[index].text = (num - 1).toString();
                      _goodsList[index].num = num - 1;
                      createOrder(_addressModel!.id!,_goodsList);
                    }
                  }

                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Icon(
                    CupertinoIcons.minus,
                    size: 30.w,
                  ),
                ),
              ),
              Container(
                width: 84.w,
                height: 40.w,
                decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(4.w)),
                child: TextField(
                  readOnly:true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) async {
                    var result = await changeNum(id, int.parse(text));
                    if (!result) {
                      // _controllers[index].text=
                    }

                    setState(() {});
                  },
                  controller: _controllers[index],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  int num = int.parse(_controllers[index].text);
                  if(num<10){
                    var result = await changeNum(
                        id, int.parse(_controllers[index].text) + 1);
                    if (result) {
                      _controllers[index].text =
                          (int.parse(_controllers[index].text) + 1).toString();
                      _goodsList[index].num = num + 1;
                      createOrder(_addressModel!.id!,_goodsList);
                    }
                    setState(() {});
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Icon(
                    CupertinoIcons.plus,
                    size: 30.w,
                  ),
                ),
              )
            ],
          ),
        );
      case GoodStatus.unSell:
        return '商品已下架'.text.size(24.sp).color(Color(0x80000000)).make();
    }
  }

  Widget _emptyWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            R.ASSETS_IMAGES_SHOP_CAR_EMPTY_PNG,
            width: 400.w,
            height: 400.w,
          ),
          '暂时没有加购商品'.text.size(28.sp).color(Color(0xFFBBBBBB)).make()
        ],
      ),
    );
  }

  Future<bool> changeNum(int jcookGoodsId, int num) async {
    var cancel = BotToast.showLoading();
    var base = await NetUtil().post(API.market.shopCarChangeNum,
        params: {'jcookGoodsId': jcookGoodsId, 'num': num});
    if (!(base.status ?? false)) {
      BotToast.showText(text: base.message ?? '');
    }
    cancel();
    return base.status ?? false;
  }
}
