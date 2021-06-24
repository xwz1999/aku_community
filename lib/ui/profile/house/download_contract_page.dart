import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/others/finish_result_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class DownLoadContractPage extends StatefulWidget {
  final bool firstRoute;
  DownLoadContractPage({Key? key, required this.firstRoute}) : super(key: key);

  @override
  _DownLoadContractPageState createState() => _DownLoadContractPageState();
}

class _DownLoadContractPageState extends State<DownLoadContractPage> {
  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '合同信息',
      body: Center(
        child: Column(
          children: [
            80.w.heightBox,
            FinishResultImage(status: true),
            48.w.heightBox,
            '${widget.firstRoute ? '生成成功' : '合同已生成'}'
                .text
                .size(36.sp)
                .color(ktextPrimary)
                .make(),
            24.w.heightBox,
            '请下载合同'.text.size(26.sp).color(ktextSubColor).make(),
            '完善信息并盖章后再上传合同'.text.size(26.sp).color(ktextSubColor).make(),
            126.w.heightBox,
            Row(
              children: [
                MaterialButton(
                  color: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical:16.w ,horizontal: 78.w),
                  onPressed: () {},
                  child:
                      '下载合同'.text.size(32.sp).bold.color(ktextPrimary).make(),
                ).expand(),
                MaterialButton(
                  padding: EdgeInsets.symmetric(vertical:16.w ,horizontal: 78.w),
                  elevation: 0,
                  color: kPrimaryColor,
                  onPressed: () {},
                  child:
                      '上传文件'.text.size(32.sp).bold.color(ktextPrimary).make(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
