import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/extensions/widget_list_ext.dart';
import 'package:aku_community/models/house/lease_echo_model.dart';
import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:aku_community/ui/profile/house/house_item.dart';
import 'package:aku_community/ui/profile/house/lease_relevation/tenant_house_list_page.dart';
import 'package:aku_community/ui/profile/house/pick_building_page.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/bottom_sheets/sex_bottom_sheet.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/others/bee_input_row.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class UserIdentifyPage extends StatefulWidget {
  UserIdentifyPage({Key? key}) : super(key: key);

  @override
  _UserIdentifyPageState createState() => _UserIdentifyPageState();
}

class _UserIdentifyPageState extends State<UserIdentifyPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _indentifyCodeController = TextEditingController();

  TextEditingController _telController = TextEditingController();
  String _sex = '请选择性别';
  String _tel = '';
  HouseItem? _houseItem;

  String get houseItem => _houseItem == null
      ? ''
      : '${_houseItem!.building.label}—${_houseItem!.unit.label}—${_houseItem!.room.label}';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () async {
      LeaseEchoModel _model = await HouseFunc.leaseEcho();
      if (!_model.name.isEmptyOrNull) {
        _nameController.text = _model.name!;
      }
      if (_model.sex != null) {
        HouseFunc.toSex[_model.sex];
      }
      if (_model.tel.isNotEmpty) {
        _telController.text = _model.tel;
      }
      if (!_model.idNumber.isEmptyOrNull) {
        _indentifyCodeController.text = _model.idNumber!;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _indentifyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '用户信息',
      bodyColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(32.w),
        children: [
          BeeInputRow(
            title: '承租人',
            controller: _nameController,
            hintText: '请输入姓名',
            isRequire: true,
          ),
          BeeInputRow.button(
            title: '性别',
            hintText: _sex,
            isRequire: true,
            onPressed: () async {
              await Get.bottomSheet(
                SexBottomSheet(
                  onChoose: (String value) {
                    _sex = value;
                    Get.back();
                    //setState(() {});
                  },
                ),
              );
              if(mounted)
              setState(() {});
            },
          ),
          BeeInputRow(
            title: '手机号码',
           
            isRequire: true,
            hintText: _telController.text, controller: _telController,
          ),
          BeeInputRow(
            title: '身份证号码',
            controller: _indentifyCodeController,
            // formatters: [FilteringTextInputFormatter.digitsOnly],
            hintText: '请输入身份证号',
            isRequire: true,
          ),
          BeeInputRow.button(
            title: '选择入住房屋',
            hintText: houseItem,
            isRequire: true,
            onPressed: () async {
              _houseItem = await Get.to(() => PickBuildingPage());
              setState(() {});
            },
          )
        ].sepWidget(separate: 32.w.heightBox),
      ),
      bottomNavi: BottomButton(
          onPressed: () async {
            if (canSubmit) {
              bool result = await HouseFunc().leaseCertification(
                  _nameController.text,
                  _sex,
                  _telController.text,
                  _indentifyCodeController.text);
              if (result) {
                Get.off(() => TenantHouseListPage());
              } else {
                await Get.dialog(_errorDialog());
              }
            }
          },
          child: '提交'.text.size(32.sp).bold.color(ktextPrimary).make()),
    );
  }

  bool get canSubmit {
    if (_nameController.text.isEmpty) {
      BotToast.showText(text: '姓名不能为空！');
      return false;
    }
    if (_indentifyCodeController.text.isEmpty) {
      BotToast.showText(text: '身份证号码不能为空！');
      return false;
    }
    if (_sex == '请选择性别') {
      BotToast.showText(text: '请先选择性别');
      return false;
    }
    return true;
  }

  // Widget _identifyBottomSheet() {
  //   return CupertinoActionSheet(
  //     title:
  //         '选择身份'.text.size(32.sp).bold.color(ktextPrimary).isIntrinsic.make(),
  //     cancelButton: TextButton(
  //         onPressed: () => Get.back(),
  //         child: '取消'.text.size(28.sp).color(ktextSubColor).isIntrinsic.make()),
  //     actions: [
  //       CupertinoActionSheetAction(
  //           onPressed: () {
  //             _identify = '业主';
  //             Get.back();
  //           },
  //           child:
  //               '业主'.text.size(30.sp).color(ktextPrimary).isIntrinsic.make()),
  //       CupertinoActionSheetAction(
  //           onPressed: () {
  //             _identify = '租户';
  //             Get.back();
  //           },
  //           child: '租户'.text.size(30.sp).color(ktextPrimary).isIntrinsic.make())
  //     ],
  //   );
  // }

  Widget _errorDialog() {
    return CupertinoAlertDialog(
      title:
          '账户不存在'.text.size(34.sp).color(ktextPrimary).bold.isIntrinsic.make(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '原因:'.text.size(26.sp).color(ktextPrimary).bold.isIntrinsic.make(),
          '1.用户未具备相关资格'
              .text
              .size(26.sp)
              .color(ktextPrimary)
              .bold
              .isIntrinsic
              .make(),
          '2.用户填写的姓名及身份证号与登记在册的姓名及身份证号并不一致'
              .text
              .size(26.sp)
              .color(ktextPrimary)
              .align(TextAlign.left)
              .bold
              .isIntrinsic
              .make(),
        ],
      ),
      actions: [
        CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child:
                '返回'.text.size(34.sp).isIntrinsic.color(ktextPrimary).make()),
        CupertinoDialogAction(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: '回到首页'
                .text
                .size(34.sp)
                .isIntrinsic
                .color(Color(0xFFFF8200))
                .make()),
      ],
    );
  }
}
