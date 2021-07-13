// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house_keeping_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseKeepingListModel _$HouseKeepingListModelFromJson(
    Map<String, dynamic> json) {
  return HouseKeepingListModel(
    id: json['id'] as int,
    proposerName: json['proposerName'] as String,
    proposerTel: json['proposerTel'] as String,
    roomName: json['roomName'] as String,
    type: json['type'] as int,
    content: json['content'] as String,
    status: json['status'] as int,
    completion: json['completion'] as int?,
    processDescription: json['processDescription'] as String?,
    handlingTime: json['handlingTime'] as String?,
    payFee: (json['payFee'] as num?)?.toDouble(),
    evaluation: json['evaluation'] as int?,
    evaluationContent: json['evaluationContent'] as String?,
    evaluationTime: json['evaluationTime'] as String?,
    createDate: json['createDate'] as String,
    submitImgList: (json['submitImgList'] as List<dynamic>)
        .map((e) => ImgModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
