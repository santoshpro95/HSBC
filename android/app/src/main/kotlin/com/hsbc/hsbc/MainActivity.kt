package com.hsbc.hsbc

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PersistableBundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    var util = Utils()

    // Speech operation
    var textToSpeech = TextToSpeech()
    var speechToText = SpeechToText()

    // region static data
    companion object {
        var methodChannel: MethodChannel? = null
        var getSpeechToText = ""
        var isMicOn = false

        fun getTextCaptured(text: String) {
            getSpeechToText = text
            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod(Utils().getSpeechToText, getSpeechToText)
            }
        }

        fun getMicStatus(data: Boolean) {
            isMicOn = data
            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod(Utils().getMicStatus, isMicOn)
            }
        }
    }
    // endregion

    // region configureFlutterEngine
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // set method channel
        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Utils().methodChannelName)

        // call listeners
        callListeners()
    }
    // endregion

    // region callListeners
    private fun callListeners() {
        methodChannel?.setMethodCallHandler { call, result ->

            // Text To Speech Feature
            if (call.method == util.ttsSetup) {
                textToSpeech.initialiseSpeech()
                result.success("")
            }
            if (call.method == util.ttsDispose) {
                textToSpeech.dispose()
                result.success("")
            }
            if (call.method == util.speakText) {
                textToSpeech.startStreamPlaybackPressed(call.arguments.toString())
                result.success("")
            }
            // endregion


            // Speech To Text
            if(call.method == util.sttsetup){
                speechToText.setupSpeechToText(call.arguments.toString())
                result.success("")
            }
            if (call.method == util.startListen) {
                speechToText.startReco()
                result.success("")
            }
            if (call.method == util.stopListen) {
                speechToText.stopReco()
                result.success("")
            }
            if (call.method == util.sttDispose) {
                speechToText.dispose()
                result.success("")
            }
            // endregion
        }
    }
    // endregion
}
