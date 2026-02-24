import 'package:flutter/widgets.dart';
import 'package:mobile/i18n/generated/app_localizations.dart';

/// Maps backend error codes to localized user-friendly messages.
String getErrorMessage(BuildContext context, String errorCode) {
  final l10n = AppLocalizations.of(context)!;
  return switch (errorCode) {
    'AUTH_001' => l10n.errAuth001,
    'AUTH_002' => l10n.errAuth002,
    'AUTH_003' => l10n.errAuth003,
    'AUTHZ_001' => l10n.errAuthz001,
    'RES_001' => l10n.errRes001,
    'RES_002' => l10n.errRes002,
    'RES_003' => l10n.errRes003,
    'VAL_001' => l10n.errVal001,
    'VAL_002' => l10n.errVal002,
    'SVC_001' => l10n.errSvc001,
    'SVC_002' => l10n.errSvc002,
    'SVC_003' => l10n.errSvc003,
    _ => l10n.errUnknown,
  };
}
