import 'package:aku_community/const/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';

class PayBottomSheet extends StatelessWidget {
  final Function(String value) onChoose;
  const PayBottomSheet({Key? key, required this.onChoose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              20.widthBox,
              SizedBox(width: 20.w,),
              Spacer(),
              '支付方式'.text.size(32.sp).bold.color(ktextPrimary).isIntrinsic.make(),
              Spacer(),
              IconButton(onPressed: (){
                Get.back();
              }, icon: Icon(
                Icons.clear,size: 40.w,)),

            ],
          ),
          Divider(
            height: 2.w,
            thickness: 2.w,
            color: Color(0xFFf7f7f7),
          ),
          15.heightBox,
          GestureDetector(
            onTap: ()=>onChoose('微信'),
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  15.widthBox,
                  Image.asset(R.ASSETS_ICONS_IC_WX_PNG,width: 50.w,height: 50.w,),
                  5.widthBox,
                  '微信'.text.size(30.sp).color(ktextPrimary).isIntrinsic.make(),
                  Spacer(),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 40.w,
                    color: Color(0xFF999999),
                  ),
                  10.widthBox,
                ],
              ),
            ),
          ),
          15.heightBox,
          Divider(
            height: 2.w,
            thickness: 2.w,
            indent: 20.w,
            endIndent: 20.w,
            color: Color(0xFFf7f7f7),
          ),
          15.heightBox,
          GestureDetector(
            onTap: ()=>onChoose('支付宝'),
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  15.widthBox,
                  Image.asset(R.ASSETS_ICONS_IC_ZFB_PNG,width: 50.w,height: 50.w,),
                  5.widthBox,
                  '支付宝'.text.size(30.sp).color(ktextPrimary).isIntrinsic.make(),
                  Spacer(),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 40.w,
                    color: Color(0xFF999999),
                  ),
                  10.widthBox,
                ],
              ),
            ),
          ),
          15.heightBox,
          Divider(
            height: 2.w,
            thickness: 2.w,
            indent: 20.w,
            endIndent: 20.w,
            color: Color(0xFFf7f7f7),
          ),
          10.heightBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '对公转账'.text.size(30.sp).color(ktextPrimary).isIntrinsic.make(),
              10.heightBox,
              Text('开票名称：广西印象物业服务有限责任公司\n纳税人识别号：9145010057940'
                  '3297H\n地址：中国（广西）自由贸易试验区南宁片区凯旋路16号南宁五\n像总'
                  '部基地广东大厦十九层1901号\n电话：0771-5673216-888\n'
                  '开户行：农业银行南宁桂城支行\n'
                  '账号：2001 6701 0400 08513',style: TextStyle(fontSize: 25.sp,color: Color(0xFF666666)),)
            ],
          )

        ],
      ),
    );
  }
}
