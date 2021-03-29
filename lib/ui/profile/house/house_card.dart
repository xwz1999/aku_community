import 'package:akuCommunity/const/resource.dart';
import 'package:akuCommunity/constants/app_values.dart';
import 'package:akuCommunity/model/user/house_model.dart';
import 'package:akuCommunity/ui/profile/house/pick_my_house_page.dart';
import 'package:flutter/material.dart';
import 'package:akuCommunity/utils/headers.dart';
import 'package:get/get.dart';

enum CardAuthType {
  FAIL,
  SUCCESS,
}

class HouseCard extends StatelessWidget {
  final HouseModel model;
  final CardAuthType type;
  const HouseCard({
    Key key,
    @required this.model,
    @required this.type,
  }) : super(key: key);

  const HouseCard.fail({
    Key key,
    @required this.model,
  })  : type = CardAuthType.FAIL,
        super(key: key);
  const HouseCard.success({
    Key key,
    @required this.model,
  })  : type = CardAuthType.SUCCESS,
        super(key: key);

  String get _assetPath {
    switch (type) {
      case CardAuthType.FAIL:
        return R.ASSETS_STATIC_HOUSE_AUTH_FAIL_WEBP;
      case CardAuthType.SUCCESS:
        return R.ASSETS_STATIC_HOUSE_AUTH_SUCCESS_WEBP;
    }
    return '';
  }

  String get _roleName {
    switch (model.type) {
      case 1:
        return '业主';
      case 2:
        return '';
      case 3:
        return '';
      default:
        return '';
    }
  }

  List<BoxShadow> get _shadows {
    switch (type) {
      case CardAuthType.FAIL:
        return [
          BoxShadow(
            offset: Offset(0, 10.w),
            blurRadius: 30.w,
            color: Color(0xFFF0F0F0),
          ),
        ];
      case CardAuthType.SUCCESS:
        return [
          BoxShadow(
            offset: Offset(0, 10.w),
            blurRadius: 30.w,
            color: Color(0xFFFFF0BF),
          ),
        ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 686 / 386,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(left: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            28.hb,
            Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                height: 48.w,
                minWidth: 152.w,
                color: Colors.white,
                padding: EdgeInsets.zero,
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                highlightElevation: 0,
                child: Text(
                  '切换房屋',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 24.sp,
                  ),
                ),
                onPressed: () {
                  Get.to(()=>PickMyHousePage());
                },
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(24.w)),
                ),
              ),
            ),
            12.hb,
            Text(
              AppValues.plotName,
              style: Theme.of(context).textTheme.headline3,
            ),
            10.hb,
            Text(
              model.roomName,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Spacer(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '身份',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Color(0xFF666666),
                          ),
                    ),
                    Text(
                      _roleName,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ).expand(),
                //TODO
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       '到期时间',
                //       style: Theme.of(context).textTheme.subtitle2.copyWith(
                //             color: Color(0xFF666666),
                //           ),
                //     ),
                //     Text(
                //       _roleName,
                //       style: Theme.of(context).textTheme.subtitle1,
                //     ),
                //   ],
                // ).expand(),
              ],
            ),
            40.hb,
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          image: DecorationImage(image: AssetImage(_assetPath)),
          boxShadow: _shadows,
        ),
      ),
    );
  }
}
