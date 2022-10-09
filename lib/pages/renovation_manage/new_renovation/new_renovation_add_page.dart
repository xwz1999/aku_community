import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:get/get.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/extensions/widget_list_ext.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_divider.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/buttons/bottom_button.dart';
import 'package:aku_community/widget/others/bee_input_row.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:aku_community/widget/picker/bee_date_picker.dart';

class NewRenovationAddPage extends StatefulWidget {
  NewRenovationAddPage({Key? key}) : super(key: key);

  @override
  _NewRenovationAddPageState createState() => _NewRenovationAddPageState();
}

class _NewRenovationAddPageState extends State<NewRenovationAddPage> {
  late TextEditingController _unitController;
  late TextEditingController _directorController;
  late TextEditingController _telController;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _unitController = TextEditingController();
    _directorController = TextEditingController();
    _telController = TextEditingController();
  }

  @override
  void dispose() {
    _unitController.dispose();
    _directorController.dispose();
    _telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '申请装修',
      body: ListView(
        children: [
          32.w.heightBox,
          _buildInputCard(),
          _datePick(),
        ],
      ),
      bottomNavi: BottomButton(
          onPressed: () async {
            if (UserTool.appProveider.selectedHouse != null) {
              BaseModel baseModel =
                  await NetUtil().post(API.manager.insertNewRenovation,
                      params: {
                        "estateId":
                            UserTool.appProveider.selectedHouse!.estateId,
                        "constructionUnit": _unitController.text,
                        "director": _directorController.text,
                        "directorTel": _telController.text,
                        "expectedBegin": DateUtil.formatDate(startDate),
                        "expectedEnd": DateUtil.formatDate(endDate)
                      },
                      showMessage: true);

              if (baseModel.status ?? false) {
                Get.back(result: true);
              }
            } else {
              BotToast.showText(text: '您未拥有通过审核的房产!');
            }
          },
          child: '立即申请'.text.size(32.sp).color(ktextPrimary).bold.make()),
    );
  }

  Widget _buildInputCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: <Widget>[
          BeeInputRow(
              title: '装修公司名称',
              controller: _unitController,
              hintText: '请输入装修公司名称'),
          BeeInputRow(
              title: '负责人姓名',
              controller: _directorController,
              hintText: '请输入负责人姓名'),
          BeeInputRow(
              title: '负责人电话', controller: _telController, hintText: '请输入联系电话'),
        ].sepWidget(separate: 40.w.heightBox),
      ),
    );
  }

  Widget _datePick() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.w),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '预约时间',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).pSymmetric(h: 32.w),
          SizedBox(
            height: 120.w,
            child: Row(
              children: [
                MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  height: 120.w,
                  onPressed: () async {
                    DateTime _currentTime = DateTime.now();
                    DateTime? date = await BeeDatePicker.pick(
                      _currentTime.add(Duration(minutes: 60)),
                      mode: CupertinoDatePickerMode.dateAndTime,
                      min: _currentTime.add(Duration(minutes: 30)),
                      max: _currentTime.add(Duration(days: 30)),
                    );
                    if (date != null) {
                      startDate = date;
                      setState(() {});
                    }
                  },
                  child: Text(
                    startDate == null
                        ? '请选择开始时间'
                        : DateUtil.formatDate(
                            startDate,
                            format: 'yyyy-MM-dd HH:mm',
                          ),
                    style: TextStyle(
                      color: ktextSubColor,
                    ),
                  ),
                ).expand(),
                Icon(Icons.arrow_forward),
                MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  height: 120.w,
                  onPressed: () async {
                    DateTime? date = await BeeDatePicker.pick(
                      startDate == null
                          ? DateTime.now().add(Duration(minutes: 90))
                          : startDate!.add(Duration(minutes: 30)),
                      min: startDate == null
                          ? DateTime.now().add(Duration(minutes: 60))
                          : startDate!.add(Duration(minutes: 30)),
                      max: startDate == null
                          ? DateTime.now().add(Duration(days: 2))
                          : (startDate!).add(Duration(days: 2)),
                      mode: CupertinoDatePickerMode.dateAndTime,
                    );
                    if (date != null) {
                      endDate = date;
                      setState(() {});
                    }
                  },
                  child: Text(
                    endDate == null
                        ? '请选择结束时间'
                        : DateUtil.formatDate(
                            endDate,
                            format: 'yyyy-MM-dd HH:mm',
                          ),
                    style: TextStyle(
                      color: ktextSubColor,
                    ),
                  ),
                ).expand(),
              ],
            ),
          ),
          BeeDivider.horizontal(
            indent: 32.w,
            endIndent: 32.w,
          ),
        ],
      ),
    );
  }
}
