package com.example.twitch

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.pedro.rtplibrary.rtmp.RtmpCamera1
import com.pedro.rtplibrary.view.OpenGlView
import net.ossrs.rtmp.ConnectCheckerRtmp

class StreamActivity : AppCompatActivity(), ConnectCheckerRtmp {

    private lateinit var openGlView: OpenGlView
    private lateinit var rtmpCamera1: RtmpCamera1
    private lateinit var tvStatus: TextView
    private lateinit var btnStop: Button

    private val REQUEST_PERMISSIONS = 1234

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_stream)

        openGlView = findViewById(R.id.opengl_preview)
        tvStatus = findViewById(R.id.tv_status)
        btnStop = findViewById(R.id.btn_stop)

        rtmpCamera1 = RtmpCamera1(openGlView, this)

        btnStop.setOnClickListener { stopStream() }

        val perms = arrayOf(Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
        val missing = perms.filter {
            ActivityCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }
        if (missing.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, perms, REQUEST_PERMISSIONS)
        } else {
            startPreviewIfReady()
        }

        val rtmpUrl = intent.getStringExtra("rtmpUrl") ?: ""
        val autoStart = intent.getBooleanExtra("autoStart", false)
        if (rtmpUrl.isNotEmpty() && autoStart) {
            startStream(rtmpUrl)
        }
    }

    private fun startPreviewIfReady() {
        if (!rtmpCamera1.isStreaming && !rtmpCamera1.isOnPreview) {
            rtmpCamera1.startPreview()
        }
    }

    private fun startStream(rtmpUrl: String) {
        if (!rtmpCamera1.isOnPreview) rtmpCamera1.startPreview()

        if (!rtmpCamera1.isStreaming) {
            if (rtmpCamera1.prepareAudio() && rtmpCamera1.prepareVideo()) {
                rtmpCamera1.startStream(rtmpUrl)
                tvStatus.text = "Connecting..."
            } else {
                tvStatus.text = "Prepare failed"
            }
        }
    }

    private fun stopStream() {
        if (rtmpCamera1.isStreaming) rtmpCamera1.stopStream()
        if (rtmpCamera1.isOnPreview) rtmpCamera1.stopPreview()
        tvStatus.text = "Stopped"
        finish()
    }

    override fun onConnectionSuccessRtmp() {
        runOnUiThread { tvStatus.text = "Streaming" }
    }

    override fun onConnectionFailedRtmp(reason: String?) {
        runOnUiThread {
            tvStatus.text = "Connect failed: $reason"
            Toast.makeText(this, "Connect failed: $reason", Toast.LENGTH_LONG).show()
        }
    }

    override fun onNewBitrateRtmp(bitrate: Long) {}
    override fun onDisconnectRtmp() { runOnUiThread { tvStatus.text = "Disconnected" } }
    override fun onAuthErrorRtmp() { runOnUiThread { tvStatus.text = "Auth error" } }
    override fun onAuthSuccessRtmp() { runOnUiThread { tvStatus.text = "Auth success" } }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_PERMISSIONS) {
            if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                startPreviewIfReady()
            } else {
                Toast.makeText(this, "Permissions required", Toast.LENGTH_LONG).show()
                finish()
            }
        }
    }
}
