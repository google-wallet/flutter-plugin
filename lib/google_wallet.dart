/*
 * Copyright 2024 Google LLC.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

library google_wallet;

import 'dart:io' show Platform;
import 'dart:math' show max;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleWallet {
  final channel = MethodChannel('plugins.flutter.io/google_wallet_channel');

  Future<T?> _invokeMethodIfAndroid<T>(String method, T? defaultValue, [Map<String, Object>? args]) async {
    if (Platform.isAndroid) {
      return channel.invokeMethod<T>(method, args);
    }
    return Future<T?>.value(defaultValue);
  }

  Future<bool?> isAvailable() async {
    return _invokeMethodIfAndroid<bool?>('isAvailable', false);
  }

  Future<bool?> savePasses(String passJson) async {
    return _invokeMethodIfAndroid<bool?>('savePasses', false, {"passJson": passJson});
  }

  Future<bool?> savePassesJwt(String passJwt) async {
    return _invokeMethodIfAndroid<bool?>('savePassesJwt', false, {"passJwt": passJwt});
  }
}

enum GoogleWalletButtonStyle {
  primary,
  condensed
}

class GoogleWalletButton extends StatelessWidget {
  static const double _minHeight = 48;
  static const _defaultLocale = 'en';
  static const _supportedLocales = ['ar', 'az', 'bg', 'br', 'bs', 'by', 'ca', 'cz', 'de', 'dk', 'en_AU', 'en_CA', 'en_GB', 'en_IN', 'en_SG', 'en_US', 'en_ZA', 'es_419', 'es_ES', 'es_US', 'et', 'fl', 'fp', 'fr_CA', 'fr_FR', 'gr', 'he', 'hr', 'hu', 'hy', 'id', 'is', 'it', 'jp', 'ka', 'kk', 'ky', 'lt', 'lv', 'mk', 'my', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'se', 'sk', 'sl', 'sq', 'sr', 'th', 'tr', 'uk', 'uz', 'vi', 'zh_HK', 'zh_TW'];

  final GoogleWalletButtonStyle style;
  final double height;
  final VoidCallback? onPressed;

  const GoogleWalletButton({
    Key? key,
    this.style = GoogleWalletButtonStyle.primary,
    this.height = _minHeight,
    this.onPressed,
  }) : super(key: key);

  String _assetPath(context) {
    final localeName = _supportedLocales.contains(Platform.localeName) ? Platform.localeName : _defaultLocale;
    return 'assets/${localeName}_wallet_button_${style.name}.svg';
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.all(8),
      onPressed: onPressed,
      child: SvgPicture.asset(
        _assetPath(context),
        height: max(height, _minHeight),
        fit: BoxFit.contain,
        package: 'google_wallet',
      ),
    );
  }
}