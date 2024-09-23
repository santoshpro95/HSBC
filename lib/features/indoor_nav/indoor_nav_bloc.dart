import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:situm_flutter/sdk.dart';
import 'package:situm_flutter/wayfinding.dart';

class IndoorNavBloc {
  // region Common Variables
  BuildContext context;

  // endregion

  // region Common Variables
  late SitumSdk situmSdk;
  List<Poi> pois = [];
  List<Floor> floors = [];
  Poi? poiDropdownValue;
  Floor? floorDropdownValue;
  bool fitCameraToFloor = false;
  Function? mapViewLoadAction;
  MapViewController? mapViewController;

  // endregion

  // region Controller
  final loadingCtrl = StreamController<bool>.broadcast();

  // endregion

  // region | Constructor |
  IndoorNavBloc(this.context);

  // endregion

  // region Init
  void init() {
    initialiseIndoorMap();
  }

  // endregion

  // region initialiseIndoorMap
  void initialiseIndoorMap() async {
    situmSdk = SitumSdk();
    // In case you wan't to use our SDK before initializing our MapView widget,
    // you can set up your credentials with this line of code :
    await situmSdk.init();
    // Authenticate with your account and API key.
    // You can find yours at https://dashboard.situm.com/accounts/profile
    await situmSdk.setApiKey(AvatarAppConstants.situmApiKey);
    // Configure SDK before authenticating.
    await situmSdk.setConfiguration(ConfigurationOptions(
        // In case you want to use our remote configuration (https://dashboard.situm.com/settings).
        // With this practical dashboard you can edit your location request and other SDK configurations
        // with ease and no code changes.
        useRemoteConfig: true));
    // Set up location listeners:
    situmSdk.onLocationUpdate((location) {
      print("""SDK> Location changed:
        Time diff: ${location.timestamp - DateTime.now().millisecondsSinceEpoch}
        B=${location.buildingIdentifier},
        F=${location.floorIdentifier},
        C=${location.coordinate.latitude.toStringAsFixed(5)}, ${location.coordinate.longitude.toStringAsFixed(5)}
      """);
    });
    situmSdk.onLocationStatus((status) {
      print("Situm> SDK> STATUS: $status");
    });
    situmSdk.onLocationError((Error error) {
      print("Situm> SDK> Error ${error.code}:\n${error.message}");
    });
    // Set up listener for events on geofences
    situmSdk.onEnterGeofences((geofencesResult) {
      print("Situm> SDK> Enter geofences: ${geofencesResult.geofences}.");
    });
    situmSdk.onExitGeofences((geofencesResult) {
      print("Situm> SDK> Exit geofences: ${geofencesResult.geofences}.");
    });

    _downloadPois(AvatarAppConstants.buildingIdentifier);
    _downloadFloors(AvatarAppConstants.buildingIdentifier);
  }

  // endregion

  void printWarning(String text) {
    debugPrint('\x1B[33m$text\x1B[0m');
  }

  void printError(String text) {
    debugPrint('\x1B[31m$text\x1B[0m');
  }

  void _callMapviewLoadAction() {
    mapViewLoadAction?.call();
    mapViewLoadAction = null;
  }

  void _downloadPois(String buildingIdentifier) async {
    var poiList = await situmSdk.fetchPoisFromBuilding(buildingIdentifier);
    pois = poiList;
    poiDropdownValue = pois[0];
    // refresh UI
    if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
  }

  void _downloadFloors(String buildingIdentifier) async {
    var info = await situmSdk.fetchBuildingInfo(buildingIdentifier);
    floors = info.floors;
    floorDropdownValue = floors[0];

    /// refresh UI
    if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
  }

  void onLoad(MapViewController controller) {
    // Use MapViewController to communicate with the map: methods and callbacks
    // are available to perform actions and listen to events (e.g., listen to
    // POI selections, intercept navigation options, navigate to POIs, etc.).
    // You need to wait until the map is properly loaded to do so.
    mapViewController = controller;

    //Example on how to automatically launch positioning when opening the map.
    // situmSdk.requestLocationUpdates(LocationRequest(
    //   buildingIdentifier: buildingIdentifier, //"-1"
    //   useDeadReckoning: false,
    // ));

    _callMapviewLoadAction();

    //Example on how to automatically center the map on the user location when
    // it become available
    //controller.followUser();

    controller.onPoiSelected((poiSelectedResult) {
      printWarning("WYF> Poi SELECTED: ${poiSelectedResult.poi.name}");
    });
    controller.onPoiDeselected((poiDeselectedResult) {
      printWarning("WYF> Poi DESELECTED: ${poiDeselectedResult.poi.name}");
    });
    controller.onNavigationRequestInterceptor((navigationRequest) {
      printWarning("WYF> Navigation interceptor: ${navigationRequest.toMap()}");
      //   navigationRequest.distanceToGoalThreshold = 10.0;
      //   ...
    });

    // Flutter-Android webview lacks proper support for TTS technology so we
    // // fallback to third-party libraries
    // controller.onSpeakAloudText((speakaloudTextResult) async {
    //   print("Situm > SDK > Speak aloud: ${speakaloudTextResult.text}");
    //   if (speakaloudTextResult.lang != null) {
    //     flutterTts.setLanguage(speakaloudTextResult.lang!);
    //   }
    //   if (speakaloudTextResult.rate != null) {
    //     flutterTts.setSpeechRate(speakaloudTextResult.rate!);
    //   }
    //   if (speakaloudTextResult.volume != null) {
    //     flutterTts.setVolume(speakaloudTextResult.volume!);
    //   }
    //   if (speakaloudTextResult.pitch != null) {
    //     flutterTts.setPitch(speakaloudTextResult.pitch!);
    //   }
    //
    //   await flutterTts.speak(speakaloudTextResult.text);
    // });
  }

  // region Dispose
  void dispose() {}
// endregion
}
