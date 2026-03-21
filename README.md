# roompilot_flutter

## Adapty Setup

The app now uses `adapty_flutter` and reads config from `--dart-define`.

Required:
- `ADAPTY_API_KEY`

Optional:
- `ADAPTY_PAYWALL_PLACEMENT_ID` (default: `main_paywall`)
- `ADAPTY_ACCESS_LEVEL_ID` (default: `premium`)

Example (simulator):

```bash
flutter run \
  --dart-define=ADAPTY_API_KEY=YOUR_ADAPTY_SDK_KEY \
  --dart-define=ADAPTY_PAYWALL_PLACEMENT_ID=main_paywall \
  --dart-define=ADAPTY_ACCESS_LEVEL_ID=premium
```

Example (release build):

```bash
flutter build ios --release \
  --dart-define=ADAPTY_API_KEY=YOUR_ADAPTY_SDK_KEY \
  --dart-define=ADAPTY_PAYWALL_PLACEMENT_ID=main_paywall \
  --dart-define=ADAPTY_ACCESS_LEVEL_ID=premium
```
