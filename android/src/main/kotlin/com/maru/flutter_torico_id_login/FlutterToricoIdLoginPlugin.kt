package com.maru.flutter_torico_id_login

import android.content.Intent
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import java.sql.DriverManager.println

const val METHOD_NAME: string = "torico/flutter_torico_id_login"

/** FlutterToricoIdLoginPlugin */
class FlutterToricoIdLoginPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, NewIntentListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var methodChannel : MethodChannel? = null
  private var eventChannel: EventChannel? = null
  private var eventSink: EventSink? = null
  private var activityPluginBinding: ActivityPluginBinding? = null
  private var scheme: string? = ""

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), METHOD_NAME)
      FlutterToricoIdLoginPlugin().onAttachedToEngine(registrar.messenger())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "setScheme") {
      scheme = call.arguments as String
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  fun onAttachedToEngine(messanger: BinaryMessenger) {
    methodChannel = MethodChannel(messanger, METHOD_NAME)
    methodChannel!!.setMethodCallHandler(this)

    eventChannel = EventChannel(messenger, "${METHOD_NAME}/event")
    eventChannel!!.setStreamHandler(object: StreamHandler {
      override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events!!
      }

      override fun onCancel(arguments: Any?) {
        eventSink = null
      }
    })
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(flutterPluginBinding.binaryMessenger)
  }

  override fun onNewIntent(intent: Intent?): Boolean {
    if (scheme == intent!!.data?.scheme) {
      eventSink?.success(mapOf("type" to "url", "url" to intent.data?.toString()))
    }

    return true
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel!!.setMethodCallHandler(null)
    methodChannel = null

    eventChannel!!.setStreamHandler(null)
    methodChannel = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivity() {
    activityPluginBinding?.removeOnNewIntentListener(this)
    activityPluginBinding = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityPluginBinding?.removeOnNewIntentListener(this)
    activityPluginBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    binding.addOnNewIntentListener(this)
  }
}
