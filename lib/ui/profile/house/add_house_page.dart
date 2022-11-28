import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/user/user_detail_model.dart';
import 'package:aku_community/pages/sign/sign_func.dart';
import 'package:aku_community/ui/profile/house/house_item.dart';
import 'package:aku_community/ui/profile/house/pick_building_page.dart';
import 'package:aku_community/ui/profile/house/pick_role_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddHousePage extends StatefulWidget {
  AddHousePage({Key? key}) : super(key: key);

  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HouseItem? _item;
  int _roleType = 1;
  DateTimeRange? _range;

  TextStyle get _hintStyle => TextStyle(
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        color: Color(0xFF999999),
      );

  TextStyle get _textStyle => _hintStyle.copyWith(color: Color(0xFF333333));

  // 仅在租客身份下检查租期是否填写
  bool get _rentCheck => _roleType != 3 ? true : _range != null;

  /// 检查按钮是否可点击
  bool get _buttonCanTap =>
      _nameController.text.isNotEmpty &&
      _idController.text.isNotEmpty &&
      _item != null &&
      _rentCheck;

  _renderTile({
    required String title,
    Widget? item,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.w),
          child: Text(title, style: Theme.of(context).textTheme.subtitle2),
        ),
        item ?? SizedBox(),
      ],
    );
  }

  _renderTextField({
    String? hintText,
    TextEditingController? controller,
    FormFieldValidator? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: _textStyle,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: _hintStyle,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 32.w,
          vertical: 30.w,
        ),
      ),
    );
  }

  _renderPicker({
    required String? text,
    required String hintText,
    VoidCallback? onTap,
  }) {
    bool showText = text?.isNotEmpty ?? false;
    return MaterialButton(
      onPressed: onTap,
      minWidth: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.w),
      child: Row(
        children: [
          Text(
            showText ? text! : hintText,
            style: showText ? _textStyle : _hintStyle,
          ),
          Spacer(),
          if (onTap != null)
            Icon(
              CupertinoIcons.chevron_forward,
              size: 38.w,
              color: Color(0xFFE8E8E8),
            ),
        ],
      ),
    );
  }

  _renderDatePicker() {
    String start = DateUtil.formatDate(_range?.start, format: 'yyyy-MM-dd');
    String end = DateUtil.formatDate(_range?.end, format: 'yyyy-MM-dd');
    bool emptyDate = _range == null;
    String startValue = emptyDate ? '请选择开始时间' : start;
    String endValue = emptyDate ? '请选择结束时间' : end;
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.w),
      onPressed: () async {
        DateTimeRange? range = await showDateRangePicker(
          context: context,
          builder: (context, child) {
            return Theme(
              data: ThemeData(primarySwatch: Colors.yellow),
              child: child!,
            );
          },
          firstDate: DateTime.now().subtract(Duration(days: 30)),
          lastDate: DateTime.now().add(Duration(days: 365 * 10)),
        );
        if (range != null) _range = range;
        setState(() {});
      },
      child: Row(
        children: [
          Text(startValue, style: emptyDate ? _hintStyle : _textStyle),
          Expanded(
            child: Icon(Icons.arrow_forward, color: Color(0xFF999999)),
          ),
          Text(endValue, style: emptyDate ? _hintStyle : _textStyle),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() async{
      UserDetailModel? _model = await SignFunc.getUserDetail();
      if (_model != null) {
        _roleType = _model.type??1;
      }
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title: '添加房屋',
      body: Material(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _renderTile(
                title: '小区名称',
                item: _renderPicker(
                  text: S.of(context)!.tempPlotName,
                  hintText: '请选择小区',
                  // 跳转到选择小区页面
                  //
                  // onTap: () {
                  //   Get.to(() => PickPlotPage());
                  // },
                ),
              ),
              _renderTile(
                title: '楼栋、单元、室',
                item: _renderPicker(
                  text: _item?.houseName,
                  hintText: '请选择楼栋、单元、室',
                  onTap: () async {
                    HouseItem? tempItem =
                        await Get.to(() => PickBuildingPage());
                    if (tempItem != null) _item = tempItem;
                    setState(() {});
                  },
                ),
              ),
              _renderTile(
                title: '身份',
                item: _renderPicker(
                  text: PickRolePage.getType(_roleType),
                  hintText: '业主',
                  onTap: () async {
                    // int? role =
                    //     await Get.to(() => PickRolePage(init: _roleType));
                    // if (role != null) {
                    //   _roleType = role;
                    //   setState(() {});
                    // }
                  },
                ),
              ),
              _renderTile(
                title: '姓名',
                item: _renderTextField(
                    hintText: '请输入姓名',
                    controller: _nameController,
                    validator: (text) {
                      if (!RegexUtil.isZh(text)) return '请输入正确的姓名';
                      return null;
                    }),
              ),
              _renderTile(
                title: '身份证号',
                item: _renderTextField(
                  hintText: '请输入身份证号',
                  controller: _idController,
                  validator: (text) {
                    if (!RegexUtil.isIDCard(text)) return '请输入正确的身份证号码';
                    return null;
                  },
                ),
              ),
              if (_roleType == 3)
                _renderTile(
                  title: '租期',
                  item: _renderDatePicker(),
                ),
              SizedBox(),
            ].sepWidget(
                separate: Divider(
              indent: 32.w,
              endIndent: 32.w,
              height: 1.w,
              thickness: 1.w,
            )),
          ),
        ),
      ),
      bottomNavi: ElevatedButton(
        child: Text('提交审核'),
        onPressed: _buttonCanTap
            ? () {
                if (_formKey.currentState!.validate()) {
                  _identifyHouse();
                }
              }
            : null,
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 26.w)),
        ),
      ),
    );
  }

  _identifyHouse() async {
    Map<String, dynamic> params = {
      'estateId': _item!.room.value,
      'name': _nameController.text,
      'type': 1,
      'idType': 1,
      'idNumber': _idController.text,
    };
    if (_roleType == 3) {
      params.putIfAbsent(
          'effectiveTimeStart', () => NetUtil.getDate(_range!.start));
      params.putIfAbsent(
          'effectiveTimeEnd', () => NetUtil.getDate(_range!.end));
    }
    VoidCallback cancel = BotToast.showLoading();
    BaseModel model = await NetUtil().post(
      API.user.authHouse,
      params: params,
      showMessage: true,
    );
    cancel();
    if (model.status!) Get.back(result: true);
  }
}
