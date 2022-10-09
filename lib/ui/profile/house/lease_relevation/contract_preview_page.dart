import 'dart:typed_data';

import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';


import 'package:bot_toast/bot_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:power_logger/power_logger.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:aku_community/ui/profile/house/lease_relevation/download_contract_page.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/others/sign_name_board.dart';

class ContractPreviewPage extends StatefulWidget {
  final String url;
  final int id;
  ContractPreviewPage({Key? key, required this.url, required this.id})
      : super(key: key);

  @override
  _ContractPreviewPageState createState() => _ContractPreviewPageState();
}

class _ContractPreviewPageState extends State<ContractPreviewPage> {
  Uint8List? _signName;
  PDFDocument? doc;
  int _currentPage = -1;
  PageController? _pageController = PageController();
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () async {
      Function cancel = BotToast.showLoading();
      doc = await PDFDocument.fromURL(API.image(widget.url));
      cancel();
      _currentPage = 0;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var signName = GestureDetector(
      child: DottedBorder(
        child: Container(
          alignment: Alignment.center,
          width: 200.w,
          height: 100.w,
          color: Colors.white.withOpacity(0.7),
          child: _signName != null
              ? Image.memory(
                  _signName!,
                  fit: BoxFit.fitWidth,
                )
              : '签字区'.text.size(28.sp).bold.color(ktextPrimary).make(),
        ),
      ),
      onTap: () async {
        _signName = await SignNameBoard.defalutBoard();
        setState(() {});
      },
    );
    return BeeScaffold(
      title: '合同预览',
      body: Stack(
        children: [
          Center(
            child: doc == null
                ? SizedBox()
                : PDFViewer(
                    showPicker: false,
                    controller: _pageController,
                    // onPageChanged: (value) {
                    //   _currentPage = value;
                    //   setState(() {});
                    // },
                    document: doc!),
          ),
          Positioned(
              right: 70.w,
              bottom: 200.w,
              child: _currentPage != 0 ? SizedBox() : signName),
        ],
      ),
      bottomNavi: BottomButton(
          onPressed: () async {
            Function cancel = BotToast.showLoading();
            if (_signName != null) {
              try {
                String result = await HouseFunc().uploadSignName(_signName!);
                String path = await HouseFunc()
                    .generateContract(widget.id, widget.url, result);
                if (path.isNotEmpty) {
                  Get.back();
                  Get.back();
                  Get.off(
                      () => DownLoadContractPage(path: path, id: widget.id));
                }
              } catch (e) {
                LoggerData.addData(e);
                print(e);
              }
            } else {
              BotToast.showText(text: '请先签名！');
            }
            cancel();
          },
          child: '生成合同'.text.size(32.sp).color(ktextPrimary).make()),
    );
  }
}
