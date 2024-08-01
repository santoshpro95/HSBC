import 'dart:async';
import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hsbc/model/api_error_response.dart';
import 'package:hsbc/services/api_services/avatar_api_service.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_stirngs.dart';
import 'package:hsbc/utils/common_widgets.dart';
import 'package:hsbc/utils/languages/change_language.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

// region voice Command State
enum VoiceCommandState { Welcome, Listening, ShowResult, Loading }
// endregion

// region Languages
class Languages {
  String name;

  Languages(this.name);

  static Languages english = Languages("English");
  static Languages cantonese = Languages("Cantonese");
}
// endregion

class AvatarTTSBloc {
  // region Common Variables
  BuildContext context;
  late VideoPlayerController controller;
  bool isProcessing = true;
  FaceCameraController? faceController;
  List<String> languages = [Languages.cantonese.name, Languages.english.name];

  // endregion

  // region Services
  FlutterTts flutterTts = FlutterTts();
  AvatarApiService avatarApiService = AvatarApiService();

  // endregion

  // region Text Ctrl
  final voiceCommandTextCtrl = TextEditingController();
  final answerTextCtrl = TextEditingController();

  // endregion

  // region Controller
  final videoLoadingCtrl = StreamController<bool>.broadcast();
  final voiceCommandCtrl = StreamController<VoiceCommandState>.broadcast();
  final languageCtrl = ValueNotifier<String>(Languages.cantonese.name);
  final loadingCtrl = StreamController<bool>.broadcast();

  // endregion

  // region | Constructor |
  AvatarTTSBloc(this.context);

  // endregion

