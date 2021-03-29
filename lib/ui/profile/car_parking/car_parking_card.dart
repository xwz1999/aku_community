import 'package:akuCommunity/constants/app_values.dart';
import 'package:akuCommunity/model/user/car_parking_model.dart';
import 'package:akuCommunity/utils/headers.dart';
import 'package:flutter/material.dart';

class CarparkingCard extends StatelessWidget {
  final CarParkingModel model;
  const CarparkingCard({Key key, @required this.model}) : super(key: key);

  String get _assetImage {
    return model.outdated
        ? R.ASSETS_STATIC_PARKING_GREY_WEBP
        : R.ASSETS_STATIC_PARKING_YELLOW_WEBP;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 688 / 286,
      child: Container(
        padding: EdgeInsets.all(40.w),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(_assetImage)),
          borderRadius: BorderRadius.circular(8.w),
          boxShadow: model.shadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.code,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36.sp,
              ),
            ),
            Text(
              AppValues.plotName,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Color(0xFF999999)),
            ),
            Spacer(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '类型',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(0xFF666666),
                          ),
                    ),
                    Text(
                      model.typeName,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ).expand(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '到期时间',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(0xFF666666),
                          ),
                    ),
                    Text(
                      model.dateName,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}