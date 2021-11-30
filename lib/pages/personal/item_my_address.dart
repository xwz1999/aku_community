/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/24  4:05 PM 
 * remark    : 
 * ====================================================
 */

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/pages/personal/user_func.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'address/new_address_page.dart';


// ignore: must_be_immutable
class MyAddressItem extends StatefulWidget {
  final AddressModel addressModel;
  final EasyRefreshController? refreshController;
  final bool canBack;

  Color _titleColor = Colors.black;

  MyAddressItem({required this.addressModel,
this.refreshController, required this.canBack})
      : assert(addressModel != null);

  _MyAddressItemState createState() => _MyAddressItemState();
}
class _MyAddressItemState extends State<MyAddressItem> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return GestureDetector(
      onTap: widget.canBack? (){
        Get.back(result: widget.addressModel);
      }:(){

      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(bottom:20.w),
        padding: EdgeInsets.only(top: 22.w,bottom: 24.w,left: 24.w,right: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.w)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                GestureDetector(
                  onTap: () async{
                    bool? result =  await  Userfunc.setIsDefaultAddress(widget.addressModel.id!);
                    if(result!=null){
                      if(result)  {
                        await appProvider.getMyAddress();
                        widget.refreshController!.callRefresh();
                      }
                    }
                  },
                  child: Container(
                    child:  widget.addressModel.isDefault==1?
                    Image.asset(R.ASSETS_ICONS_ICON_ADDRESS_ISDEFAULT_PNG,width: 40.w,height: 40.w,):
                    Image.asset(R.ASSETS_ICONS_ICON_ADDRESS_NOT_PNG,width: 40.w,height: 40.w,),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical:6.w),
                      child: SizedBox(
                        width: 520.w,
                        child: Text(
                          widget.addressModel.locationName??'',
                            style:TextStyle(fontSize: 24.sp,color: ktextPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical:6.w),
                      child: SizedBox(
                        width: 520.w,
                        child: Text(
                          ( widget.addressModel.addressDetail??''),
                            style:TextStyle(fontSize: 32.sp,color: ktextPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical:6.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                              widget.addressModel.name??'',
                              style: TextStyle(fontSize: 24.sp,color: ktextPrimary)
                          ),
                          30.wb,
                          Text(
                              widget.addressModel.tel??'',
                              style: TextStyle(fontSize: 24.sp,color: ktextPrimary)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async{

                      bool? result =  await  Get.to(() => NewAddressPage(isFirstAdd:false,addressModel: widget.addressModel,
                      ));
                      if(result!=null){
                        if(result)  widget.refreshController!.callRefresh();
                      }

                  },
                  child: Container(
                    child: Image.asset(R.ASSETS_ICONS_ICON_ADDRESS_EDIT_PNG,width: 40.w,height: 40.w,),
                  ),
                )
              ],
            ),
            20.hb,
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            20.hb,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                10.wb,
                Text(
                  widget.addressModel.isDefault == 0 ? "" : "默认地址",
                  style: TextStyle(fontSize: 28.sp,color: ktextSubColor),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async{
                    // bool? result =  await  Userfunc.deleteAddress(widget.addressModel.id!);
                    // if(result!=null){
                    //   if(result)  widget.refreshController!.callRefresh();
                    // }
                      bool? result =
                      await Get.dialog(CupertinoAlertDialog(
                        title: '您确定要删除该地址吗？'.text.isIntrinsic.size(30.sp).make(),
                        actions: [
                          CupertinoDialogAction(
                            child: '取消'.text.black.isIntrinsic.make(),
                            onPressed: () => Get.back(),
                          ),
                          CupertinoDialogAction(
                            child: '确定'
                                .text
                                .color(Colors.orange)
                                .isIntrinsic
                                .make(),
                            onPressed: () => Get.back(result: true),
                          ),
                        ],
                      ));

                      if (result == true) {
                        bool? result =  await  Userfunc.deleteAddress(widget.addressModel.id!);
                        if(result!=null){
                          if(result)  widget.refreshController!.callRefresh();
                        }
                    };
                  },
                  child: Container(
                    width: 70.w,
                    height: 40.w,
                    child:Text(
                      "删除",
                      style: TextStyle(fontSize: 28.sp,color: ktextSubColor),
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

}
