import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:aku_community/constants/application_objects.dart';
import 'package:aku_community/provider/app_provider.dart';
import 'package:aku_community/utils/headers.dart';
import 'package:aku_community/utils/login_util.dart';

class ApplicationView extends StatefulWidget {
  final List<AO>? items;
  final bool needAllApp;
  ApplicationView({Key? key, this.needAllApp = true})
      : items = null,
        super(key: key);

  ApplicationView.custom(
      {Key? key, required List<AO> this.items, this.needAllApp = true})
      : super(key: key);

  @override
  _ApplicationViewState createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  _buildTile(AO object) {
    return MaterialButton(
      shape: StadiumBorder(),
      padding: EdgeInsets.zero,
      onPressed: () {
        if (LoginUtil.isNotLogin) return;
        if (!LoginUtil.haveRoom(object.title)) return;
        Get.to(object.page);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            object.path,
            height: 75.w,
            width: 75.w,
          ),
          8.hb,
          object.title.text.size(24.sp).make(),
        ],
      ),
    );
  }

  bool get _isCustom => widget.items != null;
  List<AO>? get _items {
    final appProvider = Provider.of<AppProvider>(context);

    return _isCustom ? widget.items : appProvider.myApplications;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        if (index == _items!.length && widget.needAllApp)
          return _buildTile(allApp);
        return _buildTile(_items![index]);
      },
      itemCount: widget.needAllApp ? _items!.length + 1 : _items!.length,
      shrinkWrap: true,
    );
  }
}
