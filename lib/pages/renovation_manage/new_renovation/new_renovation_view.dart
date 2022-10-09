import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/new_renovation/new_renovation_list_model.dart';
import 'package:aku_community/pages/renovation_manage/new_renovation/new_renovation_card.dart';
import 'package:aku_community/pages/things_page/widget/bee_list_view.dart';
import 'package:aku_community/utils/headers.dart';

GlobalKey<_NewRenovationViewState> childKey = GlobalKey();

class NewRenovationView extends StatefulWidget {
  final int index;
  NewRenovationView({Key? key, required this.index,}) : super(key: key);

  @override
  _NewRenovationViewState createState() => _NewRenovationViewState();
}

class _NewRenovationViewState extends State<NewRenovationView>
    with AutomaticKeepAliveClientMixin {
  late EasyRefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void callRefresh() {
    return _refreshController.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BeeListView(
        path: API.manager.newRenovationList,
        extraParams: {
          "userDecorationNewStatus": widget.index + 1,
        },
        controller: _refreshController,
        convert: (models) {
          return models.tableList!
              .map((e) => NewRenovationListModel.fromJson(e))
              .toList();
        },
        builder: (items) {
          return ListView.separated(
              padding: EdgeInsets.all(32.w),
              itemBuilder: (context, index) {
                return NewRenovationCard(
                  model: items[index],
                  callRefresh: () {
                    _refreshController.callRefresh();
                  },
                );
              },
              separatorBuilder: (_, __) {
                return 24.w.heightBox;
              },
              itemCount: items.length);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
