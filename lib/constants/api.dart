class API {
  ///HOST
  static const String host = 'http://39.103.177.88:8804';

  ///接口基础地址
  static const String baseURL = '$host/IntelligentCommunity/app';

  ///静态资源路径
  static String get resource => '$host/static';

  static String image(String? path) => '$resource$path';

  static String file(String? path) => '$resource$path';

  static const int networkTimeOut = 10000;
  static _Login login = _Login();
  static _User user = _User();
  static _Manager manager = _Manager();
  static _Upload upload = _Upload();
  static _Community community = _Community();
  static _Message message = _Message();
  static _Market market = _Market();
  static _News news = _News();
  static _Search search = _Search();
  static _Pay pay = _Pay();
  static _House house = _House();
}


class _Login {
  /// 获取手机验证码
  String get sendSMSCode => '/login/sendMMSLogin';

  /// 通过验证码短信登陆
  String get loginBySMS => '/login/loginSMSUser';

  /// 查询楼栋ID
  String get buildingInfo => '/login/findAllBuildingIAN';

  ///查询单元ID
  String get unitInfo => '/login/findUnitByBuildingId';

  ///查询房间号
  String get room => '/login/findEstateIdByUnitId';

  /// app用户注册
  String get signUp => '/login/register';

  ///通过新手机号发送修改验证码
  String get sendNewMSCode => '/user/personalData/sendTelUpdateCode';
}

class _User {
  ///用户资料
  String get userProfile => '/user/personalData/findPersonalData';

  ///用户详细资料
  String get userDetail => '/user/personalData/getUserDetail';

  ///设置用户性别
  String get setSex => '/user/personalData/updateSex';

  ///设置用户生日
  String get setBirthday => '/user/personalData/updateBirthday';

  ///用户退出登陆
  String get logout => '/user/signOut';

  ///修改用户昵称
  String get updateNickName => '/user/personalData/updateNickName';

  ///修改用户手机号
  String get updateTel => '/user/personalData/updateTel';

  ///修改头像
  String get udpdateAvatar => '/user/personalData/updateHeadPortrait';

  ///意见反馈：app意见反馈提交（建议）
  String get feedback => '/user/feedback/submit';

  ///我的房屋：房屋认证(新增房屋)
  String get authHouse => '/user/myHouse/authentication';

  ///我的房屋：查询所有的房屋审核信息
  String get examineHouseList => '/user/myHouse/examineList';

  ///我的房屋：查询用户所有拥有的房屋信息
  String get passedHouseList => '/user/myHouse/houseList';

  ///我的房屋：假删除审核信息
  String get deleteHouse => '/user/myHouse/falseDelete';

  ///我的房屋：修改选中的房产审核id
  String get changeSelectExanmineId => '/user/myHouse/changeSelectExamineId';

  ///我的车位：查询所有的车位信息
  String get carParkingList => '/user/myParkingSpace/list';

  ///我的车辆：查询所有的车辆
  String get carList => '/user/myCar/list';

  ///我的收货地址
  String get myAddressList => '/user/jcookAddress/myAddress';

  ///修改收货地址
  String get updateAddress => '/user/jcookAddress/update';

  ///删除收货地址
  String get deleteAddress => '/user/jcookAddress/delete';

  ///根据父类主键id查询城市信息
  String get findByParentId => '/user/jcookAddress/findByParentId';

  ///添加收货地址
  String get insertAddress => '/user/jcookAddress/insert';

  ///设置默认收货地址
  String get settingDefaultAddress => '/user/jcookAddress/settingDefaultAddress';

  ///查询所有城市的信息 需要10秒  首次打开APP时加载调用，保存到本地
  String get findAllCityInfo => '/user/jcookAddress/findAllCityInfo';

}

class _News {
  ///app公共资讯：查询所有的资讯分类(【全部】是默认显示的值)
  String get category => '/user/news/categoryList';

  ///app公共资讯：根据资讯分类主键id查询资讯信息
  String get list => '/user/news/newsList';
}

class _Search {
  ///首页 全局搜索
  String get homeSearch => "/user/search/search";
}

