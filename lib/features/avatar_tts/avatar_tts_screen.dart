import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hsbc/features/avatar_tts/avatar_tts_bloc.dart';
import 'package:hsbc/utils/app_colors.dart';
import 'package:hsbc/utils/app_config.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_images.dart';
import 'package:hsbc/utils/app_stirngs.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AvatarTTSScreen extends StatefulWidget {
  const AvatarTTSScreen({super.key});

  @override
  State<AvatarTTSScreen> createState() => _AvatarTTSScreenState();
}

class _AvatarTTSScreenState extends State<AvatarTTSScreen> with TickerProviderStateMixin {
  // region Bloc
  late AvatarTTSBloc avatarTTSBloc;

  // endregion

  // region Init
  @override
  void initState() {
    avatarTTSBloc = AvatarTTSBloc(context);
    avatarTTSBloc.init(this);
    super.initState();
  }

  // endregion

  // region Build
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: avatarTTSBloc.loadingCtrl.stream,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 10,
                title: Row(
                  children: [Text("HSBC ${AvatarAppStrings.assistant}"), languageSelection()],
                ),
                centerTitle: true,
                automaticallyImplyLeading: false),
            body: body(),
          );
        });
  }

  // endregion

  // region body
  Widget body() {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [avatarView(), voiceBtn(), const SizedBox(height: 30)]));
  }

  // endregion

  // region voiceBtn
  Widget voiceBtn() {
    return Expanded(
      child: StreamBuilder<VoiceCommandState>(
          stream: avatarTTSBloc.voiceCommandCtrl.stream,
          initialData: VoiceCommandState.Welcome,
          builder: (context, snapshot) {
            if (snapshot.data! == VoiceCommandState.IndoorMap) return indoorMap();
            if (snapshot.data! == VoiceCommandState.Welcome) return const SizedBox();
            if (snapshot.data! == VoiceCommandState.Listening) return listening();
            if (snapshot.data! == VoiceCommandState.Loading) return const SpinKitPulse(color: AppColors.primaryColor, size: 150);
            if (snapshot.data! == VoiceCommandState.ShowResult) {
              return ListView(padding: EdgeInsets.zero, children: [commandText(), answerText(), finished(), commonQuestions()]);
            }
            return const SizedBox();
          }),
    );
  }

  // endregion

  // region indoorMap
  Widget indoorMap() {
    return Stack(
      children: [
        WebViewWidget(controller: avatarTTSBloc.webViewController),
        Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(top: 13, right: 10),
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.purpleColor),
                      child: const Icon(Icons.close, size: 18, color: Colors.white)),
                  onPressed: () => avatarTTSBloc.closeIndoor()),
            ))
      ],
    );
  }

  // endregion

  // region commandText
  Widget commandText() {
    if (avatarTTSBloc.voiceCommandTextCtrl.text.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
          controller: avatarTTSBloc.voiceCommandTextCtrl,
          readOnly: true,
          minLines: 1,
          maxLines: 3,
          style: const TextStyle(color: AppColors.primaryColor, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
          decoration: const InputDecoration.collapsed(hintText: '')),
    );
  }

  // endregion

  // region answerText
  Widget answerText() {
    if (avatarTTSBloc.answerTextCtrl.text.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
          controller: avatarTTSBloc.answerTextCtrl,
          readOnly: true,
          maxLines: null,
          minLines: 1,
          style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          decoration: const InputDecoration.collapsed(hintText: '')),
    );
  }

  // endregion

  // region Common Questions
  Widget commonQuestions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 1.5), end: Offset.zero).animate(avatarTTSBloc.addToCartPopUpAnimationController),
        child: ValueListenableBuilder<String>(
            valueListenable: avatarTTSBloc.languageCtrl,
            builder: (context, selectedLanguage, _) {
              // cantonese questions
              var commands = avatarTTSBloc.textCommandsInCantonese;

              // questions in english
              if (selectedLanguage == Languages.english.name) commands = avatarTTSBloc.textCommandsInEnglish;

              if (commands.isEmpty) return const SizedBox();
              return SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  children: <Widget>[for (var item in commands) commonQuestionItem(item)],
                ),
              );
            }),
      ),
    );
  }

  // endregion

  // region CommonQuestionItem
  Widget commonQuestionItem(String question) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey, width: 0.5)),
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          onPressed: () => avatarTTSBloc.callGPT(question),
          child: Text(question,
              style: TextStyle(fontSize: AppConfig.suggestionQuestionFont, color: AppColors.darkGreyColor1, fontWeight: FontWeight.w500)),
        ));
  }

  // endregion

  // region finished
  Widget finished() {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(bottom: 10),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            SlideTransition(
              position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(avatarTTSBloc.addToCartPopUpAnimationController),
              child: ValueListenableBuilder<String>(
                  valueListenable: avatarTTSBloc.languageCtrl,
                  builder: (context, value, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(width: 1, color: AppColors.primaryColor)),
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => avatarTTSBloc.writeCommand(),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(AppImages.write,
                                    height: 20, width: 20, colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
                                const SizedBox(width: 10),
                                Text(AvatarAppStrings.tapToWrite,
                                    style: TextStyle(color: AppColors.primaryColor, fontSize: AppConfig.buttonFont, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )),
                    );
                  }),
            ),
            SlideTransition(
              position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(avatarTTSBloc.addToCartPopUpAnimationController),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(width: 1, color: AppColors.primaryColor)),
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => avatarTTSBloc.startListen(),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(AppImages.micOn,
                              height: 20, width: 20, colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
                          const SizedBox(width: 10),
                          Text(AvatarAppStrings.tapToSpeak,
                              style: TextStyle(color: AppColors.primaryColor, fontSize: AppConfig.buttonFont, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(begin: const Offset(-1, -1), end: Offset.zero).animate(avatarTTSBloc.addToCartPopUpAnimationController),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.primaryColor),
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => avatarTTSBloc.onPressFinish(),
                    child: Text(AvatarAppStrings.finish, style: TextStyle(color: Colors.white, fontSize: AppConfig.buttonFont))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // endregion

  // region listening
  Widget listening() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => avatarTTSBloc.stopListen(),
      child: Container(
        width: 150,
        height: 150,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(500), color: AppColors.primaryColor),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50, width: 50, child: Lottie.asset(AvatarAppConstants.listeningAnimation)),
              const SizedBox(width: 10),
              Text(AvatarAppStrings.listening, style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  // endregion

  // region avatarView
  Widget avatarView() {
    return StreamBuilder<VoiceCommandState>(
        stream: avatarTTSBloc.voiceCommandCtrl.stream,
        initialData: VoiceCommandState.Welcome,
        builder: (context, voiceCommandState) {
          if (voiceCommandState.data! == VoiceCommandState.IndoorMap) return const SizedBox();
          return Container(
            alignment: Alignment.center,
            height: AppConfig.avatarSize(context),
            margin: const EdgeInsets.only(bottom: 10),
            child: StreamBuilder<bool>(
                stream: avatarTTSBloc.videoLoadingCtrl.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  if (avatarTTSBloc.controller == null) return const SizedBox();
                  return InkWell(
                    onTap: voiceCommandState.data! == VoiceCommandState.Welcome ? () => avatarTTSBloc.showAvatar() : null,
                    child: AspectRatio(
                      aspectRatio: avatarTTSBloc.controller!.value.aspectRatio,
                      child: VideoPlayer(avatarTTSBloc.controller!),
                    ),
                  );
                }),
          );
        });
  }

  // endregion

  // region languageSelection
  Widget languageSelection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder<String>(
            valueListenable: avatarTTSBloc.languageCtrl,
            builder: (context, snapshot, _) {
              return Theme(
                data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(30),
                    value: snapshot,
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: avatarTTSBloc.languages.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (String? newValue) => avatarTTSBloc.onChangeLanguage(newValue!),
                  ),
                ),
              );
            }),
      ),
    );
  }

  // endregion

  // region Dispose
  @override
  void dispose() {
    avatarTTSBloc.dispose();
    super.dispose();
  }
// endregion
}
