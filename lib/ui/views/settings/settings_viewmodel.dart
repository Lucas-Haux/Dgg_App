import 'package:dgg/app/locator.dart';
import 'package:dgg/datamodels/session_info.dart';
import 'package:dgg/services/dgg_api.dart';
import 'package:dgg/services/shared_preferences_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dggApi = locator<DggApi>();
  final _sharedPreferencesService = locator<SharedPreferencesService>();
  final _themeService = locator<ThemeService>();

  bool get isSignedIn => _dggApi.sessionInfo is Available;
  String get username => (_dggApi.sessionInfo as Available).nick;
  bool get isCrashlyticsCollectionEnabled =>
      FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
  bool _isAnalyticsEnabled = false;
  bool get isAnalyticsEnabled => _isAnalyticsEnabled;
  bool _isWakelockEnabled = false;
  bool get isWakelockEnabled => _isWakelockEnabled;
  int _themeIndex = 0;
  int get themeIndex => _themeIndex;

  Future<void> initialize() async {
    _isAnalyticsEnabled = await _sharedPreferencesService.getAnalyticsEnabled();
    _isWakelockEnabled = await _sharedPreferencesService.getWakelockEnabled();
    _themeIndex = await _sharedPreferencesService.getThemeIndex();
    notifyListeners();
  }

  void openFeedback() {
    launch(
      r"https://docs.google.com/forms/d/e/1FAIpQLScuIOGffMHf3HHnCVdHVN6u08Pr_VGd6nU9raaWJi5ANSN8QQ/viewform?usp=sf_link",
    );
  }

  void signOut() {
    _dggApi.signOut();
    notifyListeners();
  }

  void openProfile() {
    launch(
      r"https://www.destiny.gg/profile",
    );
  }

  void back() {
    _navigationService.back();
  }

  Future<void> toggleCrashlyticsCollection(bool value) async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(value);
    notifyListeners();
  }

  Future<void> toggleAnalyticsCollection(bool value) async {
    FirebaseAnalytics().setAnalyticsCollectionEnabled(value);
    _sharedPreferencesService.setAnalyticsEnabled(value);
    _isAnalyticsEnabled = value;
    notifyListeners();
  }

  Future<void> toggleWakelockEnabled(bool value) async {
    _sharedPreferencesService.setWakelockEnabled(value);
    _isWakelockEnabled = value;
    notifyListeners();
  }

  void setTheme(int value) {
    _themeService.selectThemeAtIndex(value);
    _themeIndex = value;
    notifyListeners();
  }
}
