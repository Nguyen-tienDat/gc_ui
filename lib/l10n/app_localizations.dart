import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'GlobeCast'**
  String get appName;

  /// No description provided for @joinMeeting.
  ///
  /// In en, this message translates to:
  /// **'Join Meeting'**
  String get joinMeeting;

  /// No description provided for @createMeeting.
  ///
  /// In en, this message translates to:
  /// **'Create Meeting'**
  String get createMeeting;

  /// No description provided for @scheduleMeeting.
  ///
  /// In en, this message translates to:
  /// **'Schedule Meeting'**
  String get scheduleMeeting;

  /// No description provided for @myMeetings.
  ///
  /// In en, this message translates to:
  /// **'My Meetings'**
  String get myMeetings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @enterMeetingCode.
  ///
  /// In en, this message translates to:
  /// **'Enter meeting code'**
  String get enterMeetingCode;

  /// No description provided for @meetingCode.
  ///
  /// In en, this message translates to:
  /// **'Meeting Code'**
  String get meetingCode;

  /// No description provided for @joinNow.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get joinNow;

  /// No description provided for @meetingTopic.
  ///
  /// In en, this message translates to:
  /// **'Meeting Topic'**
  String get meetingTopic;

  /// No description provided for @meetingDuration.
  ///
  /// In en, this message translates to:
  /// **'Meeting Duration'**
  String get meetingDuration;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cameraOn.
  ///
  /// In en, this message translates to:
  /// **'Camera On'**
  String get cameraOn;

  /// No description provided for @cameraOff.
  ///
  /// In en, this message translates to:
  /// **'Camera Off'**
  String get cameraOff;

  /// No description provided for @shareScreen.
  ///
  /// In en, this message translates to:
  /// **'Share Screen'**
  String get shareScreen;

  /// No description provided for @stopSharing.
  ///
  /// In en, this message translates to:
  /// **'Stop Sharing'**
  String get stopSharing;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @raiseHand.
  ///
  /// In en, this message translates to:
  /// **'Raise Hand'**
  String get raiseHand;

  /// No description provided for @lowerHand.
  ///
  /// In en, this message translates to:
  /// **'Lower Hand'**
  String get lowerHand;

  /// No description provided for @endMeeting.
  ///
  /// In en, this message translates to:
  /// **'End Meeting'**
  String get endMeeting;

  /// No description provided for @leaveMeeting.
  ///
  /// In en, this message translates to:
  /// **'Leave Meeting'**
  String get leaveMeeting;

  /// No description provided for @subtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitles;

  /// No description provided for @showSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Show Subtitles'**
  String get showSubtitles;

  /// No description provided for @hideSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Hide Subtitles'**
  String get hideSubtitles;

  /// No description provided for @speakingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Speaking Language'**
  String get speakingLanguage;

  /// No description provided for @translationLanguages.
  ///
  /// In en, this message translates to:
  /// **'Translation Languages'**
  String get translationLanguages;

  /// No description provided for @addLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add Language'**
  String get addLanguage;

  /// No description provided for @recordMeeting.
  ///
  /// In en, this message translates to:
  /// **'Record Meeting'**
  String get recordMeeting;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopRecording;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @meetingIsBeingRecorded.
  ///
  /// In en, this message translates to:
  /// **'This meeting is being recorded'**
  String get meetingIsBeingRecorded;

  /// No description provided for @inviteParticipants.
  ///
  /// In en, this message translates to:
  /// **'Invite Participants'**
  String get inviteParticipants;

  /// No description provided for @waitingRoom.
  ///
  /// In en, this message translates to:
  /// **'Waiting Room'**
  String get waitingRoom;

  /// No description provided for @admitAll.
  ///
  /// In en, this message translates to:
  /// **'Admit All'**
  String get admitAll;

  /// No description provided for @admitSelected.
  ///
  /// In en, this message translates to:
  /// **'Admit Selected'**
  String get admitSelected;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeMember;

  /// No description provided for @makeModerator.
  ///
  /// In en, this message translates to:
  /// **'Make Moderator'**
  String get makeModerator;

  /// No description provided for @allowToUnmute.
  ///
  /// In en, this message translates to:
  /// **'Allow to Unmute'**
  String get allowToUnmute;

  /// No description provided for @welcomeToGlobeCast.
  ///
  /// In en, this message translates to:
  /// **'Welcome to GlobeCast'**
  String get welcomeToGlobeCast;

  /// No description provided for @audioAndVideo.
  ///
  /// In en, this message translates to:
  /// **'Audio and Video'**
  String get audioAndVideo;

  /// No description provided for @testSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Test Speaker'**
  String get testSpeaker;

  /// No description provided for @testMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Test Microphone'**
  String get testMicrophone;

  /// No description provided for @joinWithoutAudio.
  ///
  /// In en, this message translates to:
  /// **'Join without Audio'**
  String get joinWithoutAudio;

  /// No description provided for @joinWithoutVideo.
  ///
  /// In en, this message translates to:
  /// **'Join without Video'**
  String get joinWithoutVideo;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @inMeeting.
  ///
  /// In en, this message translates to:
  /// **'In Meeting'**
  String get inMeeting;

  /// No description provided for @meetingTime.
  ///
  /// In en, this message translates to:
  /// **'Meeting Time'**
  String get meetingTime;

  /// No description provided for @connectingToMeeting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to meeting...'**
  String get connectingToMeeting;

  /// No description provided for @yourMeetingCode.
  ///
  /// In en, this message translates to:
  /// **'Your meeting code'**
  String get yourMeetingCode;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard!'**
  String get linkCopied;

  /// No description provided for @meetingEnded.
  ///
  /// In en, this message translates to:
  /// **'Meeting has ended'**
  String get meetingEnded;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using GlobeCast'**
  String get thankYou;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// No description provided for @noMeetingsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No meetings scheduled'**
  String get noMeetingsScheduled;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
