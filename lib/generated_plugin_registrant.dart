//
// Generated file. Do not edit.
//

// ignore_for_file: lines_longer_than_80_chars

import 'package:device_info_plus_web/device_info_plus_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  DeviceInfoPlusPlugin.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
