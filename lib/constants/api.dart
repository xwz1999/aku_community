class API {
  ///HOST
  static const String host = 'http://test.akuhotel.com:8804';

  ///接口基础地址
  static const String baseURL = '$host/IntelligentCommunity/app';

  ///静态资源路径
  static String get resource => '$host/static';

  static String image(String path) => '$resource$path';
  static String file(String path) => '$resource$path';

  static const int networkTimeOut = 10000;
  static _Login login = _Login();
  static _User user = _User();
  static _Manager manager = _Manager();
  static _Upload upload = _Upload();
  static _Community community = _Community();
  static _Message message = _Message();
}

class _Login {
  /// 获取手机验证码
  String get sendSMSCode => '/login/sendMMSLogin';

  /// 通过验证码短信登陆
  String get loginBySMS => '/login/loginSMSUser';

  /// 查询楼栋ID
  String get buildingInfo => '/login/findAllBuildingIAN';

  ///查询单元ID
  String get unitInfo => '/login/findEstateIANByBuilding';

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
  String get houseList => '/user/myHouse/list';

  ///我的房屋：假删除审核信息
  String get deleteHouse => '/user/myHouse/falseDelete';

  ///我的车位：查询所有的车位信息
  String get carParkingList => '/user/myParkingSpace/list';

  ///我的车辆：查询所有的车辆
  String get carList => '/user/myCar/list';
}

class _Manager {
  ///获取业委会列表
  String get commiteeStaff => '/ownersCommittee/findAll';

  ///获取便民电话联系人列表
  String get convenientPhone => '/convenientTelephone/list';

  ///查询当前用户的报事报修信息
  String get fixedSubmit => '/user/reportRepair/list';

  ///访客通行：添加填写的访客信息
  String get insertVisitorInfo => '/user/visitorAccess/insertVisitorInfo';

  ///访客通行：查询访客记录信息（包含条件搜索）
  String get visitorAccessList => '/user/visitorAccess/list';

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

  ///生活缴费：查询生活缴费信息list
  String get dailyPaymentList => '/user/dailyPayment/list';

  ///生活缴费：查询当前用户的房屋是否缴费
  String get findEstatelsPament => '/user/dailyPayment/findEstateIsPayment';

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
}

class _Upload {
  ///上传咨询建议照片
  String get uploadArticle => '/user/upload/uploadArticle';

  ///上传头像
  String get uploadAvatar => '/user/upload/appHeadSculpture';

  ///上传报事报修信息 报事报修照片
  String get uploadRepair => '/user/upload/uploadRepair';

  String get uploadEvent => '/user/upload/uploadGambit';
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
