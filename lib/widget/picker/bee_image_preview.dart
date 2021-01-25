import 'dart:io';

import 'package:akuCommunity/const/resource.dart';
import 'package:akuCommunity/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeeImagePreview extends StatefulWidget {
  final File file;
  final String path;
  BeeImagePreview.file({Key key, @required this.file})
      : path = null,
        super(key: key);

  BeeImagePreview.path({Key key, @required this.path})
      : file = null,
        super(key: key);

  @override
  _BeeImagePreviewState createState() => _BeeImagePreviewState();
}

class _BeeImagePreviewState extends State<BeeImagePreview> {
  Widget get image {
    if (widget.file == null)
      return Hero(
        tag: widget.path,
        child: FadeInImage.assetNetwork(
          placeholder: R.ASSETS_IMAGES_LOGO_PNG,
          image: API.image(widget.path),
        ),
      );
    else
      return Hero(
        tag: widget.file.hashCode,
        child: Image.file(widget.file),
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Get.back,
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: InteractiveViewer(
            minScale: 0.2,
            child: image,
          ),
        ),
      ),
    );
  }
}
