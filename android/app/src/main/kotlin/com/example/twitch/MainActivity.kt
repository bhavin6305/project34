package com.example.twitch

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourapp.rtmp/control"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startStream" -> {
                    val rtmpUrl = call.argument<String>("rtmpUrl") ?: ""
                    val streamTitle = call.argument<String>("streamTitle") ?: ""
                    if (rtmpUrl.isNotEmpty()) {
                        val intent = Intent(this, StreamActivity::class.java)
                        intent.putExtra("rtmpUrl", rtmpUrl)
                        intent.putExtra("streamTitle", streamTitle)
                        intent.putExtra("autoStart", true)
                        startActivity(intent)
                        result.success("ok")
                    } else {
                        result.success("missing_url")
                    }
                }
                "stopStream" -> {
                    // TODO: Implement stop broadcast properly if needed
                    result.success("ok")
                }
                else -> result.notImplemented()
            }
        }
    }
}
