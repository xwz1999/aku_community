// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:akuCommunity/model/aku_shop_model.dart';
import 'package:akuCommunity/provider/cart.dart';
import 'package:akuCommunity/utils/headers.dart';
import 'package:akuCommunity/widget/cached_image_wrapper.dart';
import 'package:akuCommunity/widget/cart_count.dart';
import 'widget/market_cart_app_bar.dart';

class MarketCartPage extends StatefulWidget {
  final AkuShopModel cartItem;

  MarketCartPage({Key key, this.cartItem}) : super(key: key);

  @override
  _MarketCartPageState createState() => _MarketCartPageState();
}

class _MarketCartPageState extends State<MarketCartPage> {
  Widget _cardRadio(
      BuildContext context, AkuShopModel cartItem, CartProvidde model, index) {
    return InkWell(
      onTap: () {
        setState(() {
          cartItem.isCheck = !cartItem.isCheck;
          int _goods = shopList.indexWhere(
              (element) => element.itemid == _cartList[index].itemid);
          _goods > -1
              ? shopList.removeAt(_goods)
              : shopList.add(_cartList[index]);
          print(shopList);
        });
      },
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          Icons.check_circle,
          color: cartItem.isCheck ? Color(0xffdb0000) : Color(0xff999999),
          size: 36.w,
        ),
      ),
    );
  }

  Widget _image(String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        child: CachedImageWrapper(
          url: imagePath,
          width: 180.w,
          height: 180.w,
        ),
      ),
    );
  }

  Widget _content(String content, specs, price) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 394.w,
            child: Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24.sp,
                color: Color(0xff333333),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40.w),
            child: Text(
              '￥$price',
              style: TextStyle(
                fontSize: 28.sp,
                color: Color(0xffe60e0e),
              ),
            ),
          ),
        ],
      ),
    );
  }
