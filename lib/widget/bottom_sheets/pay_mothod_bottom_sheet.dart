import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';

class PayMethodBottomSheet extends StatelessWidget {
  final Function(String value) onChoose;
  const PayMethodBottomSheet({Key? key, required this.onChoose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title:
          '支付方式'.text.size(32.sp).bold.color(ktextPrimary).isIntrinsic.make(),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () => onChoose('支付宝'),
            child:
                '支付宝'.text.size(32.sp).color(ktextPrimary).isIntrinsic.make()),
        CupertinoActionSheetAction(
            onPressed: () => onChoose('微信'),
            child:
            '微信'.text.size(32.sp).color(ktextPrimary).isIntrinsic.make())
      ],
    );
  }
}
