import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hsbc/model/api_error_response.dart';
import 'package:hsbc/model/gpt_api_response.dart';
import 'package:hsbc/services/api_services/avatar_api_service.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_stirngs.dart';
import 'package:hsbc/utils/common_widgets.dart';
import 'package:hsbc/utils/knowledgebase/hdfc_canto.dart';
import 'package:hsbc/utils/knowledgebase/hdfc_eng.dart';
import 'package:hsbc/utils/languages/change_language.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'write_popup.dart';

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
  VideoPlayerController? controller;
  bool isProcessing = true;
  FaceCameraController? faceController;
  List<String> languages = [Languages.cantonese.name, Languages.english.name];
  static const typesOfGPT = ["Text", "Image"];
  late WebViewControllerPlus webViewControllerPlus;
  GPTApiResponse gptApiResponse = GPTApiResponse();
  late AnimationController addToCartPopUpAnimationController;

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
  final gptSelectionCtrl = ValueNotifier<String>(typesOfGPT.first);
  final loadingCtrl = StreamController<bool>.broadcast();
  final imageCtrl = ValueNotifier("");

  // endregion

  // region | Constructor |
  AvatarTTSBloc(this.context);

  // endregion

  // region Init
  void init(state) async {
    try {
      await setupAvatarVideo();
      await requestAudioPermission();
      await initialiseCamera();
      await setUpTextToSpeech();
      await speechToTextSetup();
      setupWebpage();
      ChangeAvatarLanguage(Languages.cantonese.name);
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
      AvatarAppConstants.platform.setMethodCallHandler(didReceiveFromNative);
      addToCartPopUpAnimationController = AnimationController(vsync: state, duration: const Duration(milliseconds: 800));
      if (!context.mounted) return;
    } catch (exception) {
      CommonWidgets.errorDialog(context);
      print(exception);
      if (!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region speechToTextSetup
  Future<void> speechToTextSetup() async {
    try {
      if (languageCtrl.value == Languages.cantonese.name) {
        await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.sttsetup, "zh-HK");
      } else {
        await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.sttsetup, "en-US");
      }
    } catch (exception) {
      if (!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region openFullImageView
  void openFullImageView(String imageUrl) {
    showDialog(
        barrierColor: Colors.black,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonWidgets.fullImageView(imageUrl, context);
        });
  }

  // endregion

  // region setupWebpage
  void setupWebpage() {
    try {
      webViewControllerPlus = WebViewControllerPlus()
        ..loadFlutterAsset('assets/webpage/index.html')
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              webViewControllerPlus.getWebViewHeight().then((value) {
                var height = int.parse(value.toString()).toDouble();

                _sendDataToJS();
                if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
              });
            },
          ),
        );
    } catch (exception) {
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  void _sendDataToJS() {
    // Pass data to JavaScript using `evaluateJavascript`.
    String encodedData = jsonEncode("Hello wowow");
    webViewControllerPlus.runJavaScript('showData($encodedData);');
  }

  // region didReceiveFromNative
  Future<dynamic> didReceiveFromNative(MethodCall call) async {
    try {
      if (call.method == AvatarAppConstants.getSpeechToText) {
        if (!isProcessing) return;
        isProcessing = false;
        voiceCommandTextCtrl.text = call.arguments;
        callGPT(voiceCommandTextCtrl.text);
      }
      if (call.method == AvatarAppConstants.getMicStatus) {
        var isListening = call.arguments;
        if (isListening) {
          if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Listening);
        }
      }
    } catch (exception) {
      print(exception);
      if (!context.mounted) return;
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
      if (!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region setupAvatarVideo
  Future<void> setupAvatarVideo() async {
    try {
      if (controller != null) controller!.dispose();
      var welcomeVideo = AvatarAppConstants.cantoneseIntro;
      if (languageCtrl.value == Languages.english.name) welcomeVideo = AvatarAppConstants.englishIntro;
      controller = VideoPlayerController.asset(welcomeVideo);
      await controller!.initialize();
      controller!.addListener(videoListener);
      if (!videoLoadingCtrl.isClosed) videoLoadingCtrl.sink.add(true);
    } catch (exception) {
      print(exception);
      if (!context.mounted) return;
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
      if (!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region setUpTextToSpeech
  Future<void> setUpTextToSpeech() async {
    try {
      if (languageCtrl.value == Languages.cantonese.name) {
        await flutterTts.setLanguage("zh-HK");
      } else {
        await flutterTts.setLanguage("en-US");
      }

      await flutterTts.setPitch(1);
      await flutterTts.setVolume(1);
      await flutterTts.setSpeechRate(0.5);

      // Set event listener for when speech finishes
      flutterTts.setCompletionHandler(() async {
        print("Speech finished");
        await controller!.pause();
        await controller!.seekTo(Duration.zero);
      });
    } catch (exception) {
      if (!context.mounted) return;
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
      await controller!.setVolume(1);
      await controller!.play();
    } catch (exception) {
      if (!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region stopListen
  Future<void> stopListen() async {
    try {
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);
      await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.stopListen);
    } catch (exception) {
      if (!context.mounted) return;
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
      await controller!.pause();
      await controller!.seekTo(Duration.zero);

      // onTapMicrophone should called after seekTo Zero
      await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.startListen);
    } catch (exception) {
      if (!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region onChangeLanguage
  Future<void> onChangeLanguage(String language) async {
    try {
      // set language
      imageCtrl.value = "";
      languageCtrl.value = language;
      ChangeAvatarLanguage(language);
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);

      // setup text to speech
      await setUpTextToSpeech();

      // onPressConfirm | start initial stage
      await onPressFinish();

      // stop camera stream and showAvatar
      await showAvatar();
    } catch (exception) {
      if (!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region writeCommand
  void writeCommand() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return const WritePopup();
        }).then((value) {
      if (value == null) return;
      if(value.toString().isEmpty) return;
      voiceCommandTextCtrl.text = value;
      callGPT(voiceCommandTextCtrl.text);
    });
  }

  // endregion

  // region onPressFinish
  Future<void> onPressFinish() async {
    try {
      // hide button
      addToCartPopUpAnimationController.reverse();

      // set status after complete the animation
      Future.delayed(const Duration(milliseconds: 800)).then((val) {
        // set status to welcome
        if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Welcome);
      });

      // clear text
      voiceCommandTextCtrl.clear();
      answerTextCtrl.clear();
      imageCtrl.value = "";

      // stop text to speech
      await flutterTts.stop();

      // play intro video
      await setupAvatarVideo();

      // start scan face
      await faceController?.startImageStream();

      // speechToTextSetup
      await speechToTextSetup();
    } catch (exception) {
      if (!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region callGPT
  Future<void> callGPT(String content) async {
    try {
      if (content.trim().isEmpty) return;
      print("calling Api====>");
      await faceController?.stopImageStream();
      var exchangeRate = "";
      await flutterTts.stop();
      await controller!.pause();
      await controller!.seekTo(Duration.zero);

      // get text command
      voiceCommandTextCtrl.text = content;

      // start loading
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Loading);

      // check gpt type, if it is image type
      if (gptSelectionCtrl.value == typesOfGPT.last) {
        var gptImageResponse = await avatarApiService.gptImageGPTApi(content);
        if (gptImageResponse.data == null) return;
        if (gptImageResponse.data!.isEmpty) return;

        // get answer
        answerTextCtrl.text = gptImageResponse.data!.first.revisedPrompt!;

        // add image
        imageCtrl.value = gptImageResponse.data!.first.url!;
      } else {
        // check if exchange rate
        if (content.contains('exchange rate') || content.contains('匯率')) {
          var exchangeRateResponse = await avatarApiService.currentRateOfExchange();
          if (exchangeRateResponse.conversionRates != null) {
            exchangeRate = exchangeRateResponse.conversionRates!.toJson().toString();
            content = "$content Here are the current exchange rates for 1 USD $exchangeRate ";
            gptApiResponse = await avatarApiService.gptApi(content);
          }
        } else {
          var query = getQuery(content);
          gptApiResponse = await avatarApiService.gptApi(query);
        }

        // check api response
        if (gptApiResponse.choices == null) return;
        if (gptApiResponse.choices!.first.message == null) return;

        // get response
        var gptResponse = gptApiResponse.choices!.first.message!.content!;
        answerTextCtrl.text = gptResponse.replaceAll("#", "").replaceAll("*", "");
      }

      print(answerTextCtrl.text);
      // generate video url
      // var avatarVideoResponse = await avatarApiService.generateVideo(answerTextCtrl.text);
      // if (avatarVideoResponse.url != null) playGeneratedAvatarVideo(avatarVideoResponse.url!);
      if (!context.mounted) return;
    } on ApiErrorResponse catch (error) {
      if (error.error == null) {
        CommonWidgets.errorDialog(context);
      } else {
        CommonWidgets.infoDialog(context, error.error!.message ?? AvatarAppStrings.errorMessage);
      }
    } catch (exception) {
      CommonWidgets.infoDialog(context, exception.toString());
    } finally {
      readText();
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);
    }
  }

  // endregion

  // region getQuery
  String getQuery(String content) {
    var query = """
      Use the below details about HSBC bank to answer the subsequent question. If the answer cannot be found, write "${AvatarAppStrings.noAnswer}"
      Details:
      \"\"\"
      {${HDFCEng.data}}
      \"\"\"
      
      Question: $content?""";

    // change to cantonese language
    if (languageCtrl.value == Languages.cantonese.name) {
      query = """
          使用以下有關匯豐銀行的詳細資料來回答後續問題。如果找不到答案，寫"${AvatarAppStrings.noAnswer}"。
          詳細資料：
           \"\"\"
                    {${HDFCCanto.data}}
              \"\"\"
          
          問題：$content?""";
    }

    return query;
  }

  // endregion

  // region onChangeOutput
  void onChangeOutput(String value) {
    imageCtrl.value = "";
    voiceCommandTextCtrl.clear();
    answerTextCtrl.clear();
    gptSelectionCtrl.value = value;
  }

  // endregion

  // region readText
  Future<void> readText() async {
    try {
      if (answerTextCtrl.text.isEmpty) return;
      // using microsoft tool
      await controller!.seekTo(Duration.zero);
      await controller!.setLooping(true);
      await controller!.setVolume(0);
      await flutterTts.speak(answerTextCtrl.text);
      await controller!.play();
    } catch (exception) {
      if (!context.mounted) return;
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
      await controller!.initialize();
      playVideo();
      if (!videoLoadingCtrl.isClosed) videoLoadingCtrl.sink.add(true);
    } catch (exception) {
      if (!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region videoListener
  void videoListener() {
    try {
      var isFinishedVideo = controller!.value.position == controller!.value.duration;
      if (isFinishedVideo) {
        if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);

        // show animation
        addToCartPopUpAnimationController.forward();
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
      controller!.dispose();
      videoLoadingCtrl.close();
      flutterTts.stop();
      faceController?.dispose();
      imageCtrl.dispose();
      loadingCtrl.close();
      addToCartPopUpAnimationController.dispose();
      await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.sttDispose);
    } catch (exception) {
      if (!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }
// endregion
}
