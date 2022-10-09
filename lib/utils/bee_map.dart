class BeeMap {
  static Map<int, String> fixTag = {
    1: '公区报修',
    2: '家庭报修',
  };

  static Map<int, String> fixState = {
    1: '待分配',
    2: '未接单',
    3: '处理中',
    4: '已处理',
    5: '已完成',
    6: '已关闭',
    7: '已作废',
    8: '未知'
  };

  static Map<int, String> processClass = {
    0: '未知',
    1: '报修时间',
    2: '管家分派',
    3: '师傅接单',
    4: '处理完成',
    5: '确认',
    6: '回访',
    7: '回退',
    8: '作废',
    9: '取消'
  };

  static Map<int, String> goodsOutweight = {
    1: '< 50kg',
    2: '50kg-100kg',
    3: '> 100kg',
  };
  static Map<int, String> goodsOutApproach = {
    1: '自己搬运',
    2: '搬家公司',
  };
  static Map<int, String> goodsOutStatus = {1: '审核中', 2: '审核通过', 3: '审核失败'};

  static Map<int, String> borrowStatus = {1: '出借中', 2: '已归还', 3: '待检查',-1:'审核中'};

  static Map<int, String> votingStatus = {
    1: '未开始',
    2: '进行中',
    3: '已结束',
    4: '已投票',
  };

  static Map<int, String> messageRead = {
    1: '未读',
    3: '已读',
  };

  static Map<int, bool> messageIsRead = {
    1: false,
    3: true,
  };
}
