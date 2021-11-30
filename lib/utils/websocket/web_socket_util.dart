import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:power_logger/power_logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:aku_community/widget/others/user_tool.dart';

const String baseUri = 'wss://test.kaidalai.cn/websocket/app';
enum SOCKETSTATUS {
  CONNECTED, //已连接
  BREAKOFF, //已断开
  CLOSED, //已关闭
}

class WebSocketUtil {
  static final WebSocketUtil _socket = WebSocketUtil._();

//内部构造函数
  WebSocketUtil._();
//单例模式
  factory WebSocketUtil() => _socket;

  IOWebSocketChannel? _webSocket;

  ///用户设置不同的服务器地址
  String _user = 'admin';

  ///连接状态
  SOCKETSTATUS _socketStatus = SOCKETSTATUS.CLOSED;

  ///心跳计时器；
  Timer? _heartTimer;

  ///心跳间隔
  Duration _heartDuration = Duration(seconds: 30);

  ///重连计数器
  int _reconnectCount = 0;

  ///重连最大次数
  int _reconnectTimes = 30;

  ///重连计时器
  Timer? _reconnectTimer;

  ///连接错误回调
  Function(dynamic e)? onError;

  ///开启回调
  Function? onStart;

  ///接收消息回调
  Function(String message)? onReceiveMes;

  ///关闭连接回调；
  Function? onClosed;

  ///控制台输出
  bool _consolePrint = true;

  ///注册websocket
  void initWebSocket(
      {Duration? heartDuration,
      bool? consolePrint,
      Function? onStart,
      Function(String message)? onReceiveMes,
      Function? onClosed,
      Function(dynamic e)? onError}) {
    this.onStart = onStart;
    this.onReceiveMes = onReceiveMes;
    this.onClosed = onClosed;
    this.onError = onError;
    if (consolePrint != null) {
      this._consolePrint = consolePrint;
    }
    if (heartDuration != null) {
      this._heartDuration = heartDuration;
    }
    print('——————————webSocket init ——————————');
  }

  ///设置用户
  void setUser(String user) {
    this._user = user;
  }

  ///开启websocket
  void startWebSocket() {
    closeWebSocket();
    try {
      _webSocket = IOWebSocketChannel.connect(Uri.parse('$baseUri/$_user'));
      print('webSocket已连接服务器：$baseUri/$_user');
      _socketStatus = SOCKETSTATUS.CONNECTED;
      endReconnect();
      onStart?.call();
      _webSocket!.stream.listen(
          (event) => webSocketReceiveMessage(event as String),
          onError: webSocketOnError,
          onDone: webSocketClosed);
      initHeartBeat();
    } catch (e) {
      BotToast.showText(text: 'webSocket连接失败');
      onError?.call(e);
      LoggerData.addData(e);
    }

    WebSocketUtil().setPrintHeart(true);
    UserTool.appProveider.setFireAlert(true);
  }

  //接收消息回调
  webSocketReceiveMessage(message) {
    if (message == '心跳正常') {
      _dPrint('心跳正常————————${DateTime.now()}');
    } else {
      onReceiveMes?.call(message);
    }
  }

  //关闭连接回调
  webSocketClosed() {
    closeWebSocket();
    onClosed?.call();
  }

  //连接出错回调
  webSocketOnError(e) {
    WebSocketChannelException ex = e;
    _socketStatus = SOCKETSTATUS.BREAKOFF;
    onError?.call(ex.message);
    print('——————连接断开，开始重连');
    startReconnect();
  }

  //启动重连计时
  void startReconnect() {
    endReconnect();
    _reconnectTimer = Timer.periodic(Duration(milliseconds: 5000), (timer) {
      _reconnectCount++;
      print('——————第${_reconnectCount}次重连');
      startWebSocket();
      if (_reconnectCount >= _reconnectTimes) {
        print('——————重连失败');
        closeWebSocket();
      }
    });
  }

  //重置重连计时
  void endReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectCount = 0;
  }

  ///初始化心跳
  void initHeartBeat() {
    destoryHeart();
    _heartTimer = Timer.periodic(_heartDuration, (timer) {
      sentHeart();
    });
  }

  //发送心跳
  void sentHeart() {
    sendMessage('heartbeat');
  }

  ///销毁心跳
  void destoryHeart() {
    _heartTimer?.cancel();
    _heartTimer = null;
  }

  ///关闭websocket
  void closeWebSocket() {
    if (_webSocket != null) {
      _webSocket!.sink.close();
      print('——————websocket连接已关闭');
    }
    endReconnect();
    destoryHeart();
    UserTool.appProveider.setFireAlert(false);
    _socketStatus = SOCKETSTATUS.CLOSED;
  }

  ///向websocket服务器发送消息
  void sendMessage(message) {
    if (_webSocket != null) {
      switch (_socketStatus) {
        case SOCKETSTATUS.CONNECTED:
          _dPrint('发送中：' + message);
          _webSocket!.sink.add(message);
          break;
        case SOCKETSTATUS.CLOSED:
          print('连接已关闭');
          break;
        case SOCKETSTATUS.BREAKOFF:
          print('发送失败');
          break;
        default:
          break;
      }
    }
  }

  //封装print
  void _dPrint(dynamic data) {
    if (this._consolePrint) {
      print(data);
    }
  }

  ///控制台输出心跳连接
  void setPrintHeart(bool value) {
    this._consolePrint = value;
  }
}
