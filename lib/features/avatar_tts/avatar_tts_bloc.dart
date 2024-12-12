import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hsbc/features/indoor_nav/indoor_nav_screen.dart';
import 'package:hsbc/model/api_error_response.dart';
import 'package:hsbc/model/gpt_api_response.dart';
import 'package:hsbc/services/api_services/avatar_api_service.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_stirngs.dart';
import 'package:hsbc/utils/common_methods.dart';
import 'package:hsbc/utils/common_widgets.dart';
import 'package:hsbc/utils/knowledgebase/hdfc_canto.dart';
import 'package:hsbc/utils/knowledgebase/hdfc_eng.dart';
import 'package:hsbc/utils/languages/cantonese_lang.dart';
import 'package:hsbc/utils/languages/change_language.dart';
import 'package:hsbc/utils/languages/english_lang.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'write_popup.dart';

// region voice Command State
enum VoiceCommandState { Welcome, Listening, ShowResult, Loading, IndoorMap }
// endregion

// region Languages
class Languages {
  String name;

  Languages(this.name);

  static Languages english = Languages("English");
  static Languages cantonese = Languages("廣東話");
}
// endregion

class AvatarTTSBloc {
  // region Common Variables
  BuildContext context;
  VideoPlayerController? controller;
  bool isProcessing = true;
  FaceCameraController? faceController;
  List<String> languages = [Languages.cantonese.name, Languages.english.name];
  GPTApiResponse gptApiResponse = GPTApiResponse();
  late AnimationController addToCartPopUpAnimationController;
  List<String> textCommandsInEnglish = [];
  List<String> textCommandsInCantonese = [];
  WebViewController webViewController = WebViewController();

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
  void init(state) async {
    try {
      addToCartPopUpAnimationController = AnimationController(vsync: state, duration: const Duration(milliseconds: 800));
      ChangeAvatarLanguage(Languages.cantonese.name);
      addQuestions();
      await setupAvatarVideo();
      await requestAudioPermission();
      await initialiseCamera();
      await setUpTextToSpeech();
      await speechToTextSetup();
      AvatarAppConstants.platform.setMethodCallHandler(didReceiveFromNative);
      if (!context.mounted) return;
    } catch (exception) {
      CommonWidgets.errorDialog(context);
      print(exception);
      if (!context.mounted) return;
      CommonWidgets.infoDialog(context, exception.toString());
    } finally {
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
    }
  }

  // endregion

  // region addQuestions
  void addQuestions() {
    try {
      // add chinese questions
      textCommandsInCantonese.add("畀我睇到會議嘅方向");
      textCommandsInCantonese.add("我可以喺邊度搵到咖啡?");

      textCommandsInCantonese.add("參加滙豐的「股票月供投資計劃」有什麼好處？");
      textCommandsInCantonese.add("我的信用卡遺失或被盜。我可以在哪裡報失，並申請換卡？");
      textCommandsInCantonese.add("要從海外銀行電滙（TT）款項到您的香港滙豐銀行戶口，SWIFT 代碼是什麼？還需要提供什麼資料？");
      textCommandsInCantonese.add("如我身處海外，能否接收由短訊提供之一次性驗證碼以完成電話理財或個人網上理財指示 ?");
      textCommandsInCantonese.add("我可以如何用手機開立戶口？");
      textCommandsInCantonese.add("我怎樣可以透過流動理財應用程式來登記個人網上理財？");
      textCommandsInCantonese.add("最新的納斯達克 (NASDAQ) 是多少？");
      textCommandsInCantonese.add("今天的恆生指數是多少？");
      textCommandsInCantonese.add("最新的道瓊工業指數是多少？");
      textCommandsInCantonese.add("最新上證A&B股水準是多少？");
      textCommandsInCantonese.add("深證A股和B股最近的股價水準是多少？");
      textCommandsInCantonese.add("目前的外匯匯率是多少？");
      textCommandsInCantonese.add("目前的定期存款利率是多少？");
      textCommandsInCantonese.add("今天氣溫幾多度？");

      // add english questions
      textCommandsInEnglish.add("Show me direction to Meeting");
      textCommandsInEnglish.add("Show me way to Coffee");
      textCommandsInEnglish.add("What are the key benefits of the Stocks Monthly Investment Plan?");
      textCommandsInEnglish.add("My credit card is lost or stolen. Where can I report the incident and request a replacement?");
      textCommandsInEnglish.add(
          "What is the SWIFT Code and other information needed to do a Telegraphic Transfer (TT) from an overseas bank to your account with HSBC Hong Kong?");
      textCommandsInEnglish.add(
          "Can I receive the one-time passcode sent by SMS to complete my instruction submitted via Phone Banking or Personal Internet Banking when I am overseas?");
      textCommandsInEnglish.add("How do I open an account online?");
      textCommandsInEnglish.add("How can I register for Personal Internet Banking on HSBC HK App?");
      textCommandsInEnglish.add("What’s the latest NASDAQ?");
      textCommandsInEnglish.add("What’s the HSI today?");
      textCommandsInEnglish.add("What’s the rate for DJIA?");
      textCommandsInEnglish.add("What are the most recent SSE A&B share levels?");
      textCommandsInEnglish.add("What are the most recent SZSE A&B share levels?");
      textCommandsInEnglish.add("What’s the current FX rate?");
      textCommandsInEnglish.add("What’s the current time deposit rate?");
      textCommandsInEnglish.add("How’s the weather today?");
    } catch (exception) {
      print(exception);
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

     // await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.ttsSetup);
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
      // await flutterTts.stop();
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
  void writeCommand() async {
    try {
      await faceController?.stopImageStream();
      await flutterTts.stop();
      await controller!.pause();
      await controller!.seekTo(Duration.zero);

      // open popup
      if (!context.mounted) return;
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return WritePopup(selectedLanguage: languageCtrl.value);
          }).then((value) {
        if (value == null) return;
        if (value.toString().isEmpty) return;
        voiceCommandTextCtrl.text = value;
        callGPT(voiceCommandTextCtrl.text);
      });
    } catch (exception) {
      CommonWidgets.infoDialog(context, exception.toString());
    }
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

      // stop text to speech
      // await flutterTts.stop();

      // play intro video
      await setupAvatarVideo();

      // add delay for 1 seconds
      await Future.delayed(const Duration(seconds: 1));

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
      // await flutterTts.stop();
      await controller!.pause();
      await controller!.seekTo(Duration.zero);

      // get text command
      voiceCommandTextCtrl.text = content;

      // start loading
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.Loading);

