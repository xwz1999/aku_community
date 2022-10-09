// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wx_pay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WxPayModel _$WxPayModelFromJson(Map<String, dynamic> json) => WxPayModel(
      appId:json['appId'] as String,
      prepayId: json['prepayId'] as String,
      partnerId: json['partnerId'] as String,
      timeStamp: json['timeStamp'] as String,
      nonceStr: json['nonceStr'] as String,
      package: json['package'] as String,
      sign: json['sign'] as String,
    );
