// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Juny';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get login => 'Sign In';

  @override
  String get logout => 'Sign Out';

  @override
  String get loginWithGoogle => 'Sign in with Google';

  @override
  String get loginWithGithub => 'Sign in with GitHub';

  @override
  String get welcomeHost => 'Hello! How are you today?';

  @override
  String get welcomeConcierge => 'Caregiver Dashboard';

  @override
  String get startLive => 'Start Live';

  @override
  String get endLive => 'End Live';

  @override
  String get watchLive => 'Watch Live';

  @override
  String get speakToSenior => 'Speak';

  @override
  String get medications => 'Medications';

  @override
  String get wellness => 'Wellness';

  @override
  String get liveSession => 'Live Session';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get noMedications => 'No medications scheduled.';

  @override
  String get noWellnessLogs => 'No wellness records yet.';

  @override
  String get errAuth001 => 'Your session has expired. Please sign in again.';

  @override
  String get errAuth002 => 'Invalid credentials. Please try again.';

  @override
  String get errAuth003 => 'Invalid session type. Please sign in again.';

  @override
  String get errAuthz001 => 'You do not have permission for this action.';

  @override
  String get errRes001 => 'Care relation not found.';

  @override
  String get errRes002 => 'Wellness record not found. Let\'s try again.';

  @override
  String get errRes003 => 'Medication not found.';

  @override
  String get errVal001 => 'Invalid caregiver role.';

  @override
  String get errVal002 => 'You cannot create a relation with yourself.';

  @override
  String get errSvc001 =>
      'Live service is currently unavailable. Please try again later.';

  @override
  String get errSvc002 => 'AI service is not available right now.';

  @override
  String get errSvc003 => 'Could not get your email from the login provider.';

  @override
  String get errUnknown => 'An unknown error occurred.';
}
