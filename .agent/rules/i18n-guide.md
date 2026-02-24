---
trigger: model_decision
description: when working for internationalization or localization.
---

# I18n Workflow

## Source of Truth
The single source of truth for all i18n keys is in packages/i18n/src/.

- Do NOT edit files in apps/mobile/lib/i18n directly
- ALWAYS make changes in packages/i18n/src/*.arb (en.arb, ko.arb, ja.arb)

## Workflow

### 1. Modify Keys
Add, update, or delete keys in packages/i18n/src/en.arb.
Sync changes to other language files (ko.arb, ja.arb).

### 2. Build & Distribute
```bash
mise //packages/i18n:build
```

This generates:
- Mobile: apps/mobile/lib/i18n/messages/*.arb

### 3. Apply to Mobile
```bash
cd apps/mobile
flutter gen-l10n
```

## Using Translations

### Mobile (Flutter)
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.save)
```

## Best Practices
1. Always include descriptions (@key) for translators
2. Keep keys descriptive
3. Use consistent naming across locales
4. Test all locales after adding translations
5. Build frequently to catch errors early
6. Never modify generated files

## Troubleshooting

### Build Fails
```bash
rm -rf packages/i18n/dist apps/mobile/lib/i18n/messages
mise //packages/i18n:build
```

### Mobile Not Showing Translations
```bash
cd apps/mobile
flutter clean && flutter pub get && flutter gen-l10n
```