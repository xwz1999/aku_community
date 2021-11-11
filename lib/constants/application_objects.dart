// import 'package:aku_community/widget/bee_scaffold.dart';

import 'package:aku_community/const/resource.dart';
import 'package:aku_community/pages/community_introduce/community_introduce_page.dart';
import 'package:aku_community/pages/convenient_phone/convenient_phone_page.dart';
import 'package:aku_community/pages/electronic_commerc/electronic_commerc_page.dart';
import 'package:aku_community/pages/event_activity/event_voting_page.dart';
import 'package:aku_community/pages/express_packages/express_package_page.dart';
import 'package:aku_community/pages/goods_deto_page/goods_deto_page.dart';
import 'package:aku_community/pages/goods_manage_page/select_borrow_return_page.dart';
import 'package:aku_community/pages/house_introduce/house_introduce.dart';
import 'package:aku_community/pages/industry_committee/industry_committee_page.dart';
import 'package:aku_community/pages/life_pay/life_pay_choose_page.dart';
import 'package:aku_community/pages/one_alarm/widget/alarm_page.dart';
import 'package:aku_community/pages/opening_code_page/opening_code_page.dart';
import 'package:aku_community/pages/renovation_manage/new_renovation/new_renovation_page.dart';
import 'package:aku_community/pages/service_browse/service_browse_page.dart';
import 'package:aku_community/pages/setting_page/settings_page.dart';
import 'package:aku_community/pages/things_page/fixed_submit_page.dart';
import 'package:aku_community/pages/visitor_access_page/visitor_access_page.dart';
import 'package:aku_community/ui/community/activity/activity_list_page.dart';
import 'package:aku_community/ui/community/facility/facility_appointment_page.dart';
import 'package:aku_community/ui/home/application/all_application.dart';
import 'package:aku_community/ui/manager/advice/advice_page.dart';
import 'package:aku_community/ui/manager/house_keeping/house_keeping_page.dart';
import 'package:aku_community/ui/manager/questionnaire/questionnaire_page.dart';
import 'package:aku_community/ui/profile/car/car_manage_page.dart';
import 'package:aku_community/ui/profile/car_parking/car_parking_page.dart';
import 'package:aku_community/ui/profile/house/house_owners_page.dart';
import 'package:aku_community/widget/others/user_tool.dart';
import 'package:flutter/material.dart';

///应用对象
///Application Object
class AO {
  String title = '';
  String path = '';
  dynamic page = () => Scaffold();

  AO(
    this.title,
    this.path,
    this.page,
  );

  AO.fromRaw(String raw) {
    appObjects.forEach((element) {
      if (element.title == raw) {
        this.title = element.title;
        this.path = element.path;
        this.page = element.page;
      }
    });
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AO && other.title == title && other.path == path;
  }

  @override
  int get hashCode => title.hashCode ^ path.hashCode;
}