class _Manager {
  _Facility facility = _Facility();

  ///获取业委会列表
  String get commiteeStaff => '/ownersCommittee/findAll';

  ///获取便民电话联系人列表
  String get convenientPhone => '/convenientTelephone/list';

  ///查询当前用户的报事报修信息
  String get fixedSubmit => '/user/reportRepair/list';

  ///访客通行：添加填写的访客信息
  String get insertVisitorInfo => '/user/visitorAccess/insertVisitorInfo';

  String get shareInvite => '/user/visitorInvite/share';

  ///访客通行：查询访客记录信息（包含条件搜索）
  String get visitorAccessList => '/user/visitorInvite/list';

  ///访客通行：获取访客设备二维码
  String get getInviteCode => '/user/doorQRCode/getVisitorsQrCode';

  ///物品出户：查询当前用户所有的物品出户信息
  String get articleOut => '/user/articleOut/list';

  ///报事报修：app提交报事报修信息
  String get reportRepairInsert => '/user/reportRepair/insert';

  ///报事报修：批量删除报事报修信息（业主端）
  String get reportRepairDelete => '/user/reportRepair/falseDelete';

  ///咨询建议/投诉表扬：查询所有的app建议咨询/投诉表扬 信息（包含条件搜索 type 【类型(1.咨询，2.建议，3.投诉，4.表扬)】）
  String get advice => '/user/advice/list';

  ///报事报修：app根据用户id和报事报修主键id查询报事报修详情（报修信息详情）
  String get reportRepairFindBYLD => '/user/reportRepair/findById';

  /// 咨询建议/投诉表扬：添加建议咨询/投诉表扬 信息
  String get addAdvice => '/user/advice/insert';

  ///建议详情
  String get adviceDetail => '/user/advice/findAdviceDetailByAdviceId';

  ///建议继续提问
  String get adviceQuestion => '/user/advice/reQuestion';

  ///建议评价
  String get adviceEvaluate => '/user/advice/evaluate';

  ///删除建议
  String get deleteAdvice => '/user/advice/falseDelete';

  ///报事报修：取消订单
  String get reportRepairCancel => '/user/reportRepair/cancel';

  /// 报事报修：确认完成订单
  String get reportRepairComplete => '/user/reportRepair/completeOrder';

  ///报事报修：用户评价
  String get reportRepairEvaluate => '/user/reportRepair/evaluate';

  ///物品出户：获取搬家公司手机号
  String get getMovingCompanyTel => '/user/articleOut/getMovingCompanyTel';

  ///物品出户：提交物品出户信息
  String get articleOutSubmit => '/user/articleOut/submit';

  ///物品出户：查询二维码信息
  String get getQRcode => '/user/articleOut/getQRCode';

  ///物品出户：app批量删除物品出户信息
  String get articleOutDelete => '/user/articleOut/falseDelete';

  ///借还管理：查询所有可借物品信息
  String get articleBorrow => '/user/articleBorrow/list';

  ///借还管理：查询该用户的所有物品借还信息
  String get articleBorrowMylist => '/user/articleBorrow/myList';

  ///借还管理：报损
  String get fromLoss => '/user/articleBorrow/frmLoss';

  ///借还管理：根据物品总类主键id查询未借出的物品明细(出借状态恒为未出借)【借取页面】
  String get articleBorrowFindDetail => '/user/articleBorrow/findDetailById';

  ///借还管理：借取物品
  String get articleBorrowGoods => '/user/articleBorrow/borrow';

  ///借还管理：归还物品
  String get articleReturnGoods => '/user/articleBorrow/articleReturn';

  ///借还管理：根据用户主键id查询需要归还物品信息（归还界面）
  String get articleReturnList => '/user/articleBorrow/findBorrowByUserId';

  ///生活缴费：查询生活缴费信息list
  String get dailyPaymentList => '/user/dailyPayment/list';

  ///生活缴费：查询当前用户的房屋是否缴费
  String get findEstatelsPament => '/user/dailyPayment/findEstateIsPayment';

