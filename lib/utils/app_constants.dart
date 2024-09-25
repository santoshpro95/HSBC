import 'dart:async';

import 'package:flutter/services.dart';

class AvatarAppConstants {

  // Indoor Map Config
  static const situmApiKey = "2b9357322c441bb29923647fce20aa8348f668b0ebd06e2b79d2847544543ff3";
  static const domain = "dashboard.situm.com";
  static const buildingId = "17252";
  static const firstFloorId= "56252";

  // point of interest Id
  static const coffeePOI = "643124";
  static const meetingPOI = "643782";

// Alternatively, you can set an identifier that allows you to remotely configure all map settings.
// For now, you need to contact Situm to obtain yours.
  static const remoteIdentifier = null;

  /// A String parameter that allows you to specify which domain will be displayed inside our webview.
  /// Take a look at [MapViewConfiguration.viewerDomain].
  static const viewerDomain = "https://map-viewer.situm.com";

  // Set here the API which you will use to retrieve the cartography from.
  // Take a look at [MapViewConfiguration.apiDomain] and [SitumSdk.setDashboardURL] to learn how to implement it.
  //const apiDomain = "https://dashboard.situm.com";

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

  // invoke from Native
  static const getSpeechToText = "getSpeechToText";
  static const getMicStatus = "getMicStatus";

  // endregion

  // error Types in api call
  static const noInternet = 6;

  // sample data
  var demo =
      "https://stttssvcprodusw2.blob.core.windows.net/batchsynthesis-output/345dc00fd860474da51bc2dc7b7945e0/fcd91790-b139-47ee-b433-0c75eadd8ae6/0001.mp4?skoid=fdd04a02-98a3-46a7-830a-91140970cca0&sktid=33e01921-4d64-4f8c-a055-5bdaffd5e33d&skt=2024-07-21T17%3A13%3A24Z&ske=2024-07-27T17%3A18%3A24Z&sks=b&skv=2023-11-03&sv=2023-11-03&st=2024-07-22T06%3A33%3A46Z&se=2024-07-25T06%3A38%3A46Z&sr=b&sp=rl&sig=nxcBomsc2mDDGEtWseR%2BGEFijCdVmBhPkK6RfIiCiCs%3D";
}
