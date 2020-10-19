import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:akuCommunity/utils/screenutil.dart';
import 'package:akuCommunity/base/base_style.dart';
import 'package:akuCommunity/routers/page_routers.dart';

class OrderCard extends StatefulWidget {
  final String status;
  final double totalPrice, payPrice;
  final List<Map<String, dynamic>> listButton, listContent, listOrderDetail;
  OrderCard(
      {Key key,
      this.status,
      this.totalPrice,
      this.payPrice,
      this.listButton,
      this.listContent,
      this.listOrderDetail})
      : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Container _containerStatus(String status) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: Screenutil.length(13)),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xffd8d8d8), width: 0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: BaseStyle.fontSize28,
          color: BaseStyle.color333333,
        ),
      ),
    );
  }

  Container _containerContent(
      String imagePath, content, specs, double price, int shopNum) {
    return Container(
      margin: EdgeInsets.only(top: Screenutil.length(24)),
      child: Stack(
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
                    width: Screenutil.length(262),
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
          Positioned(
            top: 0,
            right: Screenutil.length(8),
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
        ],
      ),
    );
  }

  Container _containerContentList(List<Map<String, dynamic>> listContent) {
    return Container(
      child: Column(
        children: listContent
            .map((item) => _containerContent(
                  item['imagePath'],
                  item['content'],
                  item['specs'],
                  item['price'],
                  item['shopNum'],
                ))
            .toList(),
      ),
    );
  }

  Container _containerPayInfo(double totalPrice, payPrice) {
    return Container(
      margin: EdgeInsets.only(right: Screenutil.length(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '总价￥${totalPrice}',
            style: TextStyle(
              fontSize: BaseStyle.fontSize28,
              color: BaseStyle.color999999,
            ),
          ),
          SizedBox(width: Screenutil.length(16)),
          Text(
            '实付款￥${payPrice}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: BaseStyle.fontSize28,
              color: BaseStyle.color333333,
            ),
          ),
        ],
      ),
    );
  }

  InkWell _inkWellButton(String buttonName) {
    Color buttonColor;
    switch (buttonName) {
      case '确认收货':
      case '评价':
      case '付款':
        buttonColor = BaseStyle.colorff8500;
        break;
      default:
        buttonColor = BaseStyle.color999999;
    }
    return InkWell(
      onTap: () {
        switch (buttonName) {
          case '评价':
            Navigator.pushNamed(context, PageName.evaluate_good_page.toString(),
                arguments: Bundle()
                  ..putMap('details', {
                    'listContent': widget.listContent,
                  }));
            break;
          case '查看物流':
            Navigator.pushNamed(
                context, PageName.look_logistics_page.toString());
            break;
          default:
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: Screenutil.length(16)),
        alignment: Alignment.center,
        width: Screenutil.length(171),
        height: Screenutil.length(60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: buttonColor, width: 1),
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: BaseStyle.fontSize28,
            color: buttonColor,
          ),
        ),
      ),
    );
  }

  Container _containerButtonList(List<Map<String, dynamic>> listButton) {
    return Container(
      margin: EdgeInsets.only(
        top: Screenutil.length(42),
        right: Screenutil.length(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: listButton
            .map((item) => _inkWellButton(item['buttonName']))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, PageName.order_details_page.toString(),
            arguments: Bundle()
              ..putMap('details', {
                'status': widget.status,
                'listContent': widget.listContent,
                'totalPrice': widget.totalPrice,
                'payPrice': widget.payPrice,
                'listButton': widget.listButton,
                'listOrderDetail': widget.listOrderDetail,
              }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: Offset(1, 1),
                blurRadius: 10.0),
          ],
        ),
        padding: EdgeInsets.only(
          top: Screenutil.length(18),
          left: Screenutil.length(20),
          right: Screenutil.length(16),
          bottom: Screenutil.length(42),
        ),
        margin: EdgeInsets.only(
          top: Screenutil.length(24),
          left: Screenutil.length(32),
          right: Screenutil.length(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _containerStatus(widget.status),
            _containerContentList(widget.listContent),
            _containerPayInfo(
              widget.totalPrice,
              widget.payPrice,
            ),
            widget.listButton.length != 0
                ? _containerButtonList(widget.listButton)
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
