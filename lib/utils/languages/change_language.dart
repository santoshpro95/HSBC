import 'package:hsbc/features/avatar_tts/avatar_tts_bloc.dart';
import 'package:hsbc/utils/app_stirngs.dart';

import 'cantonese_lang.dart';
import 'english_lang.dart';

class ChangeAvatarLanguage {
  ChangeAvatarLanguage(String languageCode) {
    dynamic language;
    if (languageCode == Languages.cantonese.name) {
      language = CantoneseLang();
    } else {
      language = EnglishLang();
    }
    if (language == null) return;

    AvatarAppStrings.tapToSpeak = language.tapToSpeak;
    AvatarAppStrings.finish = language.finish;
    AvatarAppStrings.listening = language.listening;
    AvatarAppStrings.assistant = language.assistant;
    AvatarAppStrings.answerOfQuestion = language.answerOfQuestion;
  }
}
