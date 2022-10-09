import 'dart:io';
import 'dart:typed_data';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/models/house/lease_detail_model.dart';
import 'package:aku_community/models/house/lease_echo_model.dart';
import 'package:aku_community/models/house/submit_model.dart';
import 'package:aku_community/models/pay/wx_pay_model.dart';
import 'package:aku_community/models/user/passed_house_list_model.dart';
import 'package:aku_community/utils/network/base_file_model.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:bot_toast/bot_toast.dart';

class HouseFunc {

  ///查询业委会的手机号
  Future<String> getPhone() async {
    BaseModel model =
    await NetUtil().get(API.manager.findOwnersTel);
    if (model.status ?? false) {
      return model.data ?? '';
    } else {
      return '';
    }
  }


  ///查询所有的房屋审核信息
  static Future<List<PassedHouseListModel>> get examineHouses async {
    BaseModel model = await NetUtil().get(API.user.examineHouseList);
    if (!model.status!) return [];
    return (model.data as List)
        .map((e) => PassedHouseListModel.fromJson(e))
        .toList();
  }

  ///查询用户所拥有的房屋信息
  static Future<List<PassedHouseListModel>> get passedHouses async {
    BaseModel model = await NetUtil().get(API.user.passedHouseList);
    if (!model.status!) return [];
    return (model.data as List)
        .map((e) => PassedHouseListModel.fromJson(e))
        .toList();
  }

  ///我的房屋 租赁认证
  Future leaseCertification(
    String name,
    String sex,
    String tel,
    String idNumber,
  ) async {
    BaseModel baseModel =
        await NetUtil().post(API.house.leaseCertification, params: {
      "name": name,
      "sex": getSex[sex],
      "tel": tel,
      "idNumber": idNumber,
    });
    if (baseModel.status ?? false) {
      BotToast.showText(text: '提交成功');
      return true;
    }
    return false;
  }

  ///租赁认证信息回显
  static Future leaseEcho() async {
    BaseModel baseModel = await NetUtil().get(API.house.leaseEcho);
    if (baseModel.status ?? false) {
      return LeaseEchoModel.fromJson(baseModel.data);
    } else {
      return LeaseEchoModel.fail();
    }
  }

  ///获得租赁详情信息
  Future<LeaseDetailModel?> leaseDetail(int leaseId) async {
    BaseModel baseModel = await NetUtil().get(API.house.leaseFindByld, params: {
      "leaseId": leaseId,
    });
    if (baseModel.status ?? false) {
      return LeaseDetailModel.fromJson(baseModel.data);
    } else {
      return null;
    }
  }

  ///上传身份证照片正面
  Future<String> uploadIdCardFront(File file) async {
    BaseFileModel baseFileModel =
        await NetUtil().upload(API.upload.uploadCardFront, file);
    if (baseFileModel.status ?? false) {
      return baseFileModel.url ?? '';
    } else {
      return '';
    }
  }

  ///上传身份证照片背面
  Future<String> uploadIdCardBack(File file) async {
    BaseFileModel baseFileModel =
        await NetUtil().upload(API.upload.uploadCardBack, file);
    if (baseFileModel.status ?? false) {
      return baseFileModel.url ?? '';
    } else {
      return '';
    }
  }

  ///提交个人租赁信息
  Future<String> submitLeaseInfo(SubmitModel model) async {
    BaseModel baseModel =
        await NetUtil().post(API.house.submitLeaseInfo, params: {
      "id": model.id,
      "emergencyContact": model.emergencyContact,
      "emergencyContactNumber": model.emergencyContactNumber,
      "correspondenceAddress": model.correspondenceAddress,
      "workUnits": model.workUnits,
      "payBank": model.payBank,
      "bankAccountName": model.bankAccountName,
      "bankAccount": model.bankAccount,
      "idCardFrontImgUrl": model.idCardFrontImgUrl,
      "idCardBackImgUrl": model.idCardBackImgUrl,
    });
    if (baseModel.status ?? false) {
      return baseModel.data;
    } else {
      return '';
    }
  }