  ///生活缴费：根据房产id查询对应的预付款充值金额
  String get dailyPaymentPrePay =>
      '/user/dailyPayment/findAdvancePaymentPriceByEstateId';

  ///活动投票：app查询所有活动投票信息
  String get enventVotingList => '/user/eventVoting/list';

  ///活动投票：投票详情
  String get voteDetail => '/user/eventVoting/voteDetail';

  ///活动投票：用户投票
  String get vote => '/user/eventVoting/vote';

  ///问卷调查：app查询所有的问卷调查list
  String get questionnaireList => '/user/questionnaire/list';

  ///问卷调查：根据问卷id查询问卷详情
  String get questionnairefindById => '/user/questionnaire/findById';

  ///问卷调查：app问卷调查提交
  String get questionnaireSubmit => '/user/questionnaire/submit';

  ///生活缴费：缴费记录
  String get paymentRecord => '/user/dailyPayment/paymentRecord';

  ///app 包裹代收：查询所有的快递包裹（包含条件搜索）
  String get expressPackageList => '/user/packageCollection/list';

  ///app 包裹代收：确认领取
  String get packageConfirm => '/user/packageCollection/confirmCollection';

  ///app公共资讯：根据资讯主键id 查询资讯信息详情
  String get getPublicInformationDetail => '/user/news/findNewsByNewsId';

  ///app服务浏览：查询所有的app服务浏览信息
  String get serviceBrowseList => '/user/serviceBrowsing/list';

  ///app社区介绍：查询开启的社区介绍模版
  String get communityIntroduceInfo => '/user/communityIntroduction/findEnable';

  ///获取地理信息
  String get geographyInformation => '/user/geography/findGeographyInfo';

  ///咨询建议/投诉表扬：完成反馈
  String get completeFeedBack => '/user/advice/completeFeedback';

  ///一键报警：记录一键报警信息
  String get recordAlarmInfo => '/user/alarm/insertAlarmRecord';

  ///app电子商务：查询所有的电子商务分类(【全部】是app页面默认显示的值)
  String get electronicCommercCategory =>
      '/user/electronicCommerce/categoryList';

  ///app电子商务：根据电子商务分类主键id查询电子商务信息
  String get electronicCommercList =>
      '/user/electronicCommerce/electronicCommerceList';

  ///app电子商务：根据电子商务主键id 查询电子商务信息详情
  String get electronicCommercDetail =>
      '/user/electronicCommerce/findElectronicCommerceById';

  ///设施预约：查询当前设施当前时间之后的预约时段
  String get facilityOrderDateList =>
      '/user/facilitiesAppointment/findFacilitiesAppointmentDate';

  ///新版装修管理：查询所有的新版装修信息
  String get newRenovationList => '/user/userDecorationNew/list';

  ///新版装修管理：添加新版装修信息（申请装修）
  String get insertNewRenovation => '/user/userDecorationNew/insert';

  ///app 新版装修：申请完工检查
  String get applyCompleteRenovation =>
      '/user/userDecorationNew/applicationCompletion';

  ///门禁二维码：app获取设备二维码
  String get getDoorQrCode => '/user/doorQRCode/getQrCode';

  ///app新版家政服务：查询所有的家政服务信息(包含条件搜索)
  String get houseKeepingList => '/user/housekeepingService/list';

  ///app新版家政服务：确认提交家政
  String get submitHouseKeeping =>
      '/user/housekeepingService/submitHousekeeping';

  ///app新版家政服务：根据家政服务主键id查询家政服务服务进程
  String get houseKeepingProcess =>
      '/user/housekeepingService/findHousekeepingProcessRecord';

  ///app新版家政服务：取消服务
  String get housekeepingCancel => '/user/housekeepingService/cancel';

  ///app新版家政服务：评价
  String get houseKeepingEvaluation => '/user/housekeepingService/evaluation';

  ///查询公摊缴费列表
  String get sharePayList => '/user/meterReadingShareDetails/findAllUnPayList';

