import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';

class SexBottomSheet extends StatelessWidget {
  final Function(String value) onChoose;
  const SexBottomSheet({Key? key, required this.onChoose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title:
          '选择性别'.text.size(32.sp).bold.color(ktextPrimary).isIntrinsic.make(),
      cancelButton: TextButton(
          onPressed: () => Get.back(),
          child: '取消'.text.size(28.sp).color(ktextSubColor).isIntrinsic.make()),
      actions: [
        CupertinoActionSheetAction(
            onPressed:(){
              onChoose('男');
            },
            child: '男'.text.size(30.sp).color(ktextPrimary).isIntrinsic.make()),
        CupertinoActionSheetAction(
            onPressed:(){
              onChoose('女');
            },
            child: '女'.text.size(30.sp).color(ktextPrimary).isIntrinsic.make())
      ],
    );
  }
}
