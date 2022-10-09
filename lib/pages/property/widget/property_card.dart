import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aku_community/utils/headers.dart';

class PropertyCard extends StatelessWidget {
  PropertyCard({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _listCard = [
    {
      'title': '电话物业',
      'subtitle': '24小时在线',
      'image': R.ASSETS_ICONS_PROPERTY_PNG,
      'coloList': [Color(0xff42ceff), Color(0xff198cfb)],
      'shapeColoList': [Color(0xff42ceff), Color(0xff0b69c4)]
    }
  ];

  Future<void> _phoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showDialog(BuildContext context, String url) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            url,
            style: TextStyle(
              fontSize: 34.sp,
              color: Color(0xff030303),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                '取消',
                style: TextStyle(
                  fontSize: 34.sp,
                  color: Color(0xff333333),
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                '呼叫',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 34.sp,
                  color: Color(0xffff8200),
                ),
              ),
              onPressed: () {
                _phoneCall('tel:$url');
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 20.w,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _listCard.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              switch (_listCard[index]['title']) {
                case '电话物业':
                  _showDialog(context, '0771-2203389');
                  break;
                case '语音管家':
                  break;
                default:
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 19.w,
                vertical: 36.w,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: _listCard[index]['coloList'],
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 88.w,
                    width: 88.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _listCard[index]['shapeColoList'],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Image.asset(
                      _listCard[index]['image'],
                      fit: BoxFit.fill,
                      height: 64.w,
                      width: 77.w,
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.w),
                      Text(
                        _listCard[index]['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 32.sp,
                          color: Color(0xffffffff),
                        ),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        _listCard[index]['subtitle'],
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 40.w,
            childAspectRatio: 600.w / 160.w),
      ),
    );
  }
}
