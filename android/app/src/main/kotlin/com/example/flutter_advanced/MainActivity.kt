package com.example.research_methodchannel

import android.R.attr.data
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val TOAST_CHANNEL = "com.example.research_method_channel/toast"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            TOAST_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "showToast" -> {
                    val arguments = call.arguments
                    if (arguments != null) {
                        Toast.makeText(
                            this@MainActivity,
                            arguments as String,
                            Toast.LENGTH_LONG
                        ).show()
                        result.success("Android")
                    } else {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "Arguments must be a non-null String",
                            null
                        )
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

    }
}
