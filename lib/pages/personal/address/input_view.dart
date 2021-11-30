/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/25  3:13 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aku_community/utils/headers.dart';

typedef TextInputChangeCallBack = Function(String text);

// ignore: must_be_immutable
class InputView extends StatefulWidget {
  final TextEditingController controller;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final String? hint;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Color cursorColor;
  final TextInputType keyboardType;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextInputChangeCallBack? onValueChanged;
  final TextInputChangeCallBack? onBeginInput;
  final TextInputChangeCallBack? onInputComplete;
  final bool showClear;
  final int maxLines;
  final TextAlign textAlign;

  InputView(
      {required this.controller,
      this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      this.margin = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      this.hint = "",
      this.textStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
      this.hintStyle = const TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
      this.cursorColor = const Color(0xFFBDBDBD),
      this.keyboardType = TextInputType.text,
      this.maxLength,
      this.focusNode,
      this.onValueChanged,
      this.showClear = true,
      this.textAlign = TextAlign.start,
      this.maxLines = 1,
      this.onInputComplete,
      this.onBeginInput});

  @override
  State<StatefulWidget> createState() {
    return _InputViewState();
  }
}

class _InputViewState extends State<InputView> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller;

    _focusNode.addListener(() {
      setState(() {

      });
      if (!_focusNode.hasFocus) {
        if (widget.onInputComplete != null) {
          widget.onInputComplete!(_controller.text);
        }
      } else {
        if (widget.onBeginInput != null) {
          widget.onBeginInput!(_controller.text);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: widget.margin,
        padding: EdgeInsets.symmetric(horizontal: widget.padding.horizontal),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CupertinoTextField(
                placeholder: widget.hint,
                placeholderStyle: widget.hintStyle,
                controller: _controller,
                focusNode: _focusNode,
                maxLines: widget.maxLines,
                keyboardType: widget.keyboardType,
                style: widget.textStyle,
                inputFormatters: widget.maxLength == null
                    ? null
                    : [
                        widget.maxLength == 0 ? FilteringTextInputFormatter.digitsOnly:
                        LengthLimitingTextInputFormatter(widget.maxLength),
                      ],
                cursorColor: widget.cursorColor,
                onChanged: widget.onValueChanged,
                onEditingComplete: () {},
                textAlign: widget.textAlign,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                enableInteractiveSelection: true,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withAlpha(0),
                    width: 0
                  )
                ),
                // decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(vertical: widget.padding.vertical),
                //     border: InputBorder.none,
                //     hintText: widget.hint,
                //     hintStyle: widget.hintStyle),
              ),
              // child: TextField(
              //   controller: _controller,
              //   focusNode: _focusNode,
              //   maxLines: widget.maxLines,
              //   keyboardType: widget.keyboardType,
              //   style: widget.textStyle,
              //   inputFormatters: widget.maxLength == null
              //       ? null
              //       : [
              //           LengthLimitingTextInputFormatter(widget.maxLength),
              //         ],
              //   cursorColor: widget.cursorColor,
              //   onChanged: widget.onValueChanged,
              //   onEditingComplete: () {},
              //   textAlign: widget.textAlign,
              //   onSubmitted: (_) {
              //     FocusScope.of(context).requestFocus(FocusNode());
              //   },
              //   enableInteractiveSelection: true,
              //   decoration: InputDecoration(
              //       contentPadding: EdgeInsets.symmetric(vertical: widget.padding.vertical),
              //       border: InputBorder.none,
              //       hintText: widget.hint,
              //       hintStyle: widget.hintStyle),
              // ),
            ),
            widget.showClear ? _clearButton() : Container()
          ],
        ),
      ),
    );
  }

  _clearButton() {
    return _focusNode.hasFocus
        ? GestureDetector(
            child: Icon(
              Icons.clear,
              size: 15,
              color: Colors.grey[300],
            ),
            onTap: () {
              _controller.clear();
            })
        : Container();
  }
}
