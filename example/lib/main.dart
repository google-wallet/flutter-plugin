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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Wallet Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Google Wallet Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final googleWallet = GoogleWallet();
  final String jwt = 'eyJ0eXAiOiAiSldUIiwgImFsZyI6ICJSUzI1NiIsICJraWQiOiAiMjVmNjgzZDEwNzRhOTZkZmEwMGRiNDEwMjkwMzIwNTAyNzhiOTMwYiJ9.eyJpc3MiOiAiZGV2bW9kZXRlc3RAbXVzaWMtMjA1MjIyLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwgImF1ZCI6ICJnb29nbGUiLCAib3JpZ2lucyI6IFsid3d3LmV4YW1wbGUuY29tIl0sICJ0eXAiOiAic2F2ZXRvd2FsbGV0IiwgInBheWxvYWQiOiB7ImdlbmVyaWNPYmplY3RzIjogW3siaWQiOiAiMzM4ODAwMDAwMDAyMjE4NDQwMy50ZXN0MTIzNTY2NzNzcyJ9XX19.06qERcEP9l9dGQwbqueXWFF_UI50TX21x0PdmTyj--di2aNTFLsWB_yGOdS-nPT0X6_mn0nVmcrqnXkT0tcb7kye9jxwD-lVwjHYwn4R3Y7l7dWcQNcjeGPopeOoJmWiQF6uZoRmpmfr0q0kSS23QAPqbOiPpX4z_InARsG1p8XN1OQkCb9bx-YWu1bT-E5Be1UE5Si4NUOEZfyl4pis_HE2aKxtC7Rg-7VGNuSyyatJHZZ3bm_uU9QCG99rpRTHST4ggLW_npiPCBh6r7L3bR3PsKYejyn1zD6NQykQ3bHB9BSSNOtCDKI_8q121jjwc4KKz4dAonKxiYQhSYbrzg';
  bool? _available = false;
  String _text = 'Loading';

  @override
  void initState() {
    super.initState();
    _checkAvailable();
  }

  _checkAvailable() async {
    bool? available;
    String text;
    try {
      available = await googleWallet.isAvailable();
      text = "Google Wallet is available: ${available}";
    } on PlatformException catch (e) {
      text = "Error: '${e.message}'.";
    }
    setState(() {
      _available = available;
      _text = text;
    });
  }

  _savePass() async {
    bool? saved = false;
    String text;
    try {
      if (this._available == true) {
        saved = await googleWallet.savePassesJwt(jwt);
        text = "Pass saved: ${saved}";
      } else {
        // Wallet unavailable,
        // fall back to saving pass via web
        await _savePassBrowser();
        text = "Opened Google Wallet via web";
      }
    } on PlatformException catch (e) {
      text = "Error: '${e.message}'.";
    }
    setState(() {
      _text = text;
    });
  }

  _savePassBrowser() async {
    String url = "https://pay.google.com/gp/v/save/${jwt}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open Google Wallet via web';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GoogleWalletButton(
              style: GoogleWalletButtonStyle.condensed,
              height: 90,
              onPressed: _savePass,
              // optionally set the locale explicitly:
              // locale: Locale("en_US"),
            ),
            Text(_text),
          ],
        ),
      ),
    );
  }
}