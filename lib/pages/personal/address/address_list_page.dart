import 'dart:ui';

import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/model/community/community_topic_model.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/ui/community/community_views/topic/topic_detail_page.dart';
import 'package:aku_community/utils/headers.dart';

import '../item_my_address.dart';
import '../user_func.dart';
import 'new_address_page.dart';

class AddressListPage extends StatefulWidget {
  final bool canBack;
  AddressListPage({Key? key, required this.canBack}) : super(key: key);

  @override
  AddressListPageState createState() => AddressListPageState();
}

class AddressListPageState extends State<AddressListPage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _refreshController = EasyRefreshController();
  bool _onload = true;
  List<AddressModel> _addressModels = [];
   AddressModel? _addressModel;
  refresh() {
    _refreshController.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  BeeScaffold(
      leading: Navigator.canPop(context)
          ? IconButton(
        onPressed: () async {
          if(_addressModels.isEmpty){
            Get.back(result: null);
          }else{

              _addressModels.forEach((element) {
                if(element.isDefault==1){
                  _addressModel = element;
                }
              });
            if(_addressModel==null){
              Get.back();
            }else{
              Get.back(result: _addressModel);
            }

          }
        },
        icon: Icon(
          CupertinoIcons.chevron_back,
          color: Colors.black,
        ),
      )
          : SizedBox(),
      title: '我的收货地址',
      bottomNavi: GestureDetector(
        onTap: ()async{
          bool? result =  await  Get.to(() => NewAddressPage(isFirstAdd: _addressModels.isEmpty? true:false,));
          if(result!=null){
            if(result) _refreshController.callRefresh();
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 100.w,right: 100.w,bottom: 100.w),
          alignment: Alignment.center,
          child: '新增收货地址'.text.size(28.sp).white.make(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(left:  Radius.circular(49.w),right:  Radius.circular(49.w)),
            color: Color(0xFFE52E2E),
          ),
          width: 522.w,
          height: 98.w,

        ),
      ),
      body:EasyRefresh(
        firstRefresh: true,
        header: MaterialHeader(),
        controller: _refreshController,
        onRefresh: () async {
          _addressModels = await Userfunc.getMyAddress();
          _onload =false;
          setState(() {});
        },
        child: _onload
            ? SizedBox()
            : ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            ..._addressModels.map((e) => MyAddressItem(addressModel: e,refreshController: _refreshController,canBack: widget.canBack,
      )).toList(),
          ],
        ),
      ),

    );


  }

  @override
  bool get wantKeepAlive => true;
}
