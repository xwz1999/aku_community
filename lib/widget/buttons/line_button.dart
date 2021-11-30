import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget text;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  const LineButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.width,
      this.padding,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
      disabledTextColor: Colors.white.withOpacity(0.3),
      minWidth: width ?? 168.w,
      height: 70.w,
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.w),
      color:  Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34.w),
          side: BorderSide(color: color??Color(0xFFBBBBBB),width: 2.w)),
      onPressed: onPressed,
      child: text,
    );
  }
}
