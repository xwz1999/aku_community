import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/models/house/lease_detail_model.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/ui/profile/house/add_house_page.dart';
import 'package:aku_community/ui/profile/house/contract_stop/contract_stop_page.dart';
import 'package:aku_community/ui/profile/house/contract_stop/pay_result_page.dart';
import 'package:aku_community/ui/profile/house/contract_stop/refund_bond_result_page.dart';
import 'package:aku_community/ui/profile/house/contract_stop/submit_finish_page.dart';
import 'package:aku_community/ui/profile/house/house_card.dart';
import 'package:aku_community/ui/profile/house/house_func.dart';
import 'package:aku_community/ui/profile/house/identify_selection_page.dart';
import 'package:aku_community/ui/profile/house/lease_pay_query/lease_pay_query_page.dart';
import 'package:aku_community/ui/profile/house/lease_relevation/tenant_house_list_page.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:power_logger/power_logger.dart';
import 'package:provider/provider.dart';

import 'my_house_list.dart';

class HouseOwnersPage extends StatefulWidget {
  final int identify;

  HouseOwnersPage({Key? key, required this.identify}) : super(key: key);

  @override
  _HouseOwnersPageState createState() => _HouseOwnersPageState();
}

class _HouseOwnersPageState extends State<HouseOwnersPage> {
  EasyRefreshController _refreshController = EasyRefreshController();

  bool get _emptyHouse {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return appProvider.houses.isEmpty;
  }

  int get currentSysLeaseId {
    if (UserTool.appProveider.selectedHouse!.sysLeaseId == null) {
      BotToast.showText(text: '无租赁合同！请先签订租赁合同');
      return -1;
    }
    return UserTool.appProveider.selectedHouse!.sysLeaseId!;
  }

  ///存在已认证的房屋
  bool get _haveAuthedHouse {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    // return (appProvider.selectedHouse?.status ?? 0) == 4;
    return appProvider.selectedHouse != null;
  }

  //没有已认证房屋显示的文字
  Widget get _houseTitle {
    // final appProvider = Provider.of<AppProvider>(context, listen: false);
    if (_emptyHouse) return Text('还没有绑定房屋');
    // if (appProvider.selectedHouse!.status == 1) return Text('您的身份正在审核中，请耐心等待');
    // if (appProvider.selectedHouse!.status == 3) return Text('审核未通过');
    return SizedBox();
  }

  bool get isOwner {
    switch (UserTool.userProvider.userDetailModel!.type) {
      case 1:
        return true;
      case 3:
        return false;

      default:
        return false;
    }
  }

  bool get isTourist {
    switch (UserTool.userProvider.userDetailModel!.type) {
      case 1:
        return false;
      case 2:
        return true;
      case 3:
        return false;
      case 4:
        return true;
      default:
        return true;
    }
  }