///所有应用
List<AO> appObjects = [
  // if (false) AO('一键开门', R.ASSETS_APPLICATIONS_OEPN_DOOR_PNG, () => Scaffold()),

  AO('开门码', R.ASSETS_APPLICATIONS_DOOR_CODE_PNG, () => OpeningCodePage()),
  AO('访客邀请', R.ASSETS_APPLICATIONS_VISITOR_INVITE_PNG,
      () => VisitorAccessPage()),
  AO('报事报修', R.ASSETS_APPLICATIONS_FIX_PNG, () => FixedSubmitPage()),
  AO('生活缴费', R.ASSETS_APPLICATIONS_PAYMENT_PNG, () => LifePayChoosePage()),
  AO('业委会', R.ASSETS_APPLICATIONS_COMMITTEE_PNG, () => IndustryCommitteePage()),
  AO('建议咨询', R.ASSETS_APPLICATIONS_ADVICE_PNG,
      () => AdvicePage(type: AdviceType.SUGGESTION)),
  AO('便民电话', R.ASSETS_APPLICATIONS_COMMUNITY_PHONE_PNG,
      () => ConvenientPhonePage()),
  AO('活动投票', R.ASSETS_APPLICATIONS_VOTE_PNG, () => EventVotingPage()),
  AO('物品出门', R.ASSETS_APPLICATIONS_GOODS_OUT_PNG, () => GoodsDetoPage()),
  AO('投诉表扬', R.ASSETS_APPLICATIONS_COMPLAINT_PNG,
      () => AdvicePage(type: AdviceType.COMPLAIN)),
  AO('问卷调查', R.ASSETS_APPLICATIONS_QUESTION_PNG, () => QuestionnairePage()),
  AO('装修管理', R.ASSETS_APPLICATIONS_DECORATION_PNG, () => NewRenovationPage()),
  AO('借还管理', R.ASSETS_APPLICATIONS_BORROW_PNG, () => SelectBorrowReturnPage()),
  AO('一键报警', R.ASSETS_APPLICATIONS_POLICE_PNG, () => AlarmPage()),
  AO('设施预约', R.ASSETS_ICONS_TOOL_FACILITY_PNG, () => FacilityAppointmentPage()),
  AO('快递包裹', R.ASSETS_APPLICATIONS_TRANSFER_PNG, () => ExpressPackagePage()),
  AO('电子商务', R.ASSETS_ICONS_COMMERC_PNG, () => ElectronicCommercPage()),
  AO('服务浏览', R.ASSETS_ICONS_SERVICE_PNG, () => ServiceBrowsePage()),
  AO('社区介绍', R.ASSETS_ICONS_INTRODUCE_PNG, () => CommunityIntroducePage()),
  AO('家政服务', R.ASSETS_ICONS_HOUSE_KEEPING_PNG, () => HouseKeepingPage()),

  AO('地理信息', R.ASSETS_ICONS_INTRODUCE_PNG, () => CommunityIntroducePage()),
  AO('周边企业', R.ASSETS_ICONS_HOUSE_KEEPING_PNG, () => HouseKeepingPage()),
  AO('住房介绍', R.ASSETS_ICONS_INTRODUCE_PNG, () => HouseIntroducePage()),

  // AO(
  //   '小区教育',
  //   R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
  //   () => BeeScaffold(title: '小区教育'),
  // ),
  // AO(
  //   '健康运动',
  //   R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
  //   () => BeeScaffold(title: '健康运动'),
  // ),
  // AO(
  //   '家政服务',
  //   R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
  //   () => BeeScaffold(title: '家政服务'),
  // ),
  // AO(
  //   '居家养老',
  //   R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
  //   () => BeeScaffold(title: '居家养老'),
  // ),
  // AO(
  //   '物业租赁',
  //   R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
  //   () => BeeScaffold(title: '物业租赁'),
  // ),
];

List<AO> userAppObjects = [
  AO(
      '我的房屋',
      R.ASSETS_ICONS_USER_ICON_WDFW_PNG,
      () => HouseOwnersPage(
            identify: UserTool.userProvider.userDetailModel!.type ?? 4,
          )),
  AO('我的车位', R.ASSETS_ICONS_USER_ICON_WDCW_PNG, () => CarParkingPage()),
  AO('我的车', R.ASSETS_ICONS_USER_ICON_WDC_PNG, () => CarManagePage()),
  AO('社区活动', R.ASSETS_ICONS_USER_ICON_WDSQHD_PNG, () => ActivityListPage()),
  // AO('我的缴费', R.ASSETS_ICONS_USER_ICON_WDJF_PNG, () => LifePayPage()),
  // AO('我的报修', R.ASSETS_ICONS_USER_ICON_WDBX_PNG, () => FixedSubmitPage()),
  // AO('我的地址', R.ASSETS_ICONS_USER_ICON_WDDZ_PNG, () => Scaffold()),
  // AO('我的管家', R.ASSETS_ICONS_USER_ICON_WDGJ_PNG, () => Scaffold()),
  AO('我的访客', R.ASSETS_ICONS_USER_ICON_WDFK_PNG, () => VisitorAccessPage()),
  AO('设置', R.ASSETS_ICONS_USER_ICON_SZ_PNG, () => SettingsPage()),
];

///全部应用按钮
AO allApp =
    AO('全部应用', R.ASSETS_APPLICATIONS_ALL_APP_PNG, () => AllApplicationPage());

///为您推荐 original value
List<String> _recommendApp = [
  // if (false) '一键开门',
  '访客邀请',
  '报事报修',
  '建议咨询',
  '一键报警',
];

///为您推荐
List<AO> get recommendApp => _recommendApp.map((e) => AO.fromRaw(e)).toList();

///智慧管家 original value
List<String> _smartManagerApp = [
  // if (false) '一键开门',
  '开门码',
  '访客邀请',
  '报事报修',
  '生活缴费',
  '业委会',
  '建议咨询',
  '便民电话',
  '活动投票',
  '物品出门',
  '投诉表扬',
  '问卷调查',
  '装修管理',
  '借还管理',
  '一键报警',
  '设施预约',
  '快递包裹',
  '电子商务',
  '服务浏览',
  '社区介绍',
  '家政服务',
  '地理信息',
  '周边企业',
  '住房介绍',
  // '小区教育',
  // '健康运动',
  // '家政服务',
  // '居家养老',
  // '物业租赁',
];

///智慧管家
List<AO> get smartManagerApp =>
    _smartManagerApp.map((e) => AO.fromRaw(e)).toList();
