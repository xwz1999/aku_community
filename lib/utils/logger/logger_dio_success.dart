import 'package:akuCommunity/extensions/num_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:velocity_x/velocity_x.dart';

class LoggerDioSuccess extends StatelessWidget {
  final Response response;
  const LoggerDioSuccess({Key key, this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: Colors.white,
      onPressed: () => Get.to(_LoggerSuccessDetail(response: response)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              5.wb,
              response.request.path.text.bold.make().expand(),
              Chip(
                backgroundColor: Colors.green,
                label: Text(response?.statusCode?.toString() ?? 'UNKNOW'),
              ),
              5.wb,
              Chip(
                backgroundColor: Colors.greenAccent,
                label: Text(response.request.method),
              ),
            ],
          ),
          response.headers['date'].first.toString().text.make(),
        ],
      ),
    );
  }
}

class _LoggerSuccessDetail extends StatefulWidget {
  final Response response;
  _LoggerSuccessDetail({Key key, this.response}) : super(key: key);

  @override
  __LoggerSuccessDetailState createState() => __LoggerSuccessDetailState();
}

class __LoggerSuccessDetailState extends State<_LoggerSuccessDetail> {
  _buildTable(Map<String, dynamic> tableData) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.black12),
        verticalInside: BorderSide(color: Colors.black12),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.black12),
          children: [
            'Key'.text.make().p2(),
            'Value'.text.make().p2(),
          ],
        ),
        ...tableData.entries.map((e) {
          return TableRow(
            children: [
              e.key.text.make().p2(),
              e.value.toString().text.make().p2(),
            ],
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.response.request.path.text.make(),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          ListTile(
            title: 'Request'.text.bold.size(22).make(),
            trailing: [
              Chip(
                label: widget.response.request.method.text.make(),
                backgroundColor: Colors.lightGreen,
              ),
            ].row(),
          ),
          ListTile(title: 'headers'.text.make()),
          _buildTable(widget.response.request.headers),
          ListTile(title: 'queryParameters'.text.make()),
          (widget.response.request?.queryParameters ?? '')
              .toString()
              .text
              .make(),
          ListTile(title: 'data'.text.make()),
          (widget.response.request?.data ?? '').toString().text.make(),
          ListTile(title: 'Response'.text.bold.size(22).make()),
          ListTile(title: 'headers'.text.make()),
          _buildTable(widget.response.headers.map),
          ListTile(title: 'data'.text.make()),
          (widget.response?.data ?? '').toString().text.make(),
        ],
      ),
    );
  }
}
