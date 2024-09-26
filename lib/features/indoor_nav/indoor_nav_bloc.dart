import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IndoorNavBloc {
  // region Common Variables
  BuildContext context;
  String navigateToId;
  String floorId;
  WebViewController webViewController = WebViewController();

  // endregion

  // region Controller
  final webLoadingCtrl = StreamController<bool>.broadcast();

  // endregion

  // region | Constructor |
  IndoorNavBloc(this.context, this.navigateToId, this.floorId);

  // endregion

  // region Init
  void init() async {
    var url =
        "https://map-viewer.situm.com/?apikey=${AvatarAppConstants.situmApiKey}&domain=${AvatarAppConstants.domain}&mode=embed&deviceId=564648026015&wl=true&lng=en&buildingid=${AvatarAppConstants.buildingId}&floorid=$floorId&navigation_to=$navigateToId&poiid=$navigateToId&navigation_from=643123";

    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await webViewController.loadRequest(Uri.parse(url));
    webViewController
        .setNavigationDelegate(NavigationDelegate(onProgress: (progress) => onProgress(progress), onPageFinished: (page) => onPageFinished(page)));

  }

  // endregion

  // region run JS
  void runJS() async {
    await webViewController.runJavaScript("document.querySelector('.free-trial-banner').style.display = 'none'");
  }

  // endregion

  // region onProgress
  void onProgress(int progress) {
    print("progress == $progress");
    if (progress == 100) runJS();
  }

  // endregion

  // region onPageFinished
  void onPageFinished(String page) {
    print("on finished url == $page");
    if (!webLoadingCtrl.isClosed) webLoadingCtrl.sink.add(false);
  }

  // endregion

  // region Dispose
  void dispose() {}
// endregion
}
