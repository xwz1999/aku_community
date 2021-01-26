// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:akuCommunity/utils/headers.dart';

class AddressEditItem extends StatefulWidget {
  final Map addressInfo;
  AddressEditItem({Key key, this.addressInfo}) : super(key: key);

  @override
  _AddressEditItemState createState() => _AddressEditItemState();
}

class _AddressEditItemState extends State<AddressEditItem> {
  TextEditingController _userName = new TextEditingController();
  TextEditingController _userPhone = new TextEditingController();
  TextEditingController _userAddress = new TextEditingController();
  TextEditingController _userAddressDetail = new TextEditingController();
  RegExp phoneReg = RegExp(
      '^((13[0-9])|(15[^4])|(16[0-9])|(17[0-9])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');

  @override
  void initState() {
    super.initState();
    _userName = new TextEditingController(text: widget.addressInfo['name']);
    _userPhone = new TextEditingController(text: widget.addressInfo['phone']);
    _userAddress = new TextEditingController(text: widget.addressInfo['address']);
    _userAddressDetail = new TextEditingController(text: widget.addressInfo['address']);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _listTextField = [
      {'title': '收货人', 'hintText': '请输入', 'controller': _userName},
      {'title': '手机号码', 'hintText': '请输入', 'controller': _userPhone},
      {'title': '所在地区', 'hintText': '请输入', 'controller': _userAddress},
      {
        'title': '详细地址',
        'hintText': '比如街道、门牌号、小区、楼栋号',
        'controller': _userAddressDetail
      },
    ];
    List<Widget> _listTextFieldView() {
      return _listTextField
          .map((item) => TextFormField(
                inputFormatters: item['title'] == '手机号码'
                    ? [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    : [],
                keyboardType: item['title'] == '手机号码'
                    ? TextInputType.number
                    : TextInputType.name,
                cursorColor: Color(0xffffc40c),
                style: TextStyle(fontSize: 28.sp),
                controller: item['controller'],
                onChanged: (String value) {},
                maxLines: item['title'] == '详细地址' ? 5 : 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    right: 32.w,
                    top: 28.w,
                    bottom: 28.w,
                  ),
                  hintText: item['hintText'],
                  border: InputBorder.none, //去掉输入框的下滑线
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(
                      color: Color(0xff999999), fontSize: 28.sp),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: 32.w,
                      right:
                          (item['title'] == '收货人' ? 88 : 60).w,
                      top: 28.w,
                      bottom:
                          (item['title'] == '详细地址' ? 158 : 28).w,
                    ),
                    child: Text(
                      item['title'],
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ))
          .toList();
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: _listTextFieldView(),
      ),
    );
  }
}
