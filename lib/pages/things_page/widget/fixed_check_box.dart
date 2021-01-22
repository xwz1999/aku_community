import 'package:akuCommunity/base/base_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FixedCheckBox extends StatefulWidget {
  final Function(bool isSelect) onChanged;
  FixedCheckBox({Key key, this.onChanged}) : super(key: key);

  @override
  _FixedCheckBoxState createState() => _FixedCheckBoxState();
}

class _FixedCheckBoxState extends State<FixedCheckBox> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onChanged(_isSelected);
      },
      child: Container(
        alignment: Alignment.center,
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.w),
          border: Border.all(
              width: 3.w, color: _isSelected ? kPrimaryColor : kDarkSubColor),
          color: Colors.transparent,
        ),
        child: Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.w),
            color: _isSelected ? kPrimaryColor : Colors.transparent,
          ),
        ),
      ),
    );
  }
}