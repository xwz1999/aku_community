import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:akuCommunity/utils/screenutil.dart';
import 'package:akuCommunity/base/base_style.dart';
import 'package:akuCommunity/widget/bottom_button.dart';
import 'package:akuCommunity/widget/common_input.dart';
import 'common_select.dart';
import 'house_info.dart';
import 'pay_model_sheet.dart';

class OwnerManage extends StatefulWidget {
  OwnerManage({Key key}) : super(key: key);

  @override
  _OwnerManageState createState() => _OwnerManageState();
}

class _OwnerManageState extends State<OwnerManage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController _companyName = new TextEditingController();
  TextEditingController _contactsName = new TextEditingController();
  TextEditingController _contactsPhone = new TextEditingController();

  List<Map<String, dynamic>> _listHouse = [
    {'title': '宁波华茂悦峰', 'subtitle': '1幢-1单元-702室'},
  ];

  List<Map<String, dynamic>> _listWidget = [];

  @override
  void initState() {
    super.initState();
    _listWidget = [
      {
        'title': '装修公司',
        'widget':
            CommonInput(inputController: _companyName, hintText: '请输入公司名称')
      },
      {
        'title': '房屋紧急联系人',
        'widget':
            CommonInput(inputController: _contactsName, hintText: '请输入联系人姓名')
      },
      {
        'title': '联系方式',
        'widget':
            CommonInput(inputController: _contactsPhone, hintText: '请输入联系方式')
      },
      {'title': '预计开始时间', 'widget': CommonSelect(title: '时间')},
      {'title': '预计结束时间', 'widget': CommonSelect(title: '时间')},
    ];
  }

  void _showModelBotoomSheet() {
    showModalBottomSheet(
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return PayModelSheet();
      },
    );
  }

  List<Widget> _listView() {
    return _listWidget
        .asMap()
        .keys
        .map((index) => Container(
              padding: EdgeInsets.only(
                top: Screenutil.length(23),
                bottom: Screenutil.length(24),
              ),
              margin: EdgeInsets.only(
                  bottom: Screenutil.length(index == 2 ? 117 : 0)),
              decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: BaseStyle.coloreeeeee, width: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _listWidget[index]['title'],
                    style: TextStyle(
                        fontSize: BaseStyle.fontSize28,
                        color: BaseStyle.color333333),
                  ),
                  SizedBox(height: Screenutil.length(25)),
                  _listWidget[index]['widget'],
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: Screenutil.length(32),
                    left: Screenutil.length(32),
                    right: Screenutil.length(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: _listHouse
                            .map((item) => HouseInfo(
                                  title: item['title'],
                                  subtitle: item['subtitle'],
                                ))
                            .toList(),
                      ),
                      Column(
                        children: _listView(),
                      ),
                      SizedBox(height: Screenutil.length(89)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: BottomButton(
              title: '申请付款',
              fun: _showModelBotoomSheet,
            ),
          )
        ],
      ),
    );
  }
}
