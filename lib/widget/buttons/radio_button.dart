import 'package:flutter/material.dart';

import 'package:aku_community/base/base_style.dart';
import 'package:aku_community/utils/headers.dart';

class BeeRadio<T> extends StatefulWidget {
  final T value;
  final List<T>? groupValues;
  BeeRadio({Key? key, required this.value, required this.groupValues})
      : super(key: key);

  @override
  _BeeRadioState createState() => _BeeRadioState();
}

class _BeeRadioState extends State<BeeRadio> {
  bool get _selected {
    if (widget.groupValues!.contains(widget.value)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40.w,
      width: 40.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: _selected ? kPrimaryColor : Color(0xFF979797),
          width: 3.w,
        ),
        borderRadius: BorderRadius.circular(20.w),
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.center,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        opacity: _selected ? 1 : 0,
        child: AnimatedScale(
          duration: Duration(milliseconds: 300),
          scale: _selected ? 1 : 0,
          child: Container(
            height: 24.w,
            width: 24.w,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(12.w),
            ),
          ),
        ),
      ),
    );
  }
}
