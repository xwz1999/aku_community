import 'dart:io';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/const/resource.dart';
import 'package:aku_community/constants/api.dart';
import 'package:aku_community/pages/personal/change_nick_name_page.dart';
import 'package:aku_community/pages/personal/update_tel_page.dart';
import 'package:aku_community/provider/user_provider.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/network/base_file_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:aku_community/widget/bee_scaffold.dart';
import 'package:aku_community/widget/picker/bee_custom_picker.dart';
import 'package:aku_community/widget/picker/bee_date_picker.dart';
import 'package:aku_community/widget/picker/bee_image_picker.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _sex = 1;

  Widget _buildTile(String title, Widget suffix, {VoidCallback? onPressed}) {
    return MaterialButton(
      color: Colors.white,
      elevation: 0,
      onPressed: onPressed,
      height: 96.w,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 34.sp,
          color: ktextPrimary,
        ),
        child: Row(
          children: [
            32.wb,
            title.text.make(),
            Spacer(),
            suffix,
            24.wb,
            Icon(
              CupertinoIcons.chevron_forward,
              color: Color(0xFFDCDCDC),
              size: 32.w,
            ),
            16.wb,
          ],
        ),
      ),
    );
  }

  _pickAvatar() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    File? file = await BeeImagePicker.pick(title: '选择头像');
    if (file == null)
      return;
    else {
      //Upload Avatar
      Function cancel = BotToast.showLoading();
      BaseFileModel model =
          await NetUtil().upload(API.upload.uploadAvatar, file);
      if (model.status!)
        userProvider.updateAvatar(model.url);
      else
        BotToast.showText(text: model.message!);
      cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return BeeScaffold(
      title: '个人资料',
      body: ListView(
        children: [
          _buildTile(
            '头像',
            Hero(
              tag: 'AVATAR',
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_IMAGES_PLACEHOLDER_WEBP,
                  image: API.image(
                      userProvider.userInfoModel!.imgUrls.isNotEmpty
                          ? userProvider.userInfoModel?.imgUrls.first.url
                          : ''),
                  height: 56.w,
                  width: 56.w,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(R.ASSETS_IMAGES_PLACEHOLDER_WEBP,height: 56.w,
                      width: 56.w,);
                  },
                ),
              ),
            ),
            onPressed: _pickAvatar,
          ),
          _buildTile(
            '姓名',
            (userProvider.userInfoModel?.name ?? '').text.make(),
            onPressed: () {},
          ),
          _buildTile(
            '昵称',
            (userProvider.userInfoModel?.nickName ?? '').text.make(),
            onPressed: () {
              Get.to(() => ChangeNickName());
            },
          ),
          _buildTile(
            '手机号',
            TextUtil.hideNumber(userProvider.userInfoModel?.tel ?? '')
                .text
                .make(),
            onPressed: () {
              Get.to(() => UpdateTelPage());
            },
          ),
          _buildTile(
            '性别',
            userProvider.userInfoModel!.sexValue.text.make(),
            onPressed: () async {
              int? result = await Get.bottomSheet(BeeCustomPicker(
                onPressed: () => Get.back(result: _sex),
                body: CupertinoPicker(
                  itemExtent: 50,
                  onSelectedItemChanged: (index) {
                    _sex = index + 1;
                  },
                  children: [
                    '男'.text.isIntrinsic.make().centered(),
                    '女'.text.isIntrinsic.make().centered(),
                  ],
                  useMagnifier: true,
                ).expand(),
              ));
              if (result != null) {
                userProvider.setSex(_sex);
              }
            },
          ),
          _buildTile(
            '出生日期',
            userProvider.userInfoModel!.birthdayValue.text.make(),
            onPressed: () async {
              DateTime? date = await BeeDatePicker.pick(DateTime.now());
              if (date != null) userProvider.setBirthday(date);
            },
          ),
        ].sepWidget(
            separate: Divider(
          indent: 104.w,
          height: 1.w,
          thickness: 1.w,
          color: Color(0xFFEEEEEE),
        )),
      ),
    );
  }
}
