import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/model/manager/article_QR_code_model.dart';
import 'package:aku_community/model/manager/moving_company_model.dart';
import 'package:aku_community/model/manager/questionnaire_detail_model.dart';
import 'package:aku_community/model/manager/quetionnaire_submit_model.dart';
import 'package:aku_community/model/manager/voting_detail_model.dart';
import 'package:aku_community/models/manage/fix_report/fix_detail_model.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';

class ManagerFunc {
  @Deprecated('')
  static insertVisitorInfo(int id, int type, String name, int sex, String tel,
      String carNum, DateTime expectedVisitDate) async {
    BaseModel baseModel = await NetUtil().post(
      API.manager.insertVisitorInfo,
      params: {
        'buildingUnitEstateId': id,
        'type': type,
        'name': name,
        'sex': sex,
        'tel': tel,
        'carNum': carNum,
        'expectedVisitDate': NetUtil.getDate(expectedVisitDate),
      },
      showMessage: true,
    );
    return baseModel;
  }

  static Future<String?> shareVisitor({
    required int? estateId,
    String? name,
    String? tel,
    int? sex,
    String? carNumber,
    DateTime? date,
  }) async {
    final cancel = BotToast.showLoading();
    Map<String, dynamic> params = {
      'estateId': estateId,
    };
    if (name != null) params.putIfAbsent('name', () => name);
    if (tel != null) params.putIfAbsent('tel', () => tel);
    if (sex != null) params.putIfAbsent('sex', () => sex);
    if (carNumber != null) params.putIfAbsent('carNumber', () => carNumber);
    if (date != null)
      params.putIfAbsent('visitDateStart', () => NetUtil.getDate(date));
    Response response = await NetUtil().dio!.post(
          API.manager.shareInvite,
          data: params,
        );
    cancel();
    if (response.data['status'] && response.data['code'] != null) {
      return response.data['code'];
    }
    return null;
  }

  static reportRepairInsert(
      int? id, int type, String reportDetail, List<String?> fileUrls) async {
    BaseModel baseModel = await NetUtil().post(
      API.manager.reportRepairInsert,
      params: {
        'buildingUnitEstateId': id,
        'type': type,
        'reportDetail': reportDetail,
        'fileUrls': fileUrls,
      },
      showMessage: false,
    );
    return baseModel;
  }

  static reportRepairDelete(List<int?> ids) async {
    BaseModel baseModel = await NetUtil().post(
      API.manager.reportRepairDelete,
      params: {'ids': ids},
      showMessage: true,
    );
    return baseModel;
  }

  static Future<FixDetailModel> reportRepairFindBYLD(int? id) async {
    Response response = await NetUtil().dio!.get(
      API.manager.reportRepairFindBYLD,
      queryParameters: {
        'repairId': id,
      },
    );
    return FixDetailModel.fromJson(response.data);
  }

  static Future<BaseModel> reportRepairCancel(int? id) async {
    BaseModel baseModel = await NetUtil().get(API.manager.reportRepairCancel,
        params: {
          'repairId': id,
        },
        showMessage: true);
    return baseModel;
  }

  static Future<BaseModel> reportRepairEvaluate(
      int? id, int? rate, String text) async {
    BaseModel baseModel = await NetUtil().post(
      API.manager.reportRepairEvaluate,
      params: {
        'repairId': id,
        'evaluationLevel': rate,
        'evaluationContent': text,
      },
      showMessage: true,
    );
    return baseModel;
  }

  static Future<BaseModel> reportRepairComplete(int? id) async {
    BaseModel baseModel = await NetUtil().get(
      API.manager.reportRepairComplete,
      params: {
        'repairId': id,
      },
      showMessage: true,
    );
    return baseModel;
  }

  static Future<BaseModel> reportRepairAlipay(int? id, double total) async {
    BaseModel baseModel = await NetUtil().post(
      API.pay.reportRepairAlipay,
      params: {
        'repairId': id,
        'payType': 1,
        'payPrice': total,
      },
      showMessage: false,
    );
    return baseModel;
  }




  static Future<MovingCompanyModel> getMovingCompanyTel() async {
    Response response = await NetUtil().dio!.get(
          API.manager.getMovingCompanyTel,
        );
    return MovingCompanyModel.fromJson(response.data);
  }

  static Future<BaseModel> articleOutSubmit({
    int? id,
    String? name,
    int? weight,
    int? approach,
    String? tel,
    required String time,
    List<String?>? urls,
  }) async {
    BaseModel baseModel = await NetUtil().post(
      API.manager.articleOutSubmit,
      params: {
        'buildingUnitEstateId': id,
        'name': name,
        'weight': weight,
        'approach': approach,
        'movingCompanyTel': tel,
        'expectedTime':
            DateUtil.formatDateStr(time, format: "yyyy-MM-dd HH:mm:ss"),
        'imgUrls': urls,
      },
      showMessage: true,
    );
    return baseModel;
  }

  static Future<ArticleQRModel> getQRcode(int? id) async {
    Response response = await NetUtil().dio!.get(
      API.manager.getQRcode,
      queryParameters: {
        'articleOutId': id,
      },
    );
    return ArticleQRModel.fromJson(response.data);
  }

  static Future<BaseModel> articleOutDelete(List<int?> ids) async {
    BaseModel baseModel = await NetUtil().post(
      API.manager.articleOutDelete,
      params: {'ids': ids},
      showMessage: true,
    );
    return baseModel;
  }

  static Future<BaseModel> fromLoss(int? id) async {
    BaseModel baseModel = await NetUtil().get(
      API.manager.fromLoss,
      params: {'articleBorrowId': id},
      showMessage: true,
    );
    return baseModel;
  }

  static Future<BaseModel> findEstatelsPayment() async {
    BaseModel baseModel = await NetUtil().get(
      API.manager.findEstatelsPament,
      showMessage: false,
    );
    return baseModel;
  }

  static Future<VotingDetailModel> voteDetail(int? id) async {
    BaseModel baseModel = await NetUtil().get(
      API.manager.voteDetail,
      params: {'voteId': id},
      showMessage: false,
    );
    return VotingDetailModel.fromJson(baseModel.data);
  }

  static Future<BaseModel> vote(int? voteId, int? candleId) async {
    BaseModel baseModel = await NetUtil().post(API.manager.vote, params: {
      'voteId': voteId,
      'candidateId': candleId,
    });
    return baseModel;
  }

  static Future<QuestionnaireDetialModel> questionnairefindById(int? id) async {
    BaseModel baseModel = await NetUtil().get(
      API.manager.questionnairefindById,
      params: {
        'questionnaireId': id,
      },
      showMessage: false,
    );
    return QuestionnaireDetialModel.fromJson(baseModel.data);
  }

  static Future<BaseModel> questionnaireSubmit(
      int? id, List<AppQuestionnaireAnswerSubmits> model) async {
    BaseModel baseModel = await NetUtil().post(
      API.manager.questionnaireSubmit,
      params: {
        'id': id,
        'appQuestionnaireAnswerSubmits': model,
      },
      showMessage: true,
    );
    return baseModel;
  }
}
