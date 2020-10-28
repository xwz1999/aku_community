import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:akuCommunity/utils/screenutil.dart';
import 'package:akuCommunity/routers/page_routers.dart';
import 'package:akuCommunity/widget/common_app_bar.dart';

class SystemMessagePage extends StatefulWidget {
  SystemMessagePage({Key key}) : super(key: key);

  @override
  _SystemMessagePageState createState() => _SystemMessagePageState();
}

class _SystemMessagePageState extends State<SystemMessagePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _controller;

  List<Map<String, dynamic>> _listNotice = [
    {'status': '已读', 'type': '业主信息审核：未通过', 'content': '您的信息有错误，请您重新填写'},
    {
      'status': '已读',
      'type': '物品出门：未通过',
      'content': '当天装修人员有些多，是否考虑换一是否考虑换一是否考虑换一…'
    },
    {
      'status': '已读',
      'type': '报修申请：未通过',
      'content': '您的地址填写的不够详细，装修员工装修员工装修员工…'
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void noteCreateRouter() {
    // Navigator.pushNamed(
    //   context,
    //   PageName.note_create_page.toString(),
    // );
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1500));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1500));

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  InkWell _inkWellLook(String type, String content) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, PageName.system_details_page.toString(),
            arguments: Bundle()
              ..putMap('detailsMap', {'type': type, 'content': content}));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '查看详情',
            style: TextStyle(
                fontSize: 28.sp, color: Color(0xff333333)),
          ),
          Icon(AntDesign.right, size: 40.sp),
        ],
      ),
    );
  }

  Container _containerCard(String status, String type, String content) {
    return Container(
      margin: EdgeInsets.only(
        top: 32.w,
        left: 32.w,
        right: 32.w,
      ),
      padding: EdgeInsets.only(
          top: 21.w,
          bottom: 14.w,
          left: 30.w,
          right: 20.w),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.all(Radius.circular(4)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(1, 1),
              blurRadius: 10.0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '系统通知',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 32.sp,
                          color: Color(0xff333333)),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                          fontSize: 32.sp,
                          color: Color(0xff999999)),
                    ),
                  ],
                ),
                SizedBox(height: 5.w),
                Text(
                  type,
                  style: TextStyle(
                      fontSize: 28.sp, color: Color(0xff333333)),
                ),
                SizedBox(height: 8.w),
                Text(
                  '驳回理由：${content}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 28.sp, color: Color(0xff333333)),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.w),
          Divider(),
          _inkWellLook(type, content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: CommonAppBar(
          title: '系统通知',
          subtitle: '清空',
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: RefreshConfiguration(
        hideFooterWhenNotFull: true,
        child: SmartRefresher(
          controller: _refreshController,
          header: WaterDropHeader(),
          footer: ClassicFooter(),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullUp: true,
          child: ListView.builder(
            itemBuilder: (context, index) => _containerCard(
              _listNotice[index]['status'],
              _listNotice[index]['type'],
              _listNotice[index]['content'],
            ),
            itemCount: _listNotice.length,
          ),
        ),
      ),
    );
  }
}
