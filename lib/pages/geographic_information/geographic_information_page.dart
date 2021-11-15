import 'package:aku_community/models/geographic_information/geographic_information_model.dart';
import 'package:aku_community/models/house_introduce/house_introduce_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/common/img_model.dart';
import 'package:aku_community/models/community_introduce/community_introduce_model.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';

class GeographicInformationPage extends StatefulWidget {


  GeographicInformationPage({Key? key,})
      : super(key: key);

  @override
  _GeographicInformationPageState createState() => _GeographicInformationPageState();
}

class _GeographicInformationPageState extends State<GeographicInformationPage> {
  GeographicInformationModel _model = GeographicInformationModel.init();
  bool _onload = false;
  @override
  Widget build(BuildContext context) {
    return BeeScaffold(
        bodyColor: Colors.white,
        title: '地理信息',
        body:EasyRefresh(
          firstRefresh: true,
          header: MaterialHeader(),
          onRefresh: () async {
            BaseModel baseModel =
            await NetUtil().get(API.manager.geographyInformation);
            if (baseModel.status! && baseModel.data != null) {
              _model = GeographicInformationModel.fromJson(baseModel.data);
            }
            _onload = false;
            setState(() {});
          },
          child: _onload
              ? Container()
              :
          ListView(
            children: [
              SizedBox(
                child: FadeInImage.assetNetwork(
                    placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                    fit: BoxFit.cover,
                    image: API
                        .image(ImgModel.first(_model.imgList))),
                width: double.infinity,
                height: 424.w,
              ),
              24.w.heightBox,

              Padding(
                  padding: EdgeInsets.only(left: 32.w,right: 32.w,top: 40.w),
                  child: Text(
                    _model.content ?? '',
                    style: TextStyle(
                        fontSize: 26.sp,
                        color: (ktextSubColor),
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ));
  }
}
