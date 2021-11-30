import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/market/shop_car/shop_car_list_model.dart';
import 'package:aku_community/ui/market/search/submit_order_page.dart';
import 'package:aku_community/ui/market/shop_car/shop_car_func.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/bee_check_radio.dart';
import 'package:aku_community/widget/buttons/end_button.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:aku_community/utils/headers.dart';

class ShopCarPage extends StatefulWidget {
  const ShopCarPage({Key? key}) : super(key: key);

  @override
  _ShopCarPageState createState() => _ShopCarPageState();
}

class _ShopCarPageState extends State<ShopCarPage> {
  bool _editStatus = false;
  List<TextEditingController> _controllers = [];
  List<ShopCarListModel> _models = [];
  List<ShopCarListModel> _chooseModels = [];
  EasyRefreshController _refreshController = EasyRefreshController();
  bool _first = true;

  //选中的model下表
  List<int> _selectIndex = [];

  bool get _allSelect =>
      _selectIndex.length == _models.length && _selectIndex.length != 0;

  double get total {
    var num = 0.0;
    if (_selectIndex.isEmpty) return 0.0;
    _selectIndex.forEach((element) {
      double sellPrice = _models[element].sellPrice ?? 0;
      int number = _models[element].num ?? 0;
      num += (sellPrice * number);
    });
    return num;
  }