  ///app抄表分摊详情管理:根据手机号查询所有的抄表公摊缴费订单记录
  String get sharePayRecord =>
      '/user/meterReadingShareDetails/findAllMeterShareOrderByTel';

  ///查询所有的已发布的户型说明
  String get houseType => '/user/houseTypeDescription/list';

  ///查询所有的周边企业信息
  String get surroundingEnterprises => '/user/surroundingEnterprises/list';

  ///生活缴费：查询未缴金额（日常缴费+公摊费）
  String get findUnpaidAmount =>
      '/user/dailyPayment/findUnpaidAmount';

}

class _Community {
  ///社区活动：查询所有的活动信息
  String get activityList => '/user/activity/list';

  ///社区活动：根据社区活动主键id查询社区活动详情
  String get activityDetail => '/user/activity/findById';

  ///社区活动：查看参与人数
  String get activityPeopleList => '/user/activity/participantsList';

  ///社区公告：查询所有的社区公告
  String get boardList => '/user/announcement/list';

  ///社区公告：根据社区公告主键id查询社区公告信息
  String get boardDetail => '/user/announcement/findById';

  ///社区话题：查询最新的所有主题信息
  String get topicList => '/user/gambit/listGambit';

  String get eventByTopicId => '/user/gambit/listByGambitId';

  String get newEventList => '/user/gambit/list';

  ///社区活动： 写帖子（添加主题信息）
  String get addEvent => '/user/gambit/writePost';

  ///社区话题：app用户点赞/取消点赞
  String get like => '/user/gambit/likes';

  ///社区话题：查询活跃话题（取前4个）
  String get hotTopic => '/user/gambit/findActivityGambit';

  ///社区话题：我的动态
  String get myEvent => '/user/gambit/myTidings';

  ///社区话题：假删除主题信息（只能删除自己的）
  String get deleteMyEvent => '/user/gambit/falseDelete';

  ///社区话题：查询主题信息详情
  String get getEventDetail => '/user/gambit/GambitThemeDetail';

  ///社区话题：评论
  String get sendAComment => '/user/gambit/comment';

  ///社区活动：报名
  String get signUpActivity => '/user/activity/signUp';

  ///资讯轮播图
  String get getSwiper => '/user/news/findNewsRotation';

  ///查询热门资讯
  String get findHotNews => '/user/news/findHotNews';

  ///资讯增加浏览量
  String get addViews => '/user/news/addViews';

  ///查询最新的所有主题信息
  String get getGambitList => '/user/gambit/list';

  ///查询最新的所有主题信息  详情
  String get gambitThemeDetail => '/user/gambit/GambitThemeDetail';

  ///查询所有的话题(按热度排序)
  String get listGambit => '/user/gambit/listGambit';

  ///查询当前话题下，所有的主题信息
  String get listByGambitId => '/user/gambit/listByGambitId';



}

class _Market {
  String get category => '/user/shop/findAllCategory';

  ///app商城中心：根据分类主键id查询商品信息列表
  String get list => '/user/shop/findGoodsByCategoryId';

  ///app商场中心：查询订阅量最高的4件商品（首页显示）
  String get hotTop => '/user/shop/findTopGoods';

  ///app商城中心：根据供应商主键id 查询预约量最高的4个商品信息(其他【4个】)
  String get suppliyerHotTop => '/user/shop/findTopGoodsBySupplierId';

  ///app商城中心：商品搜索
  String get search => '/user/shop/goodsSearch';

  ///app商城中心：根据商品主键id查询商品详情
  String get goodsDetail => '/user/shop/findDetailByGoodsId';

  ///app商城中心：商品预约
  String get appointment => '/user/shop/goodsAppointment';

  ///app商场中心：我的订单
  String get myOrderList => '/user/shop/myOrder';

  ///app商场中心：取消预约
  String get cancleOrder => '/user/shop/cancel';

  ///app商场中心：申请退换
  String get refundOrder => '/user/shop/applicationRefund';

  ///app商场中心：确认收货
  String get confirmReceive => '/user/shop/confirmReceipt';

