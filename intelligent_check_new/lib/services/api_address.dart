class ApiAddress {
  // API地址
  static const String DEFAULT_BIZ_API_URL =
      "http://k272n6.natappfree.cc";//"http://yeejoin.3322.org:3287/";//"http://yeejoin.3322.org:3320/";//"http://wvun7x.natappfree.cc"; //

  // "http://113.137.39.115:9002";http://113.137.39.115:9004/apk/version.json
  static const String DEFAULT_UPDATE_URL = "http://113.137.39.115:9004/apk/version.json";

  ///JPUSH
  static const String RegisterUser="/api/user/PushDeviceRegistration/";
  //----------隐患治理----------
  //任务列表（按条件过滤）
  static const String TASK_INFO_BYFILTER = "/api/task/queryTasksByPage";

  //任务统计饼图
  static const String TASK_CHARTS = "/api/task/queryTaskCharts";

  //任务详情
  static const String TASK_Details = "/api/task/queryTask";

  //转发
  static const String TASK_Forward = "/api/task/forwardTask";

  //处理信息
  static const String PROCESSINFO = "/api/task/queryTaskRecordByTaskId";

  //任务添加
  static const String TASK_ADD = "/api/task/queryTaskRecordByTaskId";

  //保存任务处理反馈
  static const String TASK_FEEDBACKTASK = "/api/task/feedbackTask";

//---------我的-----------
  //修改密码
  static const String CHANGE_PSWD = "/api/user/editPassword";

  //登出
  static const String LOGOUT = "/system/loginOut";
//  static const String LOGOUT_AUTH = "/v1/system/loginOut";
  static const String LOGOUT_AUTH = "/api/user/mobile/loginOut";

  //通讯录
  static const String CONTACT = "/api/user/queryDeptUserTree";

  //消息订阅
  static const String SUBSCRIBE = "/api/msgSubscribe/querySubscribe";

  //static const String LOGIN="/system/login";
//  static const String LOGIN = "/v1/system/appLogin"; //2019-9-2  接口修改
  static const String LOGIN = "/api/user/mobile/login"; //2019-11-27  接口修改



//  巡检记录列表（按条件查询）
  static const String INSPECTIONRECORD = "/api/check/list";

  // 获取公司列表
  static const String QUERY_AUTH_COMPANY_LEAVES =
      "/api/group/queryAuthCompanyLeaves";

  // 切换公司
  static const String CHANGE_COMPANY = "/safe/save/curCompany";

//  static const String SAVE_SELCOM = "/safe/save/curCompany";
  static const String SAVE_SELCOM = "/api/user/save/curCompany";

  // 查询线路列表（所有，无分页）/api/route/routeList 实现后更换地址
  static const String ROUTE_LIST = "/api/route/routeList";

  // 查询计划列表（所有，无分页）/api/plan/queryPlanList 实现后更换地址
  static const String Plan_LIST = "/api/plan/queryPlanList";
//巡检点等级获取
  static const String PLANLEVEL="/api/user/listselect";

  // 巡检点分页查询接口
  static const String QUERY_POINT_BY_PAGE = "/api/point/queryPointByPage";

  // 巡检点编号查询
  static const String QUERY_POINTNO = "/api/point/queryPointNo/-1";

  // 巡检点详情接口
  static const String GET_POINT_DETAIL_BY_ID =
      "/api/point/queryPointDetailById";

  //手机端巡检点详情接口
  static const String GET_POINT_DETAIL_BY_ID_MOBILE =
      "/api/point/mobile/getPointInfo";

  //设备详情
  static const String GET_Equipment_DETAIL_BY_ID =
      "/api/point/mobile/equipment/detail";

//危险因素
  static const String GET_RISKFACTORS_DETAIL_BY_ID =
      "/api/point/mobile/riskFactor/detail";

  // 巡检点检查详情
  static const String GET_QUERY_CHECK_POINT_DETAIL =
      "/api/check/queryCheckPointDetail";

  //巡检计划列表（按条件查询）
  static const String QUERYPLANTASK = "/api/planTask/queryPlanTask";

  //计划详情
  static const String QUERYPLANTASKBYID = "/api/planTask/queryPlanTaskById";

  // 计划巡检新增巡检记录页面初始化信息获取 ?planTaskId=560&pointId=11 无计划巡检不传递planTaskId
  static const String INIT_PLAN_TASK = "/api/planTask/initPlanTask";

  // 保存巡检记录 返回巡检记录ID
  static const String SAVE_CHECK_RECORD = "/api/check/saveRecord";

  // 设置（开启或关闭）离线巡检模式
  static const String SET_PATROL_MODE = "/api/point/setPatrolMode";

  // NFC 发卡
  static const String POINT_BIND_NFC = "/api/point/pointBindNfc";

  // 分页查询检查项
  static const String QUERY_ITEM_BY_PAGE = "/api/inputItem/queryItemByPage";

  // 保存安全执行点
  static const String ADD_MOVE_POINT = "/api/point/addMovePoint";

  // 扩展分类列表
  static const String QUERY_CATALOG_LIST = "/api/catalogTree/catalogList";

  // 检查记录图片上传接口?checkId=1&pointId=1&inputItemId=1&name=图片分类名 ，检查点图片不传inputItemId参数
  static const String UPLOAD_CHECK_FILE = "/api/check/uploadCheckImg";

  //巡检日历
  static const String CHECK_CALENDAR = "/api/check/checkCalendar";

  //---------------统计接口---------------

  //巡检点状态统计
  static const String POINT_STATE_COUNT1 = "/api/point/queryPointPie";
  static const String POINT_STATE_COUNT2 = "/api/point/queryPointHistogram";

  //计划执行情况统计
  static const String PLANRUN_STATE_COUNT =
      "/api/planTask/queryPlanTaskStatistics";

  //隐患治理任务统计
  static const String HID_DANGER_TASK_COUNT = "/api/task/queryTaskStatistics";

  // 安全执行，巡检点记录接口
  static const String CHECK_POINT_RECORD_LIST = "/api/check/queryCheckRecord";

  // 获取当前用户所选公司的所有部门
  static const String DEPARTMENT_INFO = "/api/group/queryDept";

  // 获取通讯录
  // static const String CONTACT_INFO = "/api/user/queryUserAddressList";
//  static const String CONTACT_INFO = "/v1/user/tree";
  static const String CONTACT_INFO = "/api/user/mobile/addressList";

  // 巡检点详情
  static const String QUERY_POINT_DETAIL_BY_ID =
      "/api/point/queryPointDetailById";

  // 无计划巡检
  static const String QUERY_PLANT_ASK_BY_SERIAL =
      "/api/planTask/queryPlanTaskBySerial";

  // 未执行巡检计划数量
  static const String QUERY_PLAN_TASK_COUNT =
      "/api/planTask/queryPlanTaskCount";

  // 消息数量（首页右上角消息数量获取，红点控制）
  static const String UNREAD_COUNT = "/api/msgSubscribe/unreadCount";

  // 巡检记录详情
  static const String QUERY_CHECK_DETAIL = "/api/check/queryCheckDetail";

  // 任务添加
  static const String TASK_ADD_NEW = "/api/task/addTask";

  // 未开始巡检点，点击获取巡检点详情
  static const String QUERY_POINT_PLANTASK_DETAIL =
      "/api/planTask/queryPointPlanTaskDetail";

  // 巡检记录不合格项（从不合格记录中添加任务时，调用查询不合格项）
  static const String QUERY_UNQUALIFIED_INPUT_ITEM =
      "/api/check/queryUnqualifiedInputItem";

  // message
  // 获取消息分类
  static const String MESSAGE_TYPE = "/api/msgSubscribe/MsgType";

  // 根据条件获取消息列表
  static const String MESSAGE_LIST = "/api/msgSubscribe/msgList";

  // 消息订阅，页面数据查询
  //  static const String QUERY_SUBSCRIBE="/api/msgSubscribe/querySubscribe";
  // 消息已读
  static const String MESSAGE_READ = "/api/msgSubscribe/isRead";

  // 消息订阅，页面数据保存
  static const String SAVE_SUBSCRIBE = "/api/msgSubscribe/saveSubscribe";

  static const String CANCEL_TASK = "/api/task/handleTask";

  //巡检计划列表（按条件查询）
  static const String OFFLINE_QUERYPLANTASK =
      "/api/planTask/queryLeavePlanTask";
  static const String QUERY_OFFLINE_TASKS = "/api/task/queryOfflineTasks";
  static const String QUERY_OFFLINE_POINT = "/api/point/queryLeavelPoint";
  static const String QUERY_OFFLINE_MOVEPOINT =
      "/api/point/queryLeavelMovePoint";
  static const String INIT_CARD_AND_OFFLINE =
      "permissionItem/searchPermission-tree";

  // config
  static const String SYSTEM_CONFIG = "/api/config/getConfigsInfo";

  // init data 登录初始化信息
  static const String INIT_DATA = "/api/user/initData";

//  static const String LOGIN_INFO = "/v1/user/me";
  static const String LOGIN_INFO = "/api/user/selectInfo";

  ///隐患接口ApiAddress
  //获取隐患列表
  static const String HIDDEN_DANGER_LIST = "/api/latent/danger/list";

  //获取隐患详细信息
  static const String HIDDEN_DANGER_DETAIL = "/api/latent/danger/detail";

  //创建普通隐患
  static const String HIDDEN_DANGER_CREATE_NORMAL =
      "/api/latent/danger/normal/save";

  //创建巡检隐患
  static const String HIDDEN_DANGER_CREATE_PATROL =
      "/api/latent/danger/patrol/save";

  //流程执行
  static const String HIDDEN_DANGER_EXECUTE = "/api/latent/danger/excute";

  // static const String HIDDEN_DANGER_IMGUPDATE = "/api/latent/danger/upload";
  static const String HIDDEN_DANGER_IMGUPDATE = "/api/common/upload";

  //执行日志
  static const String HIDDEN_DANGER_FLOWRECORDS =
      "/api/latent/danger/listFlowRecord";

  //获取是否有待处理任务
  static const String GET_ALL_TASK_STATUS = "/api/common/getHaveToDo";

  ///作业活动==============================================================
  //作业活动列表获取
  static const String ACTIVILITY_LIST = "/api/taskwork/mobile/list";

  //详细获取
  static const String ACTIVILITY_DETAIL = "/api/taskwork/mobile/detail";

  //流程执行
  static const String ACTIVILITY_EXECUTE = "/api/taskwork/mobile/excute";

  static const String ACTIVILITY_RUNLOG="/api/taskwork/mobile/listExecuteLog";

  static const String ACTIVILITY_UPDATEMEASURES="/api/taskwork/mobile/taskworkContent/updateMeasures";
  static const String ACTIVILITY_TASKWORK_DETAIL="/api/taskwork/mobile/taskworkContent/detailTree";
  //作业活动步骤
//  static const String ACTIVILITY_STEPS = "/api/taskwork/mobile/contents";
  static const String ACTIVILITY_STEPS =
      "/api/taskwork/mobile/taskworkContent/list";

//
  static const String ACTIVILITY_STEPS_DETAIL =
      "/api/taskwork/mobile/taskworkContent/detail";

  static const String ACTIVILITY_STEPS_DETAIL_AND_LIST =
      "/api/taskwork/mobile/taskworkContent/list";

  //启动作业流程
  static const String ACTIVILITY_STARTFLOW = "/api/taskwork/startFlow";

  //流程执行记录
  static const String ACTIVILITY_EXECUTE_RECORD ="/api/taskwork/mobile/listFlowRecord";

  ///安全风险研判============================================================
  static const String SECURITY_RISK_LIST = "/api/riskJudgment/mobile/list";

  static const String SECURITY_RISK_DETAIL = "/api/riskJudgment/mobile/detail";
  static const String SECURITY_RISK_RECORD = "/api/riskJudgment/mobile/record";

  static const String SECURITY_RISK_RUN = "/api/riskJudgment/mobile/items/";

  static const String SECURITY_RISK_UPDATETASKSTATUS ="/api/riskJudgment/mobile/updateTaskStatus";

  ///统计==========================================================================
  static const String STATISTICS_LIST = "/api/stats/list";

  static const String STATISTICS_TYPE_DETAIL = "/api/stats/detail";

  ///GPS信息更新====================================================================
   static  const String GPS_ADD_ROUTE="/api/patrol/addRoute";

   ///监控视频获取===================================================================
    static  const String VIDEOLIST="/api/check/getvideo";

    static  const String VIDEOURL="/api/check/tokenurl";


}
