package com.hsbc.hsbc

import android.util.Log
import com.microsoft.cognitiveservices.speech.SpeechConfig
import com.microsoft.cognitiveservices.speech.SpeechRecognizer
import com.microsoft.cognitiveservices.speech.audio.AudioConfig
import java.util.concurrent.Executors

class SpeechToText {

    private var speechConfig: SpeechConfig? = null
    private var microphoneStream: MicrophoneStream? = null
    private var speechReco: SpeechRecognizer? = null

    companion object {
        private const val activityTag = "SpeechToText"

        private val executorService = Executors.newCachedThreadPool()
    }

    fun setupSpeechToText(lang: String) {
        speechConfig = SpeechConfig.fromSubscription(
            BuildConfig.subscriptionKey,
            BuildConfig.serviceRegion
        )
        speechConfig?.speechRecognitionLanguage = lang
        destroyMicrophoneStream() // in case it was previously initialized
        microphoneStream = MicrophoneStream()
        speechReco = SpeechRecognizer(
            speechConfig,
            AudioConfig.fromStreamInput(MicrophoneStream.create())
        )
    }

    fun startReco() {
        MainActivity.getMicStatus(true)
        speechReco?.recognized?.addEventListener { sender, e ->
            val finalResult = e.result.text
            Log.i(activityTag, finalResult)
            MainActivity.getTextCaptured(finalResult)
            stopReco()
        }
        val task = speechReco?.startContinuousRecognitionAsync()
        executorService.submit {
            task?.get()
            Log.i(activityTag, "Continuous recognition finished. Stopping speechReco")
        }
    }

    fun stopReco() {
        MainActivity.getMicStatus(false)
        speechReco?.stopContinuousRecognitionAsync()
    }

    fun dispose() {
        destroyMicrophoneStream()
        speechReco?.close()
        speechConfig?.close()
        speechConfig = null
    }


    private fun destroyMicrophoneStream() {
        if (microphoneStream != null) {
            microphoneStream?.close()
            microphoneStream = null
        }
    }

}