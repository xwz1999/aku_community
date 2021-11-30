import 'package:flutter/material.dart';

class HomeSliverAppBar extends StatefulWidget {
  final List<Widget>? actions;
  final Widget? title;
  final backgroundColor;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? expandedHeight;
  HomeSliverAppBar(
      {Key? key,
      this.actions,
      this.title,
      this.backgroundColor,
      this.flexibleSpace,
      this.bottom,
      this.expandedHeight})
      : super(key: key);

  @override
  HomeSliverAppBarState createState() => HomeSliverAppBarState();
}

class HomeSliverAppBarState extends State<HomeSliverAppBar> {
  Color _displayColor = Colors.red;

  updateColor(Color color) {
    setState(() {
      _displayColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    _displayColor = widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 3,
      actions: widget.actions,
      title: widget.title,
      floating: false,
      pinned: true,
      snap: false,
      elevation: 0,
      backgroundColor: _displayColor,
      flexibleSpace: widget.flexibleSpace,
      collapsedHeight: kToolbarHeight+10,
      expandedHeight: widget.expandedHeight,
      bottom: widget.bottom,
    );
  }
}