  @override
  void dispose() {
    _controllers.forEach((element) {
      element.dispose();
    });
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '购物车'.text.size(32.sp).black.bold.make(),
      titleSpacing: 0,
      actions: [
        TextButton(
            onPressed: () {
              _editStatus = !_editStatus;
              setState(() {});
            },
            child:
                (_editStatus ? '完成' : '管理').text.size(32.sp).black.bold.make())
      ],
      body: SafeArea(
        child: Column(
          children: [
            10.hb,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                10.widthBox,
                '共${_models.length}件商品'.text.size(28.sp).black.make(),
              ],
            ),
            10.hb,
            Expanded(
              child: EasyRefresh(
                firstRefresh: true,
                controller: _refreshController,
                header: MaterialHeader(),
                onRefresh: () async {
                  var base = await NetUtil().get(API.market.shopCarList);
                  if (base.status ?? false) {
                    _models = (base.data as List)
                        .map((e) => ShopCarListModel.fromJson(e))
                        .toList();
                    // _controllers.forEach((element) {
                    //   element.dispose();
                    // });
                    // _controllers.clear();
                    if (_first) {
                      _models.forEach((element) {
                        _controllers.add(TextEditingController(
                            text: element.num.toString()));
                      });
                      _first = false;
                    } else {
                      if (_models.length > _controllers.length) {
                        for (int i = _controllers.length - 1;
                            i < _models.length;
                            i++) {
                          _controllers.add(TextEditingController(
                              text: _models[i].num.toString()));
                        }
                      }
                    }
                  }
                  print(_models.length);
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: _models.isEmpty
                    ? _emptyWidget()
                    : ListView(
                        shrinkWrap: true,
                        children: _models
                            .mapIndexed((e, index) => _goodCard(e, index))
                            .toList()),
              ),
            )
          ],
        ),
      ),
      bottomNavi: Container(
        width: double.infinity,
        height: 100.w,
        color: Colors.white,
        child: Row(
          children: [
            20.widthBox,
            GestureDetector(
              onTap: () {
                if (_allSelect) {
                  _selectIndex.clear();
                  _chooseModels.clear();
                } else {
                  _selectIndex.clear();
                  _chooseModels.clear();
                  _chooseModels.addAll(_models);
                  _selectIndex
                      .addAll(List.generate(_models.length, (index) => index));
                }
                setState(() {});
              },
              child: Container(
                width: 120.w,
                height: 60.w,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.w),
                          border: Border.all(color: Color(0xFFBBBBBB))),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: _allSelect ? 1 : 0,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: Color(0xFFE52E2E),
                          ),
                        ),
                      ),
                    ),
                    5.widthBox,
                    '全选'.text.size(28.sp).color(ktextPrimary).make(),
                  ],
                ),
              ),
            ),
            8.w.widthBox,
            Spacer(),
            Offstage(
              offstage: _editStatus,
              child: '合计：'
                  .richText
                  .withTextSpanChildren([
                    '¥${total}'
                        .textSpan
                        .color(ktextSubColor)
                        .size(28.sp)
                        .make(),
                  ])
                  .black
                  .size(28.sp)
                  .make(),
            ),
            20.widthBox,
            EndButton(
                onPressed: _editStatus ? _delete : _settleEnd,
                text: (_editStatus ? '删除' : '结算')
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

  Future _settleEnd() async {
    if (_chooseModels.isEmpty) {
      BotToast.showText(text: '请先选择商品');
    } else
      Get.to(() => SubmitOrderPage(
            models: _chooseModels,
          ));
  }

  Future _delete() async {
    if (_selectIndex.isNotEmpty) {
      bool? result = await Get.dialog(CupertinoAlertDialog(
        title: '您确定要删除该商品吗？'.text.isIntrinsic.size(30.sp).make(),
        actions: [
          CupertinoDialogAction(
            child: '取消'.text.black.isIntrinsic.make(),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: '确定'.text.color(Colors.orange).isIntrinsic.make(),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ));

      if (result == true) {
        BaseModel model = await NetUtil().post(
          API.market.shopCarDelete,
          params: {
            'jcookGoodsIds': _selectIndex.map((e) => _models[e].id).toList()
          },
          showMessage: true,
        );
        if (model.status != null) {
          if (model.status!) {
            _selectIndex.clear();
            _refreshController.callRefresh();
          }
        }
      }
      ;
    } else {
      BotToast.showText(text: '请先选择商品');
    }
  }

  Widget _goodCard(ShopCarListModel model, int index) {
    var top = RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: _getKindWd(model.kind ?? 0),
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
    double sellPrice = model.sellPrice ?? 0;
    var bottom = Row(
      children: [
        '¥'
            .richText
            .withTextSpanChildren([
              sellPrice
                  .toInt()
                  .toString()
                  .textSpan
                  .size(40.sp)
                  .color(Color(0xFFE52E2E))
                  .make(),
              '.${_getPointBehind(sellPrice)}'
                  .textSpan
                  .size(28.sp)
                  .color(Color(0xFFE52E2E))
                  .make()
            ])
            .color(Color(0xFFE52E2E))
            .size(28.sp)
            .make(),
        Spacer(),
        _getBottomSuffix(model.goodStatus, model.id!, index)
      ],
    );
    return Container(
      alignment: Alignment.center,
      height: 260.w,
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (_selectIndex.contains(index)) {
                _selectIndex.remove(index);
                _chooseModels.remove(model);
              } else {
                _selectIndex.add(index);
                _chooseModels.add(model);
              }
              setState(() {});
            },
            child:
            model.goodStatus==GoodStatus.unSell?
            Container(
              color: Colors.transparent,
              height: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: double.infinity,
                alignment: Alignment.center,
                child:Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color:Color(0xFFBBBBBB),

                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    color: Color(0xFFEEEEEE),
                    width: 26.w,
                    height: 8.w,
                  )
                ),

              ),
            ):
            Container(
              color: Colors.transparent,
              height: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: double.infinity,
                alignment: Alignment.center,
                child: BeeCheckRadio(
                  value: index,
                  groupValue: _selectIndex,
                  backColor: Colors.white,
                  indent: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      color: Color(0xFFE52E2E),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   width: 220.w,
          //   height: 220.w,
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
                width: 220.w,
                height: 220.w,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                  image: model.mainPhoto ?? '',
                  height: 220.w,
                  width: 220.w,
                ),
              ),
              Positioned(
                  child: _getGoodsStatusImg(model.goodStatus) ?? SizedBox())
            ],
          ),
          16.widthBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              top,
              8.heightBox,
              mid,
              Spacer(),
              bottom,
              10.heightBox,
            ],
          ).expand(),
          16.widthBox,
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
            child: '其他'.text.size(18.sp).color(Colors.white).make());
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
                  if(_controllers[index].text.isEmpty){
                    _controllers[index].text = '1';
                  }
                  int num = int.parse(_controllers[index].text);
                  if (num > 1) {
                    var result = await changeNum(id, num - 1);
                    if (result) {
                      _controllers[index].text = (num - 1).toString();
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
                  //readOnly: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) async {
                    if(text.isNotEmpty){
                      if(int.parse(text)>10){
                        _controllers[index].text = '10';
                      }
                      var result = await changeNum(id, int.parse(_controllers[index].text));
                      if (!result) {
                        // _controllers[index].text=

                      }
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
                  if(_controllers[index].text.isEmpty){
                    _controllers[index].text = '0';
                  }
                  int num = int.parse(_controllers[index].text);

                  if (num < 10) {
                    var result = await changeNum(
                        id, int.parse(_controllers[index].text) + 1);
                    if (result) {
                      _controllers[index].text =
                          (int.parse(_controllers[index].text) + 1).toString();
                    }
                    setState(() {});
                  }else{
                    BotToast.showText(text:  '一次最多购买10个商品');
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


  Future _changeNum() async {
    if (_selectIndex.isNotEmpty) {
      bool? result = await Get.dialog(CupertinoAlertDialog(
        title: '您确定要删除该商品吗？'.text.isIntrinsic.size(30.sp).make(),
        actions: [
          CupertinoDialogAction(
            child: '取消'.text.black.isIntrinsic.make(),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: '确定'.text.color(Colors.orange).isIntrinsic.make(),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ));

      if (result == true) {
        BaseModel model = await NetUtil().post(
          API.market.shopCarDelete,
          params: {
            'jcookGoodsIds': _selectIndex.map((e) => _models[e].id).toList()
          },
          showMessage: true,
        );
        if (model.status != null) {
          if (model.status!) {
            _selectIndex.clear();
            _refreshController.callRefresh();
          }
        }
      }
      ;
    } else {
      BotToast.showText(text: '请先选择商品');
    }
  }
}
