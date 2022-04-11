import 'package:flutter/material.dart';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/pages/one_alarm/alarm_detail_page.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';

class PermissionUtil {
  static Future<bool> getLocationPermission() async {
    return await Permission.locationWhenInUse.request().isGranted;
  }
}

class AlarmPage extends StatefulWidget {
  AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  AMapController? _mapController;

  Future<void> _makephonenum(String url) async {
    (await canLaunch(url)) ? await launch(url) : throw 'Could not launch $url';
  }

  @override
  void initState() {
    super.initState();
    PermissionUtil.getLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.disponse();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return BeeScaffold(
      title: '一键报警',
      actions: [
        MaterialButton(
          onPressed: () => Get.to(() => AlarmDetailPage()),
          child: '功能说明'.text.black.size(28.sp).make(),
        )
      ],
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          AMapWidget(
            privacyStatement: AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true),
            onMapCreated: (controller) {
              final appProvider =
                  Provider.of<AppProvider>(context, listen: false);
              LatLng _target = LatLng(
                (appProvider.location?['latitude'] ?? 0) as double,
                (appProvider.location?['longitude'] ?? 0 )as double,
              );
              _mapController = controller;
              _mapController!.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _target, zoom: 18),
                ),
              );
            },
            myLocationStyleOptions: MyLocationStyleOptions(
              true,
              circleFillColor: Theme.of(context).primaryColor.withOpacity(0.2),
              circleStrokeColor: Theme.of(context).primaryColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 32.w),
                  width: 686.w,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xE8FFFFFF).withOpacity(0.10),
                            offset: Offset(0, 2)),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 24.w, left: 32.w),
                        child: Text(
                          '当前位置(仅供参考)',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff333333),
                              fontSize: 28.sp),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.w, left: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Entypo.location_pin,
                              color: Color(0xff666666),
                              size: 29.sp,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                (appProvider.location == null)
                                    ? '加载中……'
                                    : (appProvider.location?['address'] ?? '')
                                        as String,
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 28.sp,
                                ),
                              ),
                            ).expand(),
                          ],
                        ),
                      ),
                      24.hb,
                    ],
                  )),
              Spacer(),
              Row(
                children: [
                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    width: 66.w,
                    height: 66.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(66.w),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color(0x1F000000),
                            offset: Offset(3, 4),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ]),
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(66.w)),
                      color: Color(0xFFFFFFFF),
                      onPressed: () {},
                      child: Icon(
                        Icons.location_searching,
                        size: 44.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 34.w),
                ],
              ),
              SizedBox(
                height: 29.w,
              ),
              Container(
                width: double.infinity,
                height: 271.w,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(color: Color(0xFFFFFFFF).withOpacity(0.9)),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      bottom: 173.w,
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        height: 196.w,
                        width: 196.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(196.w)),
                        ),
                        child: Container(
                          height: 172.w,
                          width: 172.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topLeft,
                              colors: [Color(0xffef0909), Color(0xffff8880)],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(172.w)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Color(0xfffd7770).withOpacity(0.33),
                                offset: Offset(0, 10.w),
                                blurRadius: 20.w,
                                spreadRadius: 4.w,
                              )
                            ],
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(172.w)),
                            onPressed: () async {
                              setState(() {
                                _makephonenum('tel:110');
                              });

                              if (appProvider.selectedHouse != null) {
                                await NetUtil()
                                    .post(API.manager.recordAlarmInfo, params: {
                                  "estateId":
                                      appProvider.selectedHouse!.estateId,
                                });
                              }
                            },
                            child: Icon(
                              Feather.phone_call,
                              color: Colors.white,
                              size: 87.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 146.w),
                        Text(
                          '谎报警情，依法追责',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.sp,
                            color: Color(0xffe02020),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '谎报警情将可能被处以五日以上十日以下拘留',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff999999),
                          ),
                        ),
                        SizedBox(height: 19.5),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