  ///app商场中心：评价
  String get goodsEvaluation => '/user/shop/evaluation';

  ///app商场中心：根据订单主键id查询订单详情
  String get orderDetail => '/user/shop/findOrderDetailByOrderId';

  ///接入京库客
  ///jcook商城（首页搜索）：查询综合推荐商品列表
  String get findGoodsList => '/user/jcookGoods/findRecommendGoodsList';

  ///jcook商城 加入收藏
  String get addCollection => '/user/jcookCollection/collection';

  ///jcook商城 收藏列表
  String get collectionList => '/user/jcookCollection/myCollection';

  ///jcook商城 查询品牌入驻数
  String get settledBrandsNum => '/user/jcookGoods/settledBrandsNum';

  ///jcook商城 查询已上架的SKU总数
  String get skuTotal => '/user/jcookGoods/skuTotal';

  ///jcook商城 查询今日上新的产品数量
  String get newProductsTodayNum => '/user/jcookGoods/newProductsTodayNum';

  ///jcook商城 查询人气最大的几个商品
  String get findMaxPopularity => '/user/jcookGoods/findMaxPopularity';

  ///jcook商城 根据商品分类父类主键id查询首页所有显示的商品分类
  String get findAllCategoryByParentId =>
      '/user/jcookGoods/findAllCategoryByParentId';

  ///jcook商城 查询商品详情 bigInfo大图信息【加载太慢了所以异步查询该接口】
  String get findGoodsDetailBigInfo =>
      '/user/jcookGoods/findGoodsDetailBigInfo';

  ///jcook商城 查询所有品牌
  String get findAllBrand => '/user/jcookGoods/findAllBrand';

  ///jcook商城 查询综合推荐列表
  String get findRecommendGoodsList =>
      '/user/jcookGoods/findRecommendGoodsList';

  ///jcook商城 查询商品详情
  String get findGoodsDetail => '/user/jcookGoods/findGoodsDetail';

  ///jcook商城 我的购物车
  String get myShoppingCart => '/user/jcookShoppingCat/myShoppingCart';

  ///jcook商城 加入购物车
  String get insertShoppingCart => '/user/jcookShoppingCat/insertShoppingCart';

  ///jcook商城 更改购物车商品数量
  String get updateShoppingCartNum =>
      '/user/jcookShoppingCat/updateShoppingCartNum';

  ///jcook商城 删除购物车商品
  String get deleteShoppingCart => '/user/jcookShoppingCat/deleteShoppingCart';

  ///jcook商城 购物车结算
  String get settlement => '/user/jcookShoppingCat/settlement';

  ///jcook商城 我的订单
  String get myOrder => '/user/jcookOrder/myOrder';

  ///jcook商城（购物车）：我的购物车
  String get shopCarList => '/user/jcookShoppingCat/myShoppingCart';

  ///jcook商城 查询所有的可显示的分类信息 需要4秒 进入商场页面的时候加载
  String get findAllCategoryInfo => '/user/jcookGoods/findAllCategoryInfo';



  ///jcook商城（购物车）：更改购物车商品数量
  String get shopCarChangeNum => '/user/jcookShoppingCat/updateShoppingCartNum';

  ///jcook商城（购物车）：删除购物车商品
  String get shopCarDelete => '/user/jcookShoppingCat/deleteShoppingCart';

  ///jcook商城（购物车）：购物车结算
  String get shopCarSettlement => '/user/jcookShoppingCat/settlement';

  ///jcook商城 订单 取消订单
  String get cancelOrder => '/user/jcookOrder/cancel';

  ///jcook商城 订单 删除订单
  String get deleteOrder => '/user/jcookOrder/appDelete';

  ///jcook商城 订单 查看物流
  String get findLogistics => '/user/jcookOrder/findLogistics';


  ///jcook商城 订单 确认收货
  String get confirmOrder => '/user/jcookOrder/confirm';



}

class _Upload {
  ///上传咨询建议照片
  String get uploadAdvice => '/user/upload/uploadAdvice';

  ///上传头像
  String get uploadAvatar => '/user/upload/appHeadSculpture';