  ///上传合同签名
  Future<String> uploadSignName(Uint8List bytes) async {
    BaseFileModel baseFileModel = await NetUtil().uploadUnit8List(
      API.upload.uploadSignName,
      bytes,
    );
    if (baseFileModel.status ?? false) {
      BotToast.showText(text: baseFileModel.message!);
      return baseFileModel.url ?? '';
    } else {
      BotToast.showText(text: baseFileModel.message!);
      return '';
    }
  }

  ///生成正式合同（未盖章
  Future<String> generateContract(int id, String pUrl, String sUrl) async {
    BaseModel baseModel =
        await NetUtil().post(API.house.generateContract, params: {
      "id": id,
      "contractPreviewImgUrl": pUrl,
      "contractSignatureImgUrl": sUrl,
    });

    if (baseModel.status ?? false) {
      return baseModel.data;
    } else {
      return '';
    }
  }

  ///上传盖章后正式有效合同
  Future<String> uploadFormalContract(File file) async {
    BaseFileModel baseModel =
        await NetUtil().upload(API.upload.uploadFormalContract, file);
    if (baseModel.status ?? false) {
      return baseModel.url ?? '';
    } else {
      return '';
    }
  }

  ///提交盖章后正式有效合同
  Future<bool> submitFormalContract(int id, List<String> urls) async {
    BaseModel baseModel =
        await NetUtil().post(API.house.submitFormalContract, params: {
      "id": id,
      "leaseContractValidPdfUrl": urls,
    });
    return baseModel.status!;
  }

  ///支付宝生成订单
  ///支付方式暂时写死为1，只支持支付宝支付
  ///1支付，2微信 3现金 4pos
  Future<String> leaseAlipay(int id, int type, double price) async {
    BaseModel baseModel = await NetUtil().post(API.pay.leaseAlipay, params: {
      "sysLeaseId": id,
      "payType": type,
      "payPrice": price,
    });
    if (baseModel.status ?? false) {
      return baseModel.message ?? '';
    } else {
      return '';
    }
  }

