[![pub package](https://img.shields.io/pub/v/google_wallet.svg)](https://pub.dartlang.org/packages/google_wallet)

A plugin to integrate Google Wallet into your Flutter application.

## Getting started
Before you start, follow the [setup guide for Google Wallet on Android](https://developers.google.com/wallet/generic/android/prerequisites).

## Usage
To start using this plugin, add `google_wallet` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/):

```
flutter pub add google_wallet
```

### Example

The following example shows how to check that the Google Wallet API is available,
and save a pass to the user's Google Wallet:

```dart
import 'package:google_wallet/google_wallet.dart';

final googleWallet = GoogleWallet();
final String jwt = '...'; // your own pass JWT

example() async {
  bool? available;
  bool? saved = false;
  String text;

  // Check if Google Wallet is available
  try {
    available = await googleWallet.isAvailable();
    text = "Google Wallet is available: ${available}";
  } on PlatformException catch (e) {
    text = "Error: '${e.message}'.";
  }

  // Save a pass to Google Wallet
  try {
    if (available == true) {
      saved = await googleWallet.savePassesJwt(jwt);
      text = "Pass saved: ${saved}";
    } else {
      // Wallet unavailable,
      // fall back to saving pass via web: "https://pay.google.com/gp/v/save/${jwt}"
      text = "Opened Google Wallet via web";
    }
  } on PlatformException catch (e) {
    text = "Error: '${e.message}'.";
  }
}
```

The plugin also provides a Google Wallet button widget:

```dart
GoogleWalletButton(
  style: GoogleWalletButtonStyle.condensed, // or GoogleWalletButtonStyle.primary (default)
  height: 90,
  onPressed: ... // callback function
)
```

A complete example of all the above can be found in the `example` directory.

<br>
<sup>Note: This is not an officially supported Google product.</sup>