import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// The app title
  ///
  /// In en, this message translates to:
  /// **'Juny'**
  String get appTitle;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// Google login button
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get loginWithGoogle;

  /// GitHub login button
  ///
  /// In en, this message translates to:
  /// **'Sign in with GitHub'**
  String get loginWithGithub;

  /// Welcome message for host (senior)
  ///
  /// In en, this message translates to:
  /// **'Hello! How are you today?'**
  String get welcomeHost;

  /// Welcome message for concierge (caregiver)
  ///
  /// In en, this message translates to:
  /// **'Caregiver Dashboard'**
  String get welcomeConcierge;

  /// Start live session button
  ///
  /// In en, this message translates to:
  /// **'Start Live'**
  String get startLive;

  /// End live session button
  ///
  /// In en, this message translates to:
  /// **'End Live'**
  String get endLive;

  /// Watch live session button
  ///
  /// In en, this message translates to:
  /// **'Watch Live'**
  String get watchLive;

  /// Button for caregiver to speak to senior
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speakToSenior;

  /// Medications section title
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// Wellness section title
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get wellness;

  /// Live session title
  ///
  /// In en, this message translates to:
  /// **'Live Session'**
  String get liveSession;

  /// Connection status text
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Connected status text
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Disconnected status text
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Empty state for medications
  ///
  /// In en, this message translates to:
  /// **'No medications scheduled.'**
  String get noMedications;

  /// Empty state for wellness logs
  ///
  /// In en, this message translates to:
  /// **'No wellness records yet.'**
  String get noWellnessLogs;

  /// Authentication expired error
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errAuth001;

  /// Invalid token error
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get errAuth002;

  /// Invalid token type error
  ///
  /// In en, this message translates to:
  /// **'Invalid session type. Please sign in again.'**
  String get errAuth003;

  /// Authorization error
  ///
  /// In en, this message translates to:
  /// **'You do not have permission for this action.'**
  String get errAuthz001;

  /// Relation not found error
  ///
  /// In en, this message translates to:
  /// **'Care relation not found.'**
  String get errRes001;

  /// Wellness log not found error
  ///
  /// In en, this message translates to:
  /// **'Wellness record not found. Let\'s try again.'**
  String get errRes002;

  /// Medication not found error
  ///
  /// In en, this message translates to:
  /// **'Medication not found.'**
  String get errRes003;

  /// Invalid caregiver role error
  ///
  /// In en, this message translates to:
  /// **'Invalid caregiver role.'**
  String get errVal001;

  /// Self-relation error
  ///
  /// In en, this message translates to:
  /// **'You cannot create a relation with yourself.'**
  String get errVal002;

  /// LiveKit service unavailable error
  ///
  /// In en, this message translates to:
  /// **'Live service is currently unavailable. Please try again later.'**
  String get errSvc001;

  /// Gemini API unavailable error
  ///
  /// In en, this message translates to:
  /// **'AI service is not available right now.'**
  String get errSvc002;

  /// OAuth email missing error
  ///
  /// In en, this message translates to:
  /// **'Could not get your email from the login provider.'**
  String get errSvc003;

  /// Unknown error fallback
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get errUnknown;
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
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