  // region Init
  void init() async {
    try {
      await setupAvatarVideo();
      await requestAudioPermission();
      await initialiseCamera();
      await setUpTextToSpeech();
      AvatarAppConstants.platform.setMethodCallHandler(didReceiveFromNative);
      onChangeLanguage(Languages.cantonese.name);
      if (!context.mounted) return;
    } catch (exception) {
      CommonWidgets.errorDialog(context);
      print(exception);
      if(!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region didReceiveFromNative
  Future<dynamic> didReceiveFromNative(MethodCall call) async {
    try {
      if (call.method == AvatarAppConstants.getSpeechToText) {
        if (!isProcessing) return;
        isProcessing = false;
        voiceCommandTextCtrl.text = call.arguments;
        print("calling Api====>");
        callGPT(voiceCommandTextCtrl.text);
      }
      if (call.method == AvatarAppConstants.getMicStatus) {
        if (call.arguments) {
          if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Listening);
        } else {
          if (isProcessing) {
            if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);
          } else {
            if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Welcome);
          }
        }
      }
    } catch (exception) {
      print(exception);
      if(!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region requestAudioPermission
  Future<void> requestAudioPermission() async {
    try {
      var status = await Permission.microphone.status;
      if (status.isGranted) return;
      await Permission.microphone.request();
    } catch (exception) {
      print(exception);
      if(!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region setupAvatarVideo
  Future<void> setupAvatarVideo() async {
    try {
      var welcomeVideo = AvatarAppConstants.cantoneseIntro;
      if (languageCtrl.value == Languages.english.name) welcomeVideo = AvatarAppConstants.englishIntro;
      controller = VideoPlayerController.asset(welcomeVideo);
      await controller.initialize();
      controller.addListener(videoListener);
      if (!videoLoadingCtrl.isClosed) videoLoadingCtrl.sink.add(true);
    } catch (exception) {
      print(exception);
      if(!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region initialiseCamera
  Future<void> initialiseCamera() async {
    try {
      faceController = FaceCameraController(
          performanceMode: FaceDetectorMode.fast,
          defaultCameraLens: CameraLens.front,
          enableAudio: false,
          onCapture: (face) {},
          onFaceDetected: (face) => showAvatar());
      await faceController?.initialize();
    } catch (exception) {
      print(exception);
      if(!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region setUpTextToSpeech
  Future<void> setUpTextToSpeech() async {
    try {
      if (languageCtrl.value == Languages.cantonese.name) {
        await flutterTts.setLanguage("yue-CN");
      } else {
        await flutterTts.setLanguage("en-US");
      }

      await flutterTts.setPitch(1);
      await flutterTts.setVolume(1);
      await flutterTts.setSpeechRate(0.5);

      // Set event listener for when speech finishes
      flutterTts.setCompletionHandler(() async {
        print("Speech finished");
        await controller.pause();
        await controller.seekTo(Duration.zero);
      });
    } catch (exception) {
      if(!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region showAvatar
  Future<void> showAvatar() async {
    try {
      await faceController?.stopImageStream();
      if (Platform.isIOS) return;
      if (!context.mounted) return;
      playVideo();
    } catch (exception) {
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region playVideo
  Future<void> playVideo() async {
    try {
      await controller.setVolume(1);
      await controller.play();
    } catch (exception) {
      if(!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region stopListen
  Future<void> stopListen() async {
    try {
      await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.stopListen);
    } catch (exception) {
      if(!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region startListen
  Future<void> startListen() async {
    try {
      isProcessing = true;
      answerTextCtrl.clear();
      voiceCommandTextCtrl.clear();
      await faceController?.stopImageStream();
      await flutterTts.stop();
      await controller.pause();
      await controller.seekTo(Duration.zero);

      // onTapMicrophone should called after seekTo Zero
      // as it is also listening on video finish it will show result
      if (languageCtrl.value == Languages.cantonese.name) {
        await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.startListen, "yue-HK");
      } else {
        await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.startListen, "en-US");
      }
    } catch (exception) {
      if(!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region onChangeLanguage
  void onChangeLanguage(String language) {
    try {
      languageCtrl.value = language;
      ChangeAvatarLanguage(language);
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
      setUpTextToSpeech();
    } catch (exception) {
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region onPressConfirm
  void onPressConfirm() async {
    try {
      // set status to welcome
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Welcome);

      // clear text
      voiceCommandTextCtrl.clear();
      answerTextCtrl.clear();

      // stop text to speech
      await flutterTts.stop();

      // play intro video
      await setupAvatarVideo();

      // after 2 seconds start scan face
      await faceController?.startImageStream();
    } catch (exception) {
      if(!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region callGPT
  Future<void> callGPT(String content) async {
    try {
      if (content.length < 3) return;
      await faceController?.stopImageStream();
      var exchangeRate = "";
      await flutterTts.stop();
      await controller.pause();
      await controller.seekTo(Duration.zero);

      // get text command
      voiceCommandTextCtrl.text = content;

      // start loading
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Loading);

      // check if exchange rate
      if (content.contains('exchange rate')) {
        var exchangeRateResponse = await avatarApiService.currentRateOfExchange();
        if (exchangeRateResponse.conversionRates != null) {
          exchangeRate = exchangeRateResponse.conversionRates!.toJson().toString();
          content = "$content Here are the current exchange rates for 1 USD $exchangeRate ";
        }
      }

      // call gpt api
      var gptApiResponse = await avatarApiService.gptApi(content);
      if (gptApiResponse.choices == null) return;
      if (gptApiResponse.choices!.first.message == null) return;

      // get response
      var gptResponse = gptApiResponse.choices!.first.message!.content!;
      answerTextCtrl.text = gptResponse.replaceAll("#", "").replaceAll("*", "");
      print(answerTextCtrl.text);
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);

      // using microsoft tool
      await controller.seekTo(Duration.zero);
      await controller.setLooping(true);
      await controller.setVolume(0);
      await flutterTts.speak(answerTextCtrl.text);
      await controller.play();

      // generate video url
      // var avatarVideoResponse = await avatarApiService.generateVideo(answerTextCtrl.text);
      // if (avatarVideoResponse.url != null) playGeneratedAvatarVideo(avatarVideoResponse.url!);
      if (!context.mounted) return;
    } on ApiErrorResponse catch (error) {
      CommonWidgets.infoDialog(context, error.message ?? AvatarAppStrings.errorMessage);
    } catch (exception) {
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region playGeneratedAvatarVideo
  Future<void> playGeneratedAvatarVideo(String url) async {
    try {
      // speak from out put text form gpt
      // use device default by google
      print(url);
      controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      playVideo();
      if (!videoLoadingCtrl.isClosed) videoLoadingCtrl.sink.add(true);
    } catch (exception) {
      if(!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region videoListener
  void videoListener() {
    try {
      var isFinishedVideo = controller.value.position == controller.value.duration;
      if (isFinishedVideo) {
        if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);
      }
    } catch (exception) {
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region Dispose
  Future<void> dispose() async {
    try {
      controller.dispose();
      videoLoadingCtrl.close();
      flutterTts.stop();
      faceController?.dispose();
      await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.sttDispose);
    } catch (exception) {
      if(!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }
// endregion
}
