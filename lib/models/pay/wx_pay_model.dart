import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wx_pay_model.g.dart';

@JsonSerializable()
class WxPayModel extends Equatable {
  final String appId;
  final String prepayId;
  final String partnerId;
  final String timeStamp;
  final String nonceStr;
  final String package;
  final String sign;

  factory WxPayModel.fromJson(Map<String, dynamic> json) =>
      _$WxPayModelFromJson(json);


  const WxPayModel({
    required this.appId,
    required this.prepayId,
    required this.partnerId,
    required this.timeStamp,
    required this.nonceStr,
    required this.package,
    required this.sign,
  });

  @override
  List<Object?> get props => [
        appId,
        prepayId,
        partnerId,
        timeStamp,
        nonceStr,
        package,
        sign,
      ];
}
