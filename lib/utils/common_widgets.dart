import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hsbc/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hsbc/utils/app_stirngs.dart';

import 'app_images.dart';

class CommonWidgets {
  // region fullScreenLoading
  static Widget fullScreenLoading(StreamController<bool> streamController, bool initialData) {
    return StreamBuilder<bool>(
        stream: streamController.stream,
        initialData: initialData,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.data!,
            child: Material(
              color: const Color(0xff90000000),
              child: Center(
                child: loading(color: Colors.white),
              ),
            ),
          );
        });
  }

  // endregion

  // region empty
  static Widget empty({String message = ""}) {
    return Center(
        child: Text(
          message.isEmpty ? AvatarAppStrings.noResult : message,
          style: const TextStyle(color: Colors.grey),
        ));
  }

  // endregion

  // region somethingWentWrong
  static Widget somethingWentWrong(tryAgain) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(AvatarAppStrings.errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.greyColor, fontSize: 16)),
            ),
            CupertinoButton(
                onPressed: tryAgain,
                child: Text(AvatarAppStrings.tryAgain, style: const TextStyle(color: AppColors.primaryColor, fontSize: 16, fontWeight: FontWeight.w500)))
          ],
        ));
  }

  // endregion

  // region loading
  static Widget loading({Color? color}) {
    return Center(
      child: SpinKitSpinningLines(color: color ?? AppColors.primaryColor),
    );
  }

  // endregion

  // region ConfirmationBox
  static void confirmationBox(
    BuildContext context,
    String title,
    String msg,
    submit,
    cancel, {
    String msg2 = "",
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Column(children: [
                SvgPicture.asset(AppImages.infoIcon),
                SizedBox(height: 16),
                Text("$title", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                SizedBox(height: 20.0),
                Text("$msg", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black), textAlign: TextAlign.center),
                Visibility(
                  visible: msg2.isNotEmpty,
                  child: Text("$msg2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: cancel,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.grey, width: 1))),
                            child: Text(AvatarAppStrings.cancel, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                onPressed: submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                ),
                                child: Text(AvatarAppStrings.ok, style: const TextStyle(color: Colors.white))))),
                  ],
                ),
              ]),
            ));
  }

// endregion

  // region fullImageView
  static Widget fullImageView(String imageUrl, BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topRight,
          child: CupertinoButton(onPressed: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.white)),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const CircularProgressIndicator(),
              InteractiveViewer(child: Image.network(imageUrl, width: double.maxFinite, height: double.maxFinite)),
            ],
          ),
        ),
      ],
    );
  }

  // endregion

  // region ErrorDialog
  static void errorDialog(BuildContext context, {String title = "Error"}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Center(
                child: Column(
                  children: [
                    SvgPicture.asset(AppImages.errorIcon),
                    const SizedBox(height: 16),
                    Text(title, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                    const SizedBox(height: 20.0),
                    Text(AvatarAppStrings.errorMessage,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey), textAlign: TextAlign.center),
                    const SizedBox(height: 20.0),
                    SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          child: Text("OK", style: const TextStyle(color: Colors.white)),
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ));
  }

// endregion

  // region infoDialog
  static void infoDialog(BuildContext context, String msg, {okay}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Column(children: [
                SvgPicture.asset(AppImages.infoIcon),
                const SizedBox(height: 16),
                Text(AvatarAppStrings.info, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                const SizedBox(height: 20.0),
                Text(msg, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 20.0),
                SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () => okay != null ? okay() : Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                        child: Text(AvatarAppStrings.ok, style: const TextStyle(color: Colors.white))))
              ]),
            ));
  }

// endregion
}
