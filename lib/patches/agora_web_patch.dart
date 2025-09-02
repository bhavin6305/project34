// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;
import 'dart:html' as html;

const String agoraRendererViewType = 'AgoraRendererView';

void registerAgoraRendererViewFactory() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(agoraRendererViewType, (int viewId) {
    return html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..id = 'video-view-$viewId';
  });
}
import 'dart:async';
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;

import 'package:agora_rtc_engine/src/impl/agora_rtc_engine_impl.dart';
import 'package:agora_rtc_engine/src/impl/platform/web/rtc_engine_web.dart';
import 'package:agora_rtc_engine/src/impl/platform/web/rtc_engine_web_manager.dart';
import 'package:agora_rtc_engine/src/rtc_engine_ext.dart';

const String _platformRendererViewType = 'AgoraRendererView';

class GlobalVideoViewControllerPlatformWeb extends GlobalVideoViewControllerPlatform {
  final _RtcEngineWebManager _rtcEngineManager;
  final int _viewId;
  final String _appId;

  GlobalVideoViewControllerPlatformWeb(this._appId, this._viewId)
      : _rtcEngineManager = _RtcEngineWebManager.instance();

  static void initFlutter() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(_platformRendererViewType, (int viewId) {
      return html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..id = 'video-view-$viewId';
    });
  }

  // Rest of the class implementation from the original file...
  // Make sure you replace every instance of ui.platformViewRegistry with ui_web.platformViewRegistry
}
