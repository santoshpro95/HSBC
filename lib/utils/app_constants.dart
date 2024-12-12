import 'dart:async';

import 'package:flutter/services.dart';

class AvatarAppConstants {

  // Indoor Map Config Francois
 // static const situmApiKey = "c3a63634ce37674922e99251ebe9b1327c03287e47c2d21e71707a51b7b558d1";

  // Indoor Map Config (santosh.kumar@neoma.hk)
  static const situmApiKey = "2b9357322c441bb29923647fce20aa8348f668b0ebd06e2b79d2847544543ff3";
  static const domain = "dashboard.situm.com";
  static const buildingId = "17252";
  static const firstFloorId= "56252";

  // point of interest Id
  static const coffeePOI = "643124";
  static const meetingPOI = "643782";

  // native app channel
  static const channelId = "hsbc";
  static const platform = MethodChannel(channelId);

  // animation
  static const listeningAnimation = "assets/json/wave.json";

  // english data
  static const englishIntro = "assets/video/Welcome_EN.mp4";

  // cantonese data
  static const cantoneseIntro = "assets/video/Welcome_CN.mp4";

  // api key
  static const gptApiKey = "sk-proj-4Q64nWsBoYbnH42SG6kNT3BlbkFJhTqGr8GTQ9DJS58l9gPk";

  // api url
  static const openAiBaseurl = "https://api.openai.com/v1";
  static const gptApiUrl = "$openAiBaseurl/chat/completions";
  static const imageGenerate = "$openAiBaseurl/images/generations";
  static const avatarVideoGenerateApiUrl = "https://x4u5ek2lkmtostpmjvastu646i0bxfxx.lambda-url.us-east-1.on.aws";

  // region Invoke
  // invoke from flutter
  static const sttsetup = "sttsetup";
  static const startListen = "startListen";
  static const stopListen = "stopListen";
  static const sttDispose = "sttDispose";

  // test to speech
  static const ttsSetup = "ttsSetup";
  static const ttsDispose = "ttsDispose";
  static const speakText = "speakText";

  // invoke from Native
  static const getSpeechToText = "getSpeechToText";
  static const getMicStatus = "getMicStatus";

  // endregion

  // error Types in api call
  static const noInternet = 6;
}
