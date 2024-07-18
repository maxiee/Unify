import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:unify_unipage/src/constants.dart';

typedef UniPageMethod = Future<dynamic> Function(Map<String, dynamic> params);

class UniPageController {
  final Map<String, UniPageMethod> _methods = {};

  BuildContext? buildContext;
  late String viewType;
  late int viewId;
  late MethodChannel channel;

  void registerMethod(String methodName, UniPageMethod method) {
    assert(!_methods.containsKey(methodName));
    _methods[methodName] = method;
  }

  Future<dynamic> invoke(String methodName, Map<String, dynamic> params) async {
    assert(buildContext != null);
    return await channel.invokeMethod(kChannelInvoke, {
      kChannelViewType: viewType,
      kChannelViewId: viewId,
      kChannelMethodName: methodName,
      kChannelParamsPrams: params
    });
  }

  Future<dynamic> onMethodCall(
      String method, Map<String, dynamic> params) async {
    assert(_methods.containsKey(method));
    return await _methods[method]!(params);
  }

  void init(BuildContext buildContext, String viewType, int viewId) {
    this.buildContext = buildContext;
    this.viewType = viewType;
    this.viewId = viewId;
    initChannel();
  }

  void initChannel() {
    assert(buildContext != null);
    channel = MethodChannel(createChannelName(viewType, viewId));
    channel.setMethodCallHandler((call) async {
      Map<String, dynamic> arguments =
          Map<String, dynamic>.from(call.arguments);

      switch (call.method) {
        case kChannelRoutePushNamed:
          String path = call.arguments[kChannelParamsPath];
          Map<String, dynamic> params =
              Map<String, dynamic>.from(arguments[kChannelParamsPrams]);
          Navigator.of(buildContext!).pushNamed(path, arguments: params);
          return true;
        case kChannelRoutePop:
          Map<String, dynamic> params =
              Map<String, dynamic>.from(arguments[kChannelParamsPrams]);
          Navigator.of(buildContext!).pop(params);
          return true;
        case kChannelInvoke:
          assert(arguments.containsKey(kChannelMethodName));
          assert(arguments.containsKey(kChannelParamsPrams));
          String methodName = arguments[kChannelMethodName];
          Map<String, dynamic> params =
              Map.from(arguments[kChannelParamsPrams]);
          return await onMethodCall(methodName, params);
      }
      return false;
    });
  }

  void dispose() {
    assert(buildContext != null);
    buildContext = null;
    channel.setMethodCallHandler(null);
  }
}
