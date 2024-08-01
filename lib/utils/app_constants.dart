import 'dart:async';

import 'package:flutter/services.dart';

class AvatarAppConstants {
  // native app channel
  static const channelId = "hsbc";
  static const platform = MethodChannel(channelId);

  // animation
  static const listeningAnimation = "assets/json/wave.json";

  // english data
  static const englishIntro = "assets/video/Welcome.mp4";
  static const sampleCommandsInEnglish = ["What's the exchange rate for HKD?", "Credit card promotion", "Tell me about about saving plan"];

  // cantonese data
  static const cantoneseIntro = "assets/video/welcomeCantonese.mp4";
  static const sampleCommandsInCantonese = ["今日匯率", "信用卡優惠", "儲蓄戶口相關問題"];

  // api key
  static const gptApiKey = "sk-proj-4Q64nWsBoYbnH42SG6kNT3BlbkFJhTqGr8GTQ9DJS58l9gPk";
  static const currentRateOfCurrencyApiKey = "eed12f1a8071e4b0319152a3";

  // api url
  static const gptApiUrl = "https://api.openai.com/v1/chat/completions";
  static const avatarVideoGenerateApiUrl = "https://x4u5ek2lkmtostpmjvastu646i0bxfxx.lambda-url.us-east-1.on.aws";
  static const currentExchangeRateApi = "https://v6.exchangerate-api.com/v6/$currentRateOfCurrencyApiKey/latest/USD";

  // region Invoke Native Methods
  static const ttsSetup = "ttsSetup";
  static const speakText = "speakText";
  static const startListen = "startListen";
  static const stopListen = "stopListen";
  static const ttsDispose = "ttsDispose";
  static const sttDispose = "sttDispose";
  static const getSpeechToText = "getSpeechToText";
  static const getMicStatus = "getMicStatus";

  // endregion


  // error Types in api call
  static const noInternet = 6;

  // sample data
  var demo =
      "https://stttssvcprodusw2.blob.core.windows.net/batchsynthesis-output/345dc00fd860474da51bc2dc7b7945e0/fcd91790-b139-47ee-b433-0c75eadd8ae6/0001.mp4?skoid=fdd04a02-98a3-46a7-830a-91140970cca0&sktid=33e01921-4d64-4f8c-a055-5bdaffd5e33d&skt=2024-07-21T17%3A13%3A24Z&ske=2024-07-27T17%3A18%3A24Z&sks=b&skv=2023-11-03&sv=2023-11-03&st=2024-07-22T06%3A33%3A46Z&se=2024-07-25T06%3A38%3A46Z&sr=b&sp=rl&sig=nxcBomsc2mDDGEtWseR%2BGEFijCdVmBhPkK6RfIiCiCs%3D";
}
