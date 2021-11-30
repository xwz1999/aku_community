import 'package:aku_community/model/order/order_list_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/market/order/my_order_list_model.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/ui/market/order/my_order_card.dart';

import 'order_card.dart';

class OrderView extends StatefulWidget {
  final int? index;
  OrderView({Key? key, required this.index}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late EasyRefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeListView(
        path: API.market.myOrder,
        controller: _refreshController,
        extraParams: {"tradeStatus": widget.index,'orderCode':null},
        convert: (models) {
          return models.tableList!
              .map((e) => OrderListModel.fromJson(e))
              .toList();
        },
        builder: (items) {
          return ListView.builder(
              padding: EdgeInsets.symmetric( horizontal: 20.w),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top:20.w),
                  child: OrderCard(
                    model: items[index],
                    callRefresh: () {
                      _refreshController.callRefresh();
                    },
                  ),
                );
              },
              // separatorBuilder: (_, __) {
              //   return 24.w.heightBox;
              // },
              itemCount: items.length);
        });
  }
}
