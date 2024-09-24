import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:situm_flutter/sdk.dart';
import 'package:situm_flutter/wayfinding.dart';

class IndoorNavBloc {
  // region Common Variables
  BuildContext context;
  MapViewController? mapViewController;
  Function? mapViewLoadAction;
  String content;
  // endregion

  // region Controller
  final loadingCtrl = StreamController<bool>.broadcast();

  // endregion

  // region | Constructor |
  IndoorNavBloc(this.context, this.mapViewLoadAction, this.content);

  // endregion

  // region Init
  void init() {}

  // endregion

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

    mapViewLoadAction?.call();
    mapViewLoadAction = null;

    //Example on how to automatically center the map on the user location when
    // it become available
    // coffee - 643124
    // meeting - 643782

    if(content.contains("Coffee")){
      controller.selectPoi("643124");
    }else if (content.contains("Meeting")){
      controller.selectPoi("643782");
    }

    controller.onPoiSelected((poiSelectedResult) {
      printWarning("WYF> Poi SELECTED: ${poiSelectedResult.poi.identifier}");
    });
    controller.onPoiDeselected((poiDeselectedResult) {
      printWarning("WYF> Poi DESELECTED: ${poiDeselectedResult.poi.name}");
    });
    controller.onNavigationRequestInterceptor((navigationRequest) {
      printWarning("WYF> Navigation interceptor: ${navigationRequest.toMap()}");
      //   navigationRequest.distanceToGoalThreshold = 10.0;
      //   ...
    });
  }

  void printWarning(String text) {
    debugPrint('\x1B[33m$text\x1B[0m');
  }

  void printError(String text) {
    debugPrint('\x1B[31m$text\x1B[0m');
  }

  // region Dispose
  void dispose() {}
// endregion
}
