/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-17  09:41 
 * remark    : 
 * ====================================================
 */
import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/model/user/province_model.dart';
import 'package:aku_community/utils/text_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:aku_community/utils/headers.dart';

typedef AddressSelectorCallback = Function(
    String province, String city, String disctrict,int? locationId);

class AddressSelector extends StatefulWidget {
  final List<ProvinceModel> model;
  final String province;
  final String city;
  final String district;
  final AddressSelectorCallback callback;

  const AddressSelector(
      {required this.model,
      this.province = "",
      this.city = "",
      this.district = "",
      required this.callback})
      : assert(model != null),
        assert(callback != null);

  @override
  _AddressSelectorState createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  late List<List<String>> _items;
  late List<String> _result;
  late List<int?> _indexs;
  late ProvinceModel _province;
  late City? _city;
  late District? _district;
  Color _selectedColor = Colors.black;
  late BuildContext _context;
  late bool _tab = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _items = [[], [], []];
    _indexs = [null, null, null];
    _result = [widget.province, widget.city, widget.district];
    _filterAddress();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return GestureDetector(
      onTap: () {},
      child: _buildBody(context),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Container _buildBody(BuildContext context) {
    return Container(
      height: 1000.w,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[_header(), _tabBar(), 10.hb, _list()],
      ),
    );
  }

  Container _header() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.w),
      child: Row(
        children: <Widget>[
          Spacer(),
          Text(
            "请选择所在地区",
            style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w500,
                color:ktextPrimary),
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              _dismiss();
            },
            child: Container(
              padding: EdgeInsets.all(5.w),
              decoration:BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.w)),
                color: Colors.white,
              ),
              child: Icon(
                Icons.close,
                color: Colors.grey[500],
                size: 40.w,
              ),
            ),
          )
        ],
      ),
    );
  }

  TabBar _tabBar() {
    return TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.only(top: 5.w),
        unselectedLabelColor: Color(0xFFE52E2E),
        isScrollable: true,
        indicatorColor: Color(0xFFE52E2E),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.only(left: 10.w, right: 10.w,bottom: -5.w),
        tabs: _tabItems());
  }

  _tabItems() {
    List<Widget> list = [];
    // for (int i = 0; i < _items.length; ++i) {
    for (int i = 0; i < _tabController.length; ++i) {
      List addressModels = _items[i];
      if (addressModels == null || addressModels.length == 0) {
        list.add(Container());
        continue;
      }
      list.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        height: 40.w,
        alignment: Alignment.center,
        child: Text(
          TextUtils.isEmpty(_result[i]) ? "请选择" : _result[i],
          style: TextStyle(
              fontSize: 16 * 2.sp,
              color: _tabController.index == i ? _selectedColor : Colors.black),
        ),
      ));
    }

    return list;
  }

  Expanded _list() {
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _items[_tabController.index].length,
          itemBuilder: (context, index) {
            String addr = _items[_tabController.index][index];
            bool selected = addr == _result[_tabController.index];
            return
              GestureDetector(
                onTap: (){
                  _itemSelected(index);
                },
                child: Container(
                padding: EdgeInsets.zero,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 10.w),
                  child: Row(children: [
                    Text(
                      addr,
                      style: TextStyle(
                          fontSize: 15 * 2.sp,
                          color: selected ? _selectedColor : Colors.black),
                    ),
                    Spacer(),
                    Offstage(
                        offstage: !selected,
                        child: Icon(
                          Icons.check,
                          color: Color(0xFFE52E2E),
                          size: 40.sp,
                        ))
                  ]),
                ),
            ),
              );
          }),
    );
  }

  void _filterAddress() {
    int index = 1;
    for (int i = 0; i < widget.model.length; ++i) {
      ProvinceModel province = widget.model[i];
      String proAddressStr = province.name??'';
      _items[0].add(proAddressStr);
      if (proAddressStr != widget.province) {
        continue;
      }
      _indexs[0] = i;
      // index++;
      _province = province;

      for (int m = 0; m < province.cityList!.length; ++m) {
        City city = province.cityList![m];
        String cityAddressStr = city.name??'';
        _items[1].add(cityAddressStr);
        if (cityAddressStr != widget.city) {
          continue;
        }
        _city = city;
        _indexs[1] = m;
        index++;

        for (int n = 0; n < city.districts!.length; ++n) {
          District district = city.districts![n];
          String disAddressStr = district.name??'';
          _items[2].add(disAddressStr);
          if (disAddressStr != widget.district) {
            continue;
          }
          _indexs[2] = n;
          index++;
          _district = district;
        }
      }
    }
    _resetTabBar(index);
  }

  void _resetTabBar(int index) {
    if(!_tab){
      _tabController.removeListener(_tabBarListener);
    }

    _tabController = TabController(length: index, vsync: this);
    _tab =  false;
    _tabController.addListener(_tabBarListener);
    _tabController.index = index - 1;
  }

  _itemSelected(int index) {
    switch (_tabController.index) {
      case 0:
        {
          /// 选城市
          ProvinceModel province = widget.model[index];
          _items[1].clear();
          _items[2].clear();
          _province = province;
          _result[0] = _province.name??'';
          _result[1] = "";
          _result[2] = "";
          _indexs[0] = index;
          _indexs[1] = null;
          _indexs[2] = null;
          _city = null;

          /// 没有次级列表返回
          if (_province.cityList!.length == 0) {
            _dismiss();
            widget.callback(_province.name??'', '', '',_province.id??null);
            return;
          }

          province.cityList!.forEach((City city) {
            _items[1].add(city.name!);
          });
          _resetTabBar(2);
          _scrollController.jumpTo(0);
          setState(() {});
        }
        break;
      case 1:
        {
          /// 选城市
          City city = _province.cityList![index];
          _city = city;
          _district = null;
          _items[2].clear();
          _result[1] = _city?.name??'';
          _indexs[1] = index;
          _result[2] = "";
          _indexs[2] = null;

          /// 没有次级列表返回
          if (city.districts!.length == 0) {
            _dismiss();
            widget.callback(_province.name??'', _city?.name??'', '',_city?.id??null);
            return;
          }

          city.districts!.forEach((District district) {
            _items[2].add(district.name??'');
          });
          _resetTabBar(3);
          setState(() {});
          _scrollController.jumpTo(0);
        }
        break;
      case 2:
        {
          /// 选区
          District district = _city!.districts![index];
          _district = district;
          _result[2] = _district?.name??'';
          _indexs[2] = index;
          _dismiss();
          widget.callback(_province.name??'', _city?.name??'', _district?.name??'',_district?.id??null);
        }
    }
  }

  _tabBarListener() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
      setState(() {});
    }
  }

  _dismiss() {
    Navigator.maybePop(_context);
  }
}

class AddressSelectorHelper {
  static show(BuildContext context,
      {required List<ProvinceModel> models,
      String? province,
      String? city,
      String? district, required AddressSelectorCallback callback}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddressSelector(
            model: models,
            province: province??'',
            city: city??'',
            district: district??"",
            callback: callback,
          );
        });
  }
}
