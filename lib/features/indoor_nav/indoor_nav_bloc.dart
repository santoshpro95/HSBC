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
  final progressLoadingCtrl = StreamController<int>.broadcast();

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

    if (!webLoadingCtrl.isClosed) webLoadingCtrl.sink.add(true);
  }

  // endregion

  // region onProgress
  void onProgress(int progress) {
    if (!progressLoadingCtrl.isClosed) progressLoadingCtrl.sink.add(progress);
  }

  // endregion

  // region onPageFinished
  void onPageFinished(String page) {
    print("on finished url == $page");

 //    // class = free-trial-banner
 //    webViewController.runJavaScript("""
 // var divsToHide = document.getElementsByClassName("free-trial-banner"); //divsToHide is an array
 //    for(var i = 0; i < divsToHide.length; i++){
 //        divsToHide[i].style.visibility = "hidden"; // or
 //        divsToHide[i].style.display = "none"; // depending on what you're doing
 //    }
 //        """);

    webViewController.runJavaScriptReturningResult("""
        for (let element of document.getElementsByClassName("classname")){
   element.style.display="none";
}
        """);


  }

  // endregion

  // region Dispose
  void dispose() {}
// endregion
}