  ///上传报事报修信息 报事报修照片
  String get uploadRepair => '/user/upload/uploadRepair';

  String get uploadEvent => '/user/upload/uploadGambit';

  ///上传身份证照片正面
  String get uploadCardFront => '/user/upload/uploadAppIdCardFront';

  ///上传身份证背面照片
  String get uploadCardBack => '/user/upload/uploadAppIdCardBack';

  ///上传签名
  String get uploadSignName => '/user/upload/uploadLeaseContractSignaturePhoto';

  ///上传租赁有效（正式）合同pdf
  String get uploadFormalContract => '/user/upload/uploadLeaseContractValidPdf';

  ///上传腾空单
  String get uploadClearingSingle => '/user/upload/uploadAppClearingSingle';

  ///家政服务上传提交照片
  String get uploadHouseKeepingPhotos =>
      '/user/upload/uploadAppHousekeepingServiceSubmitPhone';

  ///家政服务上传评价照片
  String get uploadHouseKeepingEvaluationPhotos =>
      '/user/upload/uploadAppHousekeepingServiceEvaluationPhone';
}

class _Message {
  ///消息中心：消息中心 获取系统通知未读数量和标题
  String get center => '/user/message/messageCenter';

  ///消息中心：查询所有的系统通知
  String get sysMessageList => '/user/message/sysMessageList';

  ///消息中心：全部已读
  String get allRead => '/user/message/allRead';

  ///消息中心：阅读消息（未读 -> 已读）
  String get readMessage => '/user/message/readMessage';

  ///消息中心：根据消息列表主键id和用户主键id查询系统通知消息详情
  String get getSystemMessageDetial => '/user/message/sysMessageDetail';

  ///消息中心：查询所有的评论通知
  String get commentMessageList => '/user/message/sysCommentMessageList';

  ///消息中心：评论通知全部已读(进入评论通知列表后调用)
  String get allReadComment => '/user/message/allReadComment';
}

class _Facility {
  String get type => '/user/facilitiesAppointment/findCategoryList';

  ///设施预约：查询所有的设施预约 （包含搜索条件）
  String get appointment => '/user/facilitiesAppointment/list';

  ///设施预约：添加设施预约
  String get add => '/user/facilitiesAppointment/insert';

  ///设施预约：扫码签到
  String get scan => '/user/facilitiesAppointment/signIn';

  ///设施预约：取消预约
  String get cancel => '/user/facilitiesAppointment/cancel';

  ///设施预约：结束使用
  String get stop => '/user/facilitiesAppointment/useStop';

  ///设施预约：根据设施分类主键id查询设施信息
  String get detailType =>
      '/user/facilitiesAppointment/findFacilitiesByCategoryId';
}

class _Pay {
  ///日常缴费 支付宝支付
  String get dailyPayMentAliPay => '/user/alipay/dailyPaymentAlipay';

  ///日常缴费 查询支付宝订单状态
  String get dailPayMentCheck => '/user/alipay/dailyPaymentCheckAlipay';

  ///支付宝支付：app 商城购物完成订单支付宝支付(生成 APP 支付订单信息)
  String get shoppingAlipay => '/user/alipay/shoppingAlipay';

  ///支付宝支付：商城购物 向支付宝发起订单查询请求
  String get shoppingCheck => '/user/alipay/shoppingCheckAlipay';

  ///支付宝支付：app 报事报修完成订单支付宝支付
  String get reportRepairAlipay => '/user/alipay/reportRepairAlipay';

  ///支付宝支付：报事报修 向支付宝发起订单查询请求
  String get reportReapirCheck => '/user/alipay/reportRepairCheckAlipay';

  ///支付宝支付：app 房屋租赁完成订单支付宝支付(异步通知有可能会有问题)
  String get leaseAlipay => '/user/alipay/leaseAlipay';

  ///支付宝支付：房屋租赁 向支付宝发起订单查询请求
  String get leaseCheckAlipay => '/user/alipay/leaseCheckAlipay';

