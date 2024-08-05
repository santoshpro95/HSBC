import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hsbc/features/avatar_tts/avatar_tts_bloc.dart';
import 'package:hsbc/utils/app_colors.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_images.dart';
import 'package:hsbc/utils/app_stirngs.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class AvatarTTSScreen extends StatefulWidget {
  const AvatarTTSScreen({super.key});

  @override
  State<AvatarTTSScreen> createState() => _AvatarTTSScreenState();
}

class _AvatarTTSScreenState extends State<AvatarTTSScreen> {
  // region Bloc
  late AvatarTTSBloc avatarTTSBloc;

  // endregion

  // region Init
  @override
  void initState() {
    avatarTTSBloc = AvatarTTSBloc(context);
    avatarTTSBloc.init();
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.maxFinite,
      child: Column(children: [gptSelection(), avatarView(), commandText(), voiceBtn(), const SizedBox(height: 10)]),
    );
  }

  // endregion

  // region voiceBtn
  Widget voiceBtn() {
    return Expanded(
      child: StreamBuilder<VoiceCommandState>(
          stream: avatarTTSBloc.voiceCommandCtrl.stream,
          initialData: VoiceCommandState.Welcome,
          builder: (context, snapshot) {
            if (snapshot.data! == VoiceCommandState.Welcome) return const SizedBox();
            if (snapshot.data! == VoiceCommandState.Listening) return listening();
            if (snapshot.data! == VoiceCommandState.Loading) return const SpinKitPulse(color: AppColors.primaryColor, size: 150);
            if (snapshot.data! == VoiceCommandState.ShowResult) {
              return Column(mainAxisSize: MainAxisSize.min, children: [answerText(), imageOutput(), finished(), commonQuestions()]);
            }
            return const SizedBox();
          }),
    );
  }

  // endregion

  // region imageOutput
  Widget imageOutput() {
    return ValueListenableBuilder<String>(
        valueListenable: avatarTTSBloc.imageCtrl,
        builder: (context, value, _) {
          if (value.isEmpty) return const SizedBox();
          return Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [const SpinKitCircle(color: AppColors.primaryColor, size: 50), Image.network(value)],
          ));
        });
  }

  // endregion

  // region commandText
  Widget commandText() {
    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
            controller: avatarTTSBloc.voiceCommandTextCtrl,
            readOnly: true,
            minLines: 1,
            maxLines: 3,
            style: const TextStyle(color: AppColors.primaryColor, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            decoration: const InputDecoration.collapsed(hintText: '')),
      ),
    );
  }

  // endregion

  // region answerText
  Widget answerText() {
    return Flexible(
      child: SingleChildScrollView(
        child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextField(
                controller: avatarTTSBloc.answerTextCtrl,
                readOnly: true,
                maxLines: 5,
                minLines: 1,
                style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                decoration: const InputDecoration.collapsed(hintText: '')),
          ),
        ),
      ),
    );
  }

  // endregion

  // region Common Questions
  Widget commonQuestions() {
    return ValueListenableBuilder<String>(
        valueListenable: avatarTTSBloc.gptSelectionCtrl,
        builder: (context, gptOutputType, _) {
          if (gptOutputType == AvatarTTSBloc.typesOfGPT.last) return const SizedBox();
          return ValueListenableBuilder<String>(
              valueListenable: avatarTTSBloc.languageCtrl,
              builder: (context, selectedLanguage, _) {
                var commands = AvatarAppConstants.sampleCommandsInCantonese;
                if (selectedLanguage == Languages.english.name) commands = AvatarAppConstants.sampleCommandsInEnglish;
                return Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    children: [
                      commonQuestionItem(commands[0]),
                      commonQuestionItem(commands[1]),
                      commonQuestionItem(commands[2]),
                    ],
                  ),
                );
              });
        });
  }

  // endregion

  // region CommonQuestionItem
  Widget commonQuestionItem(String question) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey, width: 0.5)),
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          onPressed: () => avatarTTSBloc.callGPT(question),
          child: Text(question, style: const TextStyle(fontSize: 14, color: AppColors.darkGreyColor1, fontWeight: FontWeight.w500)),
        ));
  }

  // endregion

  // region finished
  Widget finished() {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      Text(AvatarAppStrings.tapToSpeak, style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.primaryColor),
          child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => avatarTTSBloc.onPressFinish(),
              child: Text(AvatarAppStrings.finish, style: const TextStyle(color: Colors.white))),
        ),
      ],
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
    return Center(
      child: Flexible(
        fit: FlexFit.loose,
        child: StreamBuilder<VoiceCommandState>(
            stream: avatarTTSBloc.voiceCommandCtrl.stream,
            initialData: VoiceCommandState.Welcome,
            builder: (context, voiceCommandState) {
              // if (voiceCommandState.data! != VoiceCommandState.Welcome) {
              //   return WebViewWidget(controller: avatarTTSBloc.webViewControllerPlus);
              // }
              return StreamBuilder<bool>(
                  stream: avatarTTSBloc.videoLoadingCtrl.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    if (avatarTTSBloc.controller == null) return const SizedBox();
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: voiceCommandState.data! == VoiceCommandState.Welcome ? () => avatarTTSBloc.showAvatar() : null,
                        child: AspectRatio(
                          aspectRatio: avatarTTSBloc.controller!.value.aspectRatio,
                          child: VideoPlayer(avatarTTSBloc.controller!),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
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

  // region gptSelection
  Widget gptSelection() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AvatarAppStrings.outputFormat),
          SizedBox(
            width: 150,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ValueListenableBuilder<String>(
                  valueListenable: avatarTTSBloc.gptSelectionCtrl,
                  builder: (context, snapshot, _) {
                    return Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(30),
                          value: snapshot,
                          elevation: 0,
                          padding: const EdgeInsets.all(0),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: AvatarTTSBloc.typesOfGPT.map((String items) {
                            return DropdownMenuItem(value: items, child: Text(items));
                          }).toList(),
                          onChanged: (String? newValue) => avatarTTSBloc.onChangeOutput(newValue!),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
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