  bool _onload = true;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () async {
      Function cancel = BotToast.showLoading();
      try {
        await UserTool.userProvider.updateUserDetail();
        UserTool.appProveider.updateHouses(await HouseFunc.passedHouses);
      } catch (e) {
        LoggerData.addData(e);
      }
      _onload = false;
      cancel();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return _onload
        ? BeeScaffold(title: '我的房屋')
        : BeeScaffold(
            title: '我的房屋',

            actions: [
              isTourist
                  ? SizedBox()
                  : TextButton(
                      onPressed: () {
                        isOwner
                            ? Get.to(() => MyHouseList())
                            : Get.to(() => TenantHouseListPage());
                      },
                      child: Text('审核记录'),
                    ),
            ],
            body: isTourist
                ? _touristBody()
                : EasyRefresh(
                    header: MaterialHeader(),
                    controller: _refreshController,
                    firstRefresh: false,
                    onRefresh: () async {
                      appProvider.updateHouses(await HouseFunc.passedHouses);
                    },
                    child: ListView(
                      children: [
                        _emptyHouse
                            ? 280.hb
                            : Padding(
                                padding: EdgeInsets.all(32.w),
                                child: HouseCard(
                                  isOwner: isOwner,
                                  type: appProvider.selectedHouse != null
                                      ? CardAuthType.SUCCESS
                                      : CardAuthType.FAIL,
                                  model: appProvider.selectedHouse,
                                ),
                              ),
                        if (!_emptyHouse) 88.hb,
                        if (_emptyHouse)
                          Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 75.w),
                                child:
                                    Image.asset(R.ASSETS_STATIC_REVIEWING_WEBP),
                              ),
                              Positioned(
                                bottom: 100.w,
                                left: 0,
                                right: 0,
                                child: _houseTitle.centered(),
                              ),
                            ],
                          ),
                        if (_emptyHouse)
                          Center(
                            child: ElevatedButton(
                              onPressed: _addHouse,
                              child: Text('添加房屋'),
                            ),
                          ),
                        if (!isOwner && _haveAuthedHouse) _contractRelevant()
                      ],
                    ),
                  ),
            // bottomNavi: BottomButton(
            //     onPressed: _addHouse,
            //     child: '新增房屋'.text.size(32.sp).color(ktextPrimary).bold.make()),
          );
  }

  ///跳转到添加房屋
  _addHouse() async {
    bool? result = await Get.to(() => AddHousePage());
    if (result == true) _refreshController.callRefresh();
  }

  ///租客身份才会显示合同相关入口
  Widget _contractRelevant() {
    return Container(
      width: double.infinity,
      height: 550.w,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 330 / 250,
        mainAxisSpacing: 32.w,
        crossAxisSpacing: 32.w,
        children: [
          _cardBuild(R.ASSETS_ICONS_PAY_PNG, '缴费查询', '查看租金及保证金情况', () {
            Get.to(() => LeasePayQueryPage(
                  id: currentSysLeaseId,
                ));
          }),
          _cardBuild(R.ASSETS_ICONS_CHANGE_PNG, '合同变更', '变更合同信息、重新签约', () {
            Get.to(() => TenantHouseListPage(
                  leaseId: currentSysLeaseId,
                ));
          }),
          _cardBuild(R.ASSETS_ICONS_CONTRACT_PNG, '合同续签', '到期前线上办理续签手续', () {
            Get.to(() => TenantHouseListPage(
                  leaseId: currentSysLeaseId,
                ));
          }),
          _cardBuild(R.ASSETS_ICONS_FINISH_PNG, '合同终止', '线上申请终止合同',
              () => stopContract())
        ],
      ),
    );
  }

  Future stopContract() async {
    LeaseDetailModel? model = await HouseFunc().leaseDetail(currentSysLeaseId);
    if (model != null) {
      switch (model.status) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
          Get.to(() => ContractStopPage());
          break;
        case 11:
        case 12:
        case 13:
          Get.to(
              () => SubmitFinishPage(status: model.status, leaseId: model.id));
          break;
        case 14:
          Get.to(() => PayResultPage(
                name: model.name,
                bond: model.margin.toDouble(),
                date: DateUtil.formatDateStr(model.marginPayDate ?? ''),
                id: model.id,
              ));
          break;
        case 15:
        case 16:
        case 17:
          Get.to(() => RefundBondResultPage(
                status: model.status,
                name: model.name,
                bond: model.margin.toDouble(),
                date: DateUtil.formatDateStr(model.marginPayDate ?? ''),
                id: model.id,
              ));
          break;
        default:
      }
    }
  }

  Widget _cardBuild(
      String assetPath, String title, String subTitle, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16.w)),
        padding: EdgeInsets.only(left: 30.w, top: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              assetPath,
              fit: BoxFit.fill,
              width: 88.w,
              height: 88.w,
            ),
            16.w.heightBox,
            title.text.size(28.sp).color(ktextPrimary).bold.make(),
            16.w.heightBox,
            subTitle.text
                .size(24.sp)
                .color(ktextSubColor)
                .maxLines(2)
                .ellipsis
                .make()
          ],
        ),
      ),
    );
  }

//游客身份页面显示
  Widget _touristBody() {
    var center = Center(
      child: Column(
        children: [
          280.w.heightBox,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 75.w),
            child: Image.asset(R.ASSETS_STATIC_REVIEWING_WEBP),
          ),
          32.w.heightBox,
          MaterialButton(
              color: kPrimaryColor,
              minWidth: 280.w,
              elevation: 0,
              height: 88.w,
              child: '添加房屋'.text.size(32.sp).color(ktextPrimary).bold.make(),
              onPressed: () {
                Get.to(() => IdentifySelectionPage());
              })
        ],
      ),
    );
    return center;
  }
}
