import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:akuCommunity/utils/screenutil.dart';
import 'package:akuCommunity/base/assets_image.dart';
import 'package:akuCommunity/base/base_style.dart';
import 'package:akuCommunity/routers/page_routers.dart';

class OrderDetailsPage extends StatefulWidget {
  final Bundle bundle;
  OrderDetailsPage({Key key, this.bundle}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: BaseStyle.colorffd000,
      leading: IconButton(
        icon: Icon(AntDesign.left, size: Screenutil.size(40)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        '订单详情',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: BaseStyle.fontSize32,
          color: BaseStyle.color333333,
        ),
      ),
    );
  }

  Container _containerHeader(String status) {
    return Container(
      width: double.infinity,
      color: Color(0xffffd000),
      padding: EdgeInsets.only(
        top: Screenutil.length(44),
        bottom: Screenutil.length(44),
        left: Screenutil.length(33),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: BaseStyle.fontSize32,
              color: BaseStyle.color333333,
            ),
          ),
          SizedBox(height: Screenutil.length(10)),
          Text(
            '还剩9小时33分自动确认',
            style: TextStyle(
              fontSize: BaseStyle.fontSize24,
              color: BaseStyle.color333333,
            ),
          ),
        ],
      ),
    );
  }

  Container _containerAddress() {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.only(
        left: Screenutil.length(32),
        top: Screenutil.length(24),
        bottom: Screenutil.length(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetsImage.LOCATION,
            height: Screenutil.length(78),
            width: Screenutil.length(78),
          ),
          SizedBox(width: Screenutil.length(24)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '马泽鹏',
                    style: TextStyle(
                      fontSize: BaseStyle.fontSize28,
                      color: BaseStyle.color333333,
                    ),
                  ),
                  SizedBox(width: Screenutil.length(16)),
                  Text(
                    '18809801254',
                    style: TextStyle(
                      fontSize: BaseStyle.fontSize24,
                      color: BaseStyle.color999999,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Screenutil.length(16)),
              Container(
                width: Screenutil.length(584),
                child: ExtendedText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '浙江省 宁波市 江北区 工程学院阿库旅游6楼606室',
                        style: TextStyle(
                            fontSize: BaseStyle.fontSize28,
                            color: BaseStyle.color999999,
                            height: 1.5),
                      )
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InkWell _inkWellRefund(
      List<Map<String, dynamic>> listContent, double payPrice) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, PageName.refund_select_page.toString(),
            arguments: Bundle()
              ..putMap('details', {
                'listContent': listContent,
                'payPrice': payPrice,
              }));
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: Screenutil.length(6)),
        width: Screenutil.length(134),
        decoration: BoxDecoration(
          border: Border.all(color: BaseStyle.color999999, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(36)),
        ),
        child: Text(
          '退款',
          style: TextStyle(
              fontSize: BaseStyle.fontSize28, color: BaseStyle.color333333),
        ),
      ),
    );
  }

  Container _containerContent(
    String imagePath,
    content,
    specs,
    double price,
    payPrice,
    int shopNum,
    List<Map<String, dynamic>> listContent,
  ) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    imagePath,
                    height: Screenutil.length(179),
                    width: Screenutil.length(173),
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Screenutil.length(24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Screenutil.length(252),
                        child: Text(
                          content,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: BaseStyle.fontSize28,
                            color: BaseStyle.color333333,
                          ),
                        ),
                      ),
                      SizedBox(height: Screenutil.length(16)),
                      Text(
                        specs,
                        style: TextStyle(
                          fontSize: BaseStyle.fontSize28,
                          color: BaseStyle.color999999,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Screenutil.length(73)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: Screenutil.length(25)),
                    child: Text(
                      '实付款￥${payPrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: BaseStyle.fontSize28,
                        color: BaseStyle.colorff8500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: Screenutil.length(23),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '￥${price}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: BaseStyle.fontSize28,
                    color: BaseStyle.color333333,
                  ),
                ),
                Text(
                  'x${shopNum}',
                  style: TextStyle(
                    fontSize: BaseStyle.fontSize28,
                    color: BaseStyle.color999999,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: Screenutil.length(103),
            right: 0,
            child: _inkWellRefund(listContent,payPrice),
          ),
        ],
      ),
    );
  }

  Container _containerContentList(
      List<Map<String, dynamic>> listContent, double payPrice) {
    return Container(
      color: Color(0xffffffff),
      margin: EdgeInsets.only(top: Screenutil.length(32)),
      padding: EdgeInsets.only(
        top: Screenutil.length(32),
        left: Screenutil.length(32),
        right: Screenutil.length(32),
        bottom: Screenutil.length(24),
      ),
      child: Column(
        children: listContent
            .map((item) => _containerContent(
                  item['imagePath'],
                  item['content'],
                  item['specs'],
                  item['price'],
                  payPrice,
                  item['shopNum'],
                  listContent
                ))
            .toList(),
      ),
    );
  }

  Container _containerOrderDetail(List<Map<String, dynamic>> listOrderDetail) {
    return Container(
      color: Color(0xffffffff),
      width: double.infinity,
      margin: EdgeInsets.only(top: Screenutil.length(24)),
      padding: EdgeInsets.only(
        top: Screenutil.length(32),
        left: Screenutil.length(31),
        bottom: Screenutil.length(39),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '订单信息',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: BaseStyle.fontSize28,
                color: BaseStyle.color333333),
          ),
          Column(
            children: listOrderDetail
                .map((item) => Container(
                      margin: EdgeInsets.only(top: Screenutil.length(22)),
                      child: Row(
                        children: [
                          Text(
                            item['title'],
                            style: TextStyle(
                                fontSize: BaseStyle.fontSize24,
                                color: BaseStyle.color999999),
                          ),
                          SizedBox(width: Screenutil.length(75)),
                          Text(
                            item['subtitle'],
                            style: TextStyle(
                                fontSize: BaseStyle.fontSize24,
                                color: BaseStyle.color999999),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  InkWell _inkWellBottom(String title, Color color, Color fontColor) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        color: color,
        padding: EdgeInsets.symmetric(
          vertical: Screenutil.length(26.5),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: BaseStyle.fontSize32,
            color: fontColor,
          ),
        ),
      ),
    );
  }

  Positioned _positionedBottomBar(String status) {
    List<Map<String, dynamic>> _listBottom;
    switch (status) {
      case '等待买家付款':
        _listBottom = [
          {
            'title': '修改地址',
            'color': Color(0xff2a2a2a),
            'fontColor': Color(0xffffffff),
          },
          {
            'title': '付款',
            'color': Color(0xffffc40c),
            'fontColor': Color(0xff333333),
          },
        ];
        break;
      case '买家已付款':
        _listBottom = [
          {
            'title': '申请退款',
            'color': Color(0xffffc40c),
            'fontColor': Color(0xff333333),
          },
        ];
        break;
      case '卖家已发货':
        _listBottom = [
          {
            'title': '查看物流',
            'color': Color(0xff2a2a2a),
            'fontColor': Color(0xffffffff),
          },
          {
            'title': '确认收货',
            'color': Color(0xffffc40c),
            'fontColor': Color(0xff333333),
          },
        ];
        break;
      case '退款中':
        _listBottom = [
          {
            'title': '查看物流',
            'color': Color(0xff2a2a2a),
            'fontColor': Color(0xffffffff),
          },
        ];
        break;
      case '交易成功':
        _listBottom = [
          {
            'title': '查看物流',
            'color': Color(0xff2a2a2a),
            'fontColor': Color(0xffffffff),
          },
          {
            'title': '申请售后',
            'color': Color(0xffffc40c),
            'fontColor': Color(0xff333333),
          },
        ];
        break;
      default:
        _listBottom = [];
        break;
    }
    return Positioned(
      bottom: 0,
      child: Container(
        alignment: Alignment.center,
        height: Screenutil.length(98),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: _listBottom
              .map((item) => Expanded(
                    child: _inkWellBottom(
                      item['title'],
                      item['color'],
                      item['fontColor'],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              statusHeight,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _containerHeader(widget.bundle.getMap('details')['status']),
                  _containerAddress(),
                  _containerContentList(
                    widget.bundle.getMap('details')['listContent'],
                    widget.bundle.getMap('details')['payPrice'],
                  ),
                  _containerOrderDetail(
                      widget.bundle.getMap('details')['listOrderDetail']),
                ],
              ),
              _positionedBottomBar(widget.bundle.getMap('details')['status'])
            ],
          ),
        ),
      ),
    );
  }
}
