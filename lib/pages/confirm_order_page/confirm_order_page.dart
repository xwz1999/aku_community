import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:akuCommunity/utils/screenutil.dart';
import 'package:akuCommunity/routers/page_routers.dart';
import 'package:akuCommunity/widget/common_app_bar.dart';
import 'widget/confirm_address.dart';
import 'widget/confirm_content.dart';
import 'widget/confirm_bottom_bar.dart';

class ConfirmOrderPage extends StatelessWidget {
  final Bundle bundle;
  ConfirmOrderPage({Key key, this.bundle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: CommonAppBar(title: '确认订单'),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: Screenutil.length(98)),
            children: [
              SizedBox(height: Screenutil.length(20)),
              ConfirmAddress(),
              SizedBox(height: Screenutil.length(20)),
              ConfirmContent(cartMap: bundle.getMap('cartMap')),
            ],
          ),
          Positioned(
            bottom: 0,
            child: ConfirmBottomBar(cartMap: bundle.getMap('cartMap')),
          ),
        ],
      ),
    );
  }
}
