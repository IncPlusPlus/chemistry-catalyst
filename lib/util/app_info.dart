import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static final instance = AppInfo._();
  // Fill with empty values until initialized
  String _appName = '';
  String _packageName = '';
  String _version = '';
  String _buildNumber = '';

  AppInfo._();

  Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
    _packageName = packageInfo.packageName;
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  String get appName => _appName;

  String get packageName => _packageName;

  String get version => _version;

  String get buildNumber => _buildNumber;
}
