// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:velocity_x/velocity_x.dart';

// Project imports:
import 'package:akuCommunity/base/base_style.dart';
import 'package:akuCommunity/utils/headers.dart';

class HomeTitle extends StatelessWidget {
  final String title;
  final String suffixTitle;
  final VoidCallback onTap;

  const HomeTitle({
    Key key,
    @required this.title,
    @required this.suffixTitle,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        85.hb,
        24.wb,
        Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 4.w,
              child: Container(
                color: kPrimaryColor,
                height: 8.w,
              ),
            ),
            title.text.size(32.sp).bold.make(),
          ],
        ),
        Spacer(),
        MaterialButton(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          onPressed: onTap,
          child: Row(
            children: [
              suffixTitle.text.size(20.sp).color(Color(0xFF999999)).make(),
              8.wb,
              Icon(
                CupertinoIcons.chevron_forward,
                size: 24.w,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
        12.wb,
      ],
    );
  }
}