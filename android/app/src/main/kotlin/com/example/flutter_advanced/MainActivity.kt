package com.example.flutter_advanced

import android.R.attr.data
import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.CountDownTimer
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date


class MainActivity : FlutterActivity() {
    private val DEFAULT_METHOD_CHANNEL = "com.example.flutter_advanced/defaultMethodChannel"
    private val JSON_METHOD_CHANNEL = "com.example.flutter_advanced/jsonMethodChannel"
    private val EVENT_CHANNEL = "com.example.flutter_advanced/eventChannel"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //Default method channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DEFAULT_METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getStringDeviceInfo" -> {
                    val arguments = call.arguments as HashMap<String, Any>
                    val type: String? = arguments["type"] as String?
                    if (type.isNullOrEmpty()) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "Arguments must be a non-null String",
                            null
                        )
                    } else {
                        result.success(getStringDeviceInfo(type))
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        //Method channel with codec JSONMethodCodec
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            JSON_METHOD_CHANNEL,
            JSONMethodCodec.INSTANCE,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getJsonDeviceInfo" -> {
                    val arguments = call.arguments
                    if (arguments is JSONObject) {
                        val type = arguments.optString("type")
                        if (type.isNullOrEmpty()) {
                            result.error(
                                "INVALID_ARGUMENTS",
                                "Arguments must be a non-null String",
                                null
                            )
                        } else {
                            result.success(getJsonDeviceInfo(type))
                        }
                    } else {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "Arguments must be a JSONObject",
                            null
                        )
                    }

                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        //Event channel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var eventSink: EventChannel.EventSink? = null
                private var timer: CountDownTimer? = null

                override fun onListen(args: Any?, events: EventChannel.EventSink) {
                    eventSink = events
                    timer = object : CountDownTimer(100000000, 1000) {
                        override fun onTick(millisUntilFinished: Long) {
                            val dateFormat = SimpleDateFormat("HH:mm:ss")
                            val time = dateFormat.format(Date())
                            eventSink?.success(time)
                        }

                        override fun onFinish() {
                            eventSink?.success(null)
                        }
                    }.start()

                }

                override fun onCancel(args: Any?) {
                    eventSink = null
                    timer?.cancel();

                }
            })


    }


    private fun getStringDeviceInfo(type: String): String? {
        return if (type == "MODEL") {
            Build.MODEL
        } else null
    }

    private fun getJsonDeviceInfo(type: String): JSONObject? {
        val json = JSONObject()
        if (type == "MODEL") {
            try {
                json.put("model", Build.MODEL)
            } catch (e: JSONException) {
                e.printStackTrace()
            }
            return json
        }
        return null
    }

}