  ///支付宝支付：app 房屋租赁-剩余需结清房租支付 完成订单支付宝支付(生成 APP 支付订单信息)
  String get leaseRentOrderAlipay => '/user/alipay/leaseRentOrderAlipay';

  ///支付宝支付：房屋租赁-剩余需结清房租支付 向支付宝发起订单查询请求
  String get leaseRentCheck => '/user/alipay/leaseRentOrderCheckAlipay';

  ///支付宝支付：app 房屋租赁-租金账单支付 完成订单支付宝支付(生成 APP 支付订单信息)
  String get leaseRentBillorder => '/user/alipay/leaseRentBillOrderAlipay';

  ///支付宝支付：房屋租赁-租金账单支付 向支付宝发起订单查询请求
  String get leaseRentBillOrderCheck =>
      '/user/alipay/leaseRentBillOrderCheckAlipay';

  ///我的房屋-合同终止：app 房屋租赁-剩余需结清租金支付(当剩余需结清租金 小于等于 0 时调用)：
  String get leaseRentOrderNegative => '/user/myHouse/leaseRentOrderAlipay';

  ///支付宝支付：app 生活缴费-预充值支付 完成订单支付宝支付(生成 APP 支付订单信息)
  String get dailPaymentPrePay => '/user/alipay/advancePaymentOrderAlipay';

  ///支付宝支付：生活缴费-预充值支付 向支付宝发起订单查询请求
  String get dailPaymentPrePayCheck =>
      '/user/alipay/advancePaymentOrderCheckAlipay';

  ///支付宝支付：app 家政服务-服务费用支付 完成订单支付宝支付(生成 APP 支付订单信息)
  String get houseKeepingServiceOrderAlipay =>
      '/user/alipay/housekeepingServiceOrderAlipay';

  ///支付宝支付：家政服务-服务费用支付 向支付宝发起订单查询请求
  String get houseKeepingServieceOrderCheck =>
      '/user/alipay/housekeepingServiceOrderCheckAlipay';

  ///app 抄表记录管理-抄表分摊详情费用支付 完成订单支付宝支付(生成 APP 支付订单信息)
  String get sharePayOrderCode =>
      '/user/alipay/meterReadingShareDetailsOrderAlipay';

  ///抄表记录管理-抄表分摊详情费用支付 向支付宝发起订单查询请求
  String get sharePayOrderCodeCheck =>
      '/user/alipay/meterReadingShareDetailsOrderCheckAlipay';

  ///app jcook商品创建订单(生成APP支付订单消息)
  String get jcookOrderCreateOrder =>
      '/user/alipay/jcookOrderCreateOrder';

  ///支付宝支付：jcook商品 向支付宝发起订单查询请求
  String get jcookOrderCheckAlipay =>
      '/user/alipay/jcookOrderCheckAlipay';


}

class _House {
  ///我的房屋：租赁认证
  String get leaseCertification => '/user/myHouse/leaseCertification';

  ///我的房屋：租赁认证信息回显
  String get leaseEcho => '/user/myHouse/leaseEcho';

  ///我的房屋：查询所有的租赁信息
  String get leaseList => '/user/myHouse/leaseList';

  ///我的房屋：根据租赁主键id查询租赁信息
  String get leaseFindByld => '/user/myHouse/leaseFindById';

  ///我的房屋：提交个人租赁信息
  String get submitLeaseInfo => '/user/myHouse/submitPersonalLeaseInfo';

  ///我的房屋：生成合同
  String get generateContract => '/user/myHouse/generateValidContract';

  ///我的房屋：提交租赁审核信息
  String get submitFormalContract => '/user/myHouse/submitAudit';

  ///我的房屋-终止合同：提交终止申请
  String get submitTerminateApplication =>
      '/user/myHouse/submitTerminateApplication';

  ///我的房屋-合同终止：保证金退还申请
  String get refundApplication => '/user/myHouse/depositRefundApplication';

  ///我的房屋-缴费查询：查询所有的缴费查询（包含搜索条件）
  String get leaseFeesQuery => '/user/myHouse/findLeaseRentList';
}