  Future<WxPayModel?> leaseVxPay(int id, int type, double price) async {
    var baseModel = await NetUtil().post(API.pay.leaseVxPay, params: {
      "sysLeaseId": id,
      "payType": type,
      "payPrice": price,
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }


  ///上传腾空单
  Future<List<String>> uploadClearingSingle(List<File> files) async {
    List<String> urls =
        await NetUtil().uploadFiles(files, API.upload.uploadClearingSingle);
    return urls;
  }

  ///我的房屋终止合同：提交终止申请
  Future<bool> submitTerminationApplication(
    int id,
    String takeDate,
    List<String> urls,
  ) async {
    BaseModel baseModel = await NetUtil().post(
        API.house.submitTerminateApplication,
        params: {"id": id, "takeDate": takeDate, "clearingSingleImgUrl": urls});
    if (baseModel.status ?? false) {
      return true;
    } else {
      return false;
    }
  }

  ///支付宝支付：app 房屋租赁-剩余需结清房租支付 完成订单支付宝支付(生成 APP 支付订单信息)
  ///支付方式暂写死为1
  ///支付方式：1.支付宝 2.微信 3.现金 4.pos
  Future<String> leaseRentOrder(int id, int type, double price) async {
    BaseModel baseModel = await NetUtil().post(API.pay.leaseRentOrderAlipay,
        params: {"sysLeaseId": id, "payType": type, "payPrice": price});
    if (baseModel.status ?? false) {
      return baseModel.message!;
    } else {
      return '';
    }
  }

  ///我的房屋-合同终止：app 房屋租赁-剩余需结清租金支付(当剩余需结清租金 小于等于 0 时调用)：
  Future<bool> leaseRentOrderNegative(int id, double price) async {
    BaseModel baseModel =
        await NetUtil().post(API.pay.leaseRentOrderNegative, params: {
      "sysLeaseId": id,
      "payPrice": price,
    });
    return baseModel.status ?? false;
  }

  ///我的房屋-合同终止：保证金退还申请
  Future<bool> refundBond(int id) async {
    BaseModel baseModel =
        await NetUtil().get(API.house.refundApplication, params: {
      "sysLeaseId": id,
    });
    if (baseModel.status ?? false) {
      return true;
    } else {
      return false;
    }
  }

  ///支付宝支付：app 房屋租赁-租金账单支付 完成订单支付宝支付(生成 APP 支付订单信息)
  ///支付方式暂写死为1
  ///支付方式：1.支付宝 2.微信 3.现金 4.pos
  Future<String> leaseRentBillOrder(int id, int type, double price) async {
    BaseModel baseModel = await NetUtil().post(API.pay.leaseRentBillorder,
        params: {"sysLeaseRentId": id, "payType": type, "payPrice": price});
    if (baseModel.status ?? false) {
      return baseModel.message!;
    } else {
      return '';
    }
  }

  static Map<String, int> getSex = {
    '男': 1,
    '女': 2,
  };

  static Map<int, String> toSex = {
    1: '男',
    2: '女',
  };

  static Map<int, String> toType = {1: '一类人才', 2: '二类人才', 3: '三类人才'};



  Future<WxPayModel?> dailyPaymentVxPay(List<int>  id, int type, String price) async {
    var baseModel = await NetUtil().post(API.pay.dailyPayMentVxPay, params: {
      "ids": id,
      "payType": type,
      "payPrice": price,
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }


  Future<WxPayModel?> dailPaymentPreVxPay(int id, int type, String price) async {
    var baseModel = await NetUtil().post(API.pay.dailPaymentPreVxPay, params: {
      "estateId": id,
      "payType": type,
      "payPrice": price,
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }




  Future<WxPayModel?> shareVxPayOrderCode(List<int>  id, int type, String price) async {
    var baseModel = await NetUtil().post(API.pay.shareVxPayOrderCode, params: {
      "ids": id,
      "payType": type,
      "payPrice": price,
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }

  Future<WxPayModel?> shoppingVxPay(int id, String userName, String userTel,int num, int type,double price) async {
    var baseModel = await NetUtil().post(API.pay.shoppingVxPay, params: {
      'goodsId': id,
      'userName': userName,
      'userTel': userTel,
      'num': num,
      'payType': type,
      'payPrice': price,
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }

  Future<WxPayModel?> reportRepairVxPay(int? id, double total) async {
    var baseModel = await NetUtil().post(API.pay.reportRepairVxPay, params: {
      'repairId': id,
      'payType': 2,
      'payPrice': total,
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }

  Future<WxPayModel?> leaseRentOrderVxPay(int id, int type, double price) async {
    var baseModel = await NetUtil().post(API.pay.leaseRentOrderVxPay, params: {
      "sysLeaseId": id, "payType": type, "payPrice": price
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }


  Future<WxPayModel?> leaseRentBillOrderVxPay(int id, int type, double price) async {
    var baseModel = await NetUtil().post(API.pay.leaseRentBillOrderVxPay, params: {
      "sysLeaseRentId": id, "payType": type, "payPrice": price
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }

  Future<WxPayModel?> housekeepingServiceOrderVxPay(int id, int type, double price) async {
    var baseModel = await NetUtil().post(API.pay.housekeepingServiceOrderVxPay, params: {
      "housekeepingServiceId": id, "payType": type, "payPrice": price
    });
    if (baseModel.status ?? false) {
      var wxPayModel = WxPayModel.fromJson(baseModel.data);
      print(wxPayModel);
      return wxPayModel;
    } else {
      return null;
    }
  }


}