// List<Map<String, dynamic>> _listGoods = [
//     {
//       'imagePath':
//           'http://img.alicdn.com/imgextra/i3/2113905378/O1CN01aH72RP1pbAf1n1amP_!!2113905378.jpg',
//       'content': '2020很仙的开衫女春秋装韩版宽松加厚百搭外搭毛衣外套针织衫',
//       'specs': '165/M',
//       'price': 69.9,
//       'goodsNum': 1,
//       'isCheck': false
//     },
//     {
//       'imagePath':
//           'http://img.alicdn.com/imgextra/i3/2261315282/O1CN01FLPB6E1otCdaEw4OC_!!2261315282.jpg',
//       'content': '微商爆款女士MCKZ阳离子秋冬柔软舒适打底衫高领针织螺纹棉上衣',
//       'specs': '165/M',
//       'price': 129.9,
//       'goodsNum': 1,
//       'isCheck': false
//     },
//   ];

  // bool isAll = false;
  // double _currentPrice = 0;
  // int _currentGoodsNum = 0;

  // void funAll() {
  //   setState(() {
  //     isAll = !isAll;
  //     if (isAll) {
  //       _currentPrice = 0;
  //       _currentGoodsNum = 0;
  //     }
  //     _listGoods.forEach((item) {
  //       item["isCheck"] = isAll;
  //       if (item["isCheck"]) {
  //         _currentPrice += item["price"] * item["goodsNum"];
  //         _currentGoodsNum++;
  //       } else {
  //         _currentPrice -= item["price"] * item["goodsNum"];
  //         _currentGoodsNum--;
  //       }
  //     });
  //   });
  // }

  // void funIsSelect(int index) {
  //   setState(() {
  //     _listGoods[index]["isCheck"] = !_listGoods[index]["isCheck"];
  //     if (_listGoods[index]["isCheck"]) {
  //       _currentPrice +=
  //           _listGoods[index]["price"] * _listGoods[index]["goodsNum"];
  //       _currentGoodsNum++;
  //     } else {
  //       _currentPrice -=
  //           _listGoods[index]["price"] * _listGoods[index]["goodsNum"];
  //       _currentGoodsNum--;
  //     }
  //     if (_listGoods.every((item) => item["isCheck"])) {
  //       isAll = true;
  //     } else {
  //       isAll = false;
  //     }
  //   });
  // }

  // void reduce(int index) {
  //   setState(() {
  //     _listGoods[index]["goodsNum"]--;
  //     if (_currentPrice != 0) {
  //       _currentPrice = 0;
  //       _listGoods.forEach((item) {
  //         if (item["isCheck"]) {
  //           _currentPrice += item["price"] * item["goodsNum"];
  //         }
  //       });
  //     }
  //   });
  // }

  // void add(int index) {
  //   setState(() {
  //     _listGoods[index]["goodsNum"]++;
  //     if (_currentPrice != 0) {
  //       _currentPrice = 0;
  //       _listGoods.forEach((item) {
  //         if (item["isCheck"]) {
  //           _currentPrice += item["price"] * item["goodsNum"];
  //         }
  //       });
  //     }
  //   });
  // }

  // void funSubimt() {
  //   // setState(() {
  //   //   isAll = !isAll;
  //   // });
  // }
  List<AkuShopModel> shopList = [];
  bool get _selectALl {
    for (var element in _cartList) {
      int _selectGoods =
          shopList.indexWhere((index) => element.itemid == index.itemid);
      if (_selectGoods == -1) return false;
    }
    return true;
  }

  double get _allprice {
    double _price = 0;
    for (var element in shopList) {
      _price += double.parse(element.itemprice) * element.count;
    }
    return _price;
  }

  int get _goodsCount => shopList.length;

  List<AkuShopModel> _cartList;

  Widget _selectAll(
    CartProvidde model,
  ) {
    return InkWell(
      onTap: () {
        for (var element in _cartList) {
          element.isCheck = !_selectALl;
        }
        model.changeALlCheckState(true);
        setState(() {
          if (_selectALl == true)
            shopList.clear();
          else {
            shopList.clear();
            shopList.addAll(_cartList);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 29.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _selectALl
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: model.isAllCheck ? Color(0xffdb0000) : Color(0xff999999),
              size: 40.w,
            ),
            Container(
              margin: EdgeInsets.only(left: 18.w),
              child: Text(
                '全选',
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Color(0xff333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settlement(CartProvidde model, BuildContext context) {
    return Row(
      children: [
        model.allPrice != null
            ? Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Text(
                  '合计:￥${_allprice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Color(0xffe60e0e),
                  ),
                ),
              )
            : SizedBox(),
        InkWell(
          onTap: model.allGoodsCount != 0 ? () {} : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: model.allGoodsCount != 0
                  ? Color(0xffffc40c)
                  : Color(0xffd8d8d8),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            width: 198.w,
            margin: EdgeInsets.symmetric(vertical: 16.w),
            padding: EdgeInsets.symmetric(vertical: 12.w),
            child: Text(
              '结算($_goodsCount)',
              style: TextStyle(
                fontSize: 30.sp,
                color:
                    model.allGoodsCount != 0 ? Color(0xff333333) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _marketCartCard(AkuShopModel cartItem, index) {
    return Consumer<CartProvidde>(builder: (context, model, child) {
      return Container(
        margin: EdgeInsets.only(
          top: 20.w,
          left: 32.w,
          right: 32.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Slidable.builder(
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.25,
          secondaryActionDelegate: SlideActionBuilderDelegate(
            actionCount: 2,
            builder: (context, index, animation, renderingMode) {
              if (index == 0) {
                return SlideAction(
                  child: Text(
                    '移至收藏夹',
                    style: TextStyle(
                        fontSize: 28.sp, color: Colors.white),
                  ),
                  color: renderingMode == SlidableRenderingMode.slide
                      ? Color(0xffffc40c).withOpacity(animation.value)
                      : Color(0xffffc40c),
                  // onTap: () => _showSnackBar(context, 'More'),
                  closeOnTap: false,
                );
              } else {
                return SlideAction(
                  onTap: () {
                    model.deleteGoods(cartItem.itemid);
                  },
                  decoration: BoxDecoration(
                    color: renderingMode == SlidableRenderingMode.slide
                        ? Color(0xffe60e0e).withOpacity(animation.value)
                        : Color(0xffe60e0e),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    '删除',
                    style: TextStyle(
                        fontSize: 28.sp, color: Colors.white),
                  ),
                  // onTap: () => _showSnackBar(context, 'Delete'),
                );
              }
            },
          ),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: 30.w,
              left: 15.w,
              bottom: 37.w,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    _cardRadio(context, cartItem, model, index),
                    _image(cartItem.itempic),
                    _content(cartItem.itemtitle, '默认', cartItem.itemprice),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 16.w,
                  child: CartCount(
                    cartItem: cartItem,
                    // goodsNum: widget.goodsNum,
                    // index: widget.index,
                    // reduce: widget.reduce,
                    // add: widget.add,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MarketCartAppBar(),
        ),
        bottomNavigationBar:
            Consumer<CartProvidde>(builder: (context, model, child) {
          return Container(
            color: Colors.white,
            height: 98.w,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _selectAll(model),
                _settlement(
                  model,
                  context,
                )
              ],
            ),
          );
        }),
        body: Stack(
          children: [
            Consumer<CartProvidde>(
              builder: (context, model, child) {
                List<AkuShopModel> cartList = model.cartList;
                _cartList = model.cartList;
                return ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _marketCartCard(cartList[index], index);
                    });
              },
            ),
            // Positioned(
            //   bottom: 0,
            //   child: MarketCartBottomBar(
            //     selectAll: _selectALl,
            //   ),
            // ),
          ],
        ));
  }
}