      // check if it is related to direction
      if (content == textCommandsInEnglish[0] ||
          content == textCommandsInEnglish[1] ||
          content == textCommandsInCantonese[0] ||
          content == textCommandsInCantonese[1]) {
        answerTextCtrl.text = AvatarAppStrings.directionMsg;
        if (content.contains("Meeting") || content.contains("會議")) {
          await openDirectionScreen(AvatarAppConstants.meetingPOI);
        } else if (content.contains("Coffee") || content.contains('咖啡')) {
          await openDirectionScreen(AvatarAppConstants.coffeePOI);
        }
      } else if (content == textCommandsInEnglish.last || content == textCommandsInCantonese.last) {
        if (languageCtrl.value == Languages.english.name) {
          answerTextCtrl.text = "It’s currently 34°C, clear with periodic clouds in Hong Kong";
        } else {
          answerTextCtrl.text = "香港目前氣溫 34°C，天晴，間中有雲";
        }
        if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);
      } else {
        // get query
        var query = getQuery(content);

        // call open AI api
        gptApiResponse = await avatarApiService.gptApi(query);

        // check api response
        if (gptApiResponse.choices == null) return;
        if (gptApiResponse.choices!.first.message == null) return;

        // get response
        var gptResponse = gptApiResponse.choices!.first.message!.content!;
        answerTextCtrl.text = gptResponse.replaceAll("#", "").replaceAll("*", "");

        // check direction
        if (answerTextCtrl.text.contains(AvatarAppStrings.directionMsg)) {
          if (content.toLowerCase().contains("meeting") || content.contains("會議")) {
            await openDirectionScreen(AvatarAppConstants.meetingPOI);
          } else if (content.toLowerCase().contains("coffee") || content.contains('咖啡')) {
            await openDirectionScreen(AvatarAppConstants.coffeePOI);
          }
        }
        if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);
      }
      // readText
      readText();
      if (!context.mounted) return;
    } on ApiErrorResponse catch (error) {
      if (error.error == null) {
        CommonWidgets.errorDialog(context);
      } else {
        CommonWidgets.infoDialog(context, error.error!.message ?? AvatarAppStrings.errorMessage);
      }
    } catch (exception) {
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }

  // endregion

  // region openDirectionScreen
  Future<void> openDirectionScreen(String navigateId) async {
    try {
      var url =
          "https://map-viewer.situm.com/?apikey=${AvatarAppConstants.situmApiKey}&domain=${AvatarAppConstants.domain}&mode=embed&deviceId=564648026015&wl=true&lng=en&buildingid=${AvatarAppConstants.buildingId}&floorid=${AvatarAppConstants.firstFloorId}&navigation_to=$navigateId&poiid=$navigateId&navigation_from=643123";
      await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
      await webViewController.loadRequest(Uri.parse(url));
      await webViewController.setBackgroundColor(Colors.white);
      await webViewController.setNavigationDelegate(NavigationDelegate(onProgress: (progress) => onProgress(progress)));
    } catch (exception) {
      print(exception);
    }
  }

  // endregion

  // region closeIndoor
  void closeIndoor() {
    try {
      if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.ShowResult);
      setupAvatarVideo();
    } catch (exception) {
      print(exception);
    }
  }

  // endregion

  // region onProgress
  Future<void> onProgress(int progress) async {
    try {
      if (progress == 100) {
        await webViewController.runJavaScript("document.querySelector('.free-trial-banner').style.display = 'none'");
        if (!voiceCommandCtrl.isClosed) voiceCommandCtrl.sink.add(VoiceCommandState.IndoorMap);
      }
    } catch (exception) {
      print(exception);
    }
  }

  // endregion

  // region getQuery
  String getQuery(String content) {
    var query = """
      Anything ask about Coffee or Meeting then say "${AvatarAppStrings.directionMsg}",
      Use the below details about HSBC bank to answer the subsequent question. If the answer cannot be found, write "${languageCtrl.value == Languages.cantonese.name ? CantoneseLang().noAnswer : EnglishLang().noAnswer}"
      Details:
      \"\"\"
      {${languageCtrl.value == Languages.cantonese.name ? HDFCCanto.data : HDFCEng.data}}
      \"\"\"
      
      Question: $content?""";
    return query;
  }

  // endregion

  // region readText
  Future<void> readText() async {
    try {
      if (answerTextCtrl.text.isEmpty) return;
      await controller!.seekTo(Duration.zero);
      await controller!.setLooping(true);
      await controller!.setVolume(0);
      // await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.speakText, answerTextCtrl.text);
      await flutterTts.speak(answerTextCtrl.text);
      await controller!.play();
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
      loadingCtrl.close();
      addToCartPopUpAnimationController.dispose();
      await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.sttDispose);
      await AvatarAppConstants.platform.invokeMethod(AvatarAppConstants.ttsDispose);
    } catch (exception) {
      if (!context.mounted) return;
      print(exception);
      CommonWidgets.infoDialog(context, exception.toString());
    }
  }
// endregion
}
