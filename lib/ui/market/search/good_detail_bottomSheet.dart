/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-17  09:41 
 * remark    : 
 * ====================================================
 */
import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/model/good/good_detail_model.dart';
import 'package:aku_community/model/user/province_model.dart';
import 'package:aku_community/utils/text_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:aku_community/utils/headers.dart';

class GoodDetailBottomSheet extends StatefulWidget {
  final GoodDetailModel goodDetail;

  const GoodDetailBottomSheet({
    Key? key,
    required this.goodDetail,
  });

  @override
  _GoodDetailBottomSheetState createState() => _GoodDetailBottomSheetState();
}

class _GoodDetailBottomSheetState extends State<GoodDetailBottomSheet>
    with TickerProviderStateMixin {
  late BuildContext _context;
  late ScrollController _scrollController;
  List<Attribute> attributes = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.goodDetail.goodsDetailSpecificationVoList != null) {
      widget.goodDetail.goodsDetailSpecificationVoList!.forEach((element) {
        if (element.attribute != null) {
          attributes.addAll(element.attribute!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return GestureDetector(
      onTap: () {},
      child: _buildBody(context),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Container _buildBody(BuildContext context) {
    return Container(
      height: 1200.w,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _header(),
          10.hb,
          widget.goodDetail.goodsDetailSpecificationVoList != null
              ? _list()
              : SizedBox()
        ],
      ),
    );
  }

  Container _header() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.w),
      child: Row(
        children: <Widget>[
          Spacer(),
          Text(
            "产品参数",
            style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w500,
                color: ktextPrimary),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              _dismiss();
            },
            child: Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.w)),
                color: Colors.white,
              ),
              child: Icon(
                Icons.close,
                color: Colors.grey[500],
                size: 40.w,
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded _list() {
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: attributes.length,
          itemBuilder: (context, index) {
            return _goodInfo(attributes[index]);
          }),
    );
  }

  _dismiss() {
    Navigator.maybePop(_context);
  }

  _goodInfo(Attribute attribute) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 86.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              44.wb,
              Container(
                child: Text(
                  attribute.name ?? '',
                  style: TextStyle(color: ktextPrimary, fontSize: 28.sp),
                ),
                width: 250.w,
              ),
              Text(
                attribute.value ?? '',
                style: TextStyle(color: ktextSubColor, fontSize: 28.sp),
              ),
            ],
          ),
        ),
        Divider(
          height: 1.w,
          color: Color(0xFFD9D9D9),
          indent: 44.w,
          endIndent: 44.w,
        )
      ],
    );
  }
}
