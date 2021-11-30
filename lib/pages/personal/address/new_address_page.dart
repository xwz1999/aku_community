import 'dart:convert';
import 'dart:ui';
import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/model/user/province_model.dart';
import 'package:aku_community/pages/personal/user_func.dart';
import 'package:aku_community/utils/hive_store.dart';
import 'package:aku_community/utils/text_utils.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/utils/headers.dart';

import 'address_selector.dart';
import 'editView.dart';

class NewAddressPage extends StatefulWidget {
  final bool? isFirstAdd;
  final AddressModel? addressModel;
  final EasyRefreshController? refreshController;

  NewAddressPage({Key? key, this.isFirstAdd, this.addressModel, this.refreshController})
      : super(key: key);

  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> {
  EasyRefreshController _refreshController = EasyRefreshController();
  late AddressModel _address = AddressModel.empty();
  late List<ProvinceModel> _cityJsonModels = [];
  late StateSetter _addressStateSetter;
  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.addressModel != null) {
      _address = widget.addressModel!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
      title:widget.addressModel==null? '新建收货地址':'修改收货地址',
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.only(top: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24.w)),
            ),
            child: Column(
              children: [
                EditTile(
                  constraints: BoxConstraints.tight(Size(double.infinity, 45)),
                  title: "收货人",
                  titleStyle: TextStyle(fontSize: 28.sp, color: ktextPrimary),
                  hintStyle: TextStyle(fontSize: 28.sp, color: Color(0xFFBBBBBB)),
                  textStyle: TextStyle(fontSize: 28.sp, color: ktextSubColor),
                  value: _address.name ?? '',
                  hint: "请填写收货人姓名",
                  textChanged: (value) {
                    _address.name = value;
                  },
                ),
                Container(
                    height: 2.w,
                    color: Color(0xFFD9D9D9),
                    margin: EdgeInsets.symmetric(horizontal: 24.w)),
                EditTile(
                  constraints: BoxConstraints.tight(Size(double.infinity, 100.w)),
                  title: "手机号码",
                  titleStyle: TextStyle(fontSize: 28.sp, color: ktextPrimary),
                  hintStyle: TextStyle(fontSize: 28.sp, color: Color(0xFFBBBBBB)),
                  textStyle: TextStyle(fontSize: 28.sp, color: ktextSubColor),
                  value: _address.tel ?? '',
                  hint: "请填写收货人手机号码",
                  maxLength: 11,
                  textChanged: (value) {
                    _address.tel = value;
                  },
                ),
                Container(
                    height: 2.w,
                    color: Color(0xFFD9D9D9),
                    margin: EdgeInsets.symmetric(horizontal: 24.w)),
                _addressView(),
                Container(
                    height: 2.w,
                    color: Color(0xFFD9D9D9),
                    margin: EdgeInsets.symmetric(horizontal: 24.w)),

                Container(
                  height: 20.w,
                ),
                EditTile(
                  title: "详细地址",
                  hint: "街道门牌号等",
                  titleStyle: TextStyle(fontSize: 28.sp, color: ktextPrimary),
                  hintStyle: TextStyle(fontSize: 28.sp, color: Color(0xFFBBBBBB)),
                  textStyle: TextStyle(fontSize: 28.sp, color: ktextSubColor),
                  value: _address.addressDetail ?? '',
                  maxLength: 100,
                  maxLines: 3,
                  direction: Axis.vertical,
                  constraints: BoxConstraints(maxHeight: 100),
                  textChanged: (value) {
                    _address.addressDetail = value;
                  },
                ),
                Container(
                    height: 2.w,
                    color: Color(0xFFD9D9D9),
                    margin: EdgeInsets.symmetric(horizontal: 24.w)),
                Container(
                  height: 30.w,
                ),
              ],
            ),
          ),
          _defaultAddressTile(),
          // _defaultAddressTile(),
          Container(
            height: 100,
          ),
          _saveButton(context)
        ],
      ),
    );
  }

  Container _saveButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 100.w),

      child: GestureDetector(
        onTap: () {
          _saveAddress(context);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(40.w), right: Radius.circular(40.w)),
          ),
          height: 80.w,
          padding: EdgeInsets.symmetric(vertical: 8.w),
          child: Text(
            "保存并使用",
            style: TextStyle(
              color: Colors.white,
              fontSize:28.sp,
            ),
          ),
        ),
      ),
    );
  }

  _addressView() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setSta) {
        _addressStateSetter = setSta;
        return GestureDetector(
          onTap: () {
            print('1');
            if (_cityJsonModels.isEmpty) {
              print('2');
              getCityList().then((success) {
                if (success) {
                  _selectAddress(context);
                }
              });
              return;
            }
            _selectAddress(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 24.w),
            child: Row(
              children: <Widget>[
                Container(
                  width: 120.w,
                  child: Text("所在地区",
                      style: TextStyle(fontSize: 28.sp, color: ktextPrimary)),
                ),
                Expanded(
                    child: Text(
                  TextUtils.isEmpty(_address.locationName ?? '')
                      ? "选择地址"
                      : "${_address.locationName}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 28.sp, color: Color(0xFFBBBBBB)),
                )),
                Icon(
                  Icons.navigate_next,
                  size: 40.w,
                  color: ktextThirdColor,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// 弹出地址选择
  _selectAddress(BuildContext context) {
    AddressSelectorHelper.show(context,
        models: _cityJsonModels,
        province: _address.province,
        city: _address.city,
        district: _address.district, callback:
            (String province, String city, String district, int? locationId) {
      _address.province = province;
      _address.city = city;
      _address.district = district;
      _address.locationName = province + city + district;
      _address.location = locationId ?? null;
      _addressStateSetter(() {});
      print("$province - $city -$district");
    });
  }

  Future<bool> getCityList() async {
    _cityJsonModels = await (HiveStore.appBox?.get('cityList') ?? [])
        .cast<ProvinceModel>()
        .toList();
    return true;
  }

  /// 保存地址
  _saveAddress(BuildContext context) async {
    if (TextUtils.isEmpty(_address.name ?? "")) {
      BotToast.showText(text: '收货人不能为空');
      return;
    }

    if (TextUtils.isEmpty(_address.tel ?? '') ||
        !TextUtils.verifyPhone(_address.tel)) {
      BotToast.showText(text: '手机号格式不正确');
      return;
    }

    if (_address.location==null) {
      BotToast.showText(text: '所在地区不能为空');
      return;
    }

    if (TextUtils.isEmpty(_address.addressDetail ?? '')) {
      BotToast.showText(text: '详细地址不能为空');
      return;
    }

    if (_address.id == null) {
      Userfunc.insertAddress(
          _address.name ?? '',
          _address.tel ?? '',
          _address.location ?? null,
          _address.addressDetail ?? '',
          _address.isDefault ?? null);
    } else {
      Userfunc.updateAddress(
          _address.id!,
          _address.name ?? '',
          _address.tel ?? '',
          _address.location ?? null,
          _address.addressDetail ?? '',
          _address.isDefault ?? null);
    }


    //Navigator.maybePop<dynamic>(context, _address);
    Get.back(result: true);
  }

  _defaultAddressTile() {

    if (widget.isFirstAdd != null)
      if(_address.isDefault ==1){
        isDefault = true;
      }else{
        isDefault = false;
        widget.isFirstAdd! ? _address.isDefault = 1 : _address.isDefault = 0;
      }

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.only(top: 24.w,bottom: 24.w,left: 24.w,right: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '设置为默认地址'.text.size(28.sp).color(ktextPrimary).make(),
              5.hb,
              '提醒：每次下单会默认推荐使用该地址'.text.size(24.sp).color(Color(0xFFBBBBBB)).make(),
            ],
          ),
          Spacer(),
          CupertinoSwitch(
              value: isDefault,
              onChanged: (value) {
                if (value) {
                  isDefault = value;
                  _address.isDefault = 1;
                  print(1);
                } else {
                  isDefault = value;
                  _address.isDefault = 0;
                  print(0);
                }
                setState(() {});
              })
        ],
      ),
    );


  }

}
