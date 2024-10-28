import 'package:dgg/app/app.dialogs.dart';
import 'package:dgg/app/app.locator.dart';
import 'package:dgg/app/app.router.dart';
import 'package:dgg/datamodels/session_info.dart';
import 'package:dgg/services/dgg_service.dart';
import 'package:dgg/services/shared_preferences_service.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dggService = locator<DggService>();
  final _sharedPreferencesService = locator<SharedPreferencesService>();
  final _themeService = locator<ThemeService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  bool get isSignedIn => _dggService.sessionInfo is Available;
  String? get username => (_dggService.sessionInfo as Available).nick;

  bool _isAnalyticsEnabled = false;
  bool get isAnalyticsEnabled => _isAnalyticsEnabled;
  bool _isWakelockEnabled = false;
  bool get isWakelockEnabled => _isWakelockEnabled;
  int _themeIndex = 0;
  int get themeIndex => _themeIndex;
  int _appBarTheme = 0;
  int get appBarTheme => _appBarTheme;
  bool _isInAppBrowserEnabled = true;
  bool get isInAppBrowserEnabled => _isInAppBrowserEnabled;

  void initialize() {
    _isAnalyticsEnabled = _sharedPreferencesService.getAnalyticsEnabled();
    _isWakelockEnabled = _sharedPreferencesService.getWakelockEnabled();
    _themeIndex = _sharedPreferencesService.getThemeIndex();
    _appBarTheme = _sharedPreferencesService.getAppBarTheme();
    _isInAppBrowserEnabled = _sharedPreferencesService.getInAppBrowserEnabled();
    notifyListeners();
  }

  void openFeedback() {
    launch(
      r"https://docs.google.com/forms/d/e/1FAIpQLScuIOGffMHf3HHnCVdHVN6u08Pr_VGd6nU9raaWJi5ANSN8QQ/viewform?usp=sf_link",
    );
  }

  void signOut() {
    _dggService.signOut();
    notifyListeners();
  }

  void openProfile() {
    launch(
      r"https://www.destiny.gg/profile",
    );
  }

  Future<void> navigateToAuth() async {
    await _navigationService.navigateTo(Routes.authView);
    notifyListeners();
  }

  void toggleWakelockEnabled(bool value) {
    _sharedPreferencesService.setWakelockEnabled(value);
    _isWakelockEnabled = value;
    notifyListeners();
  }

  void setTheme(int value) {
    _themeService.selectThemeAtIndex(value);
    _themeIndex = value;
    notifyListeners();
  }

  void setAppBarTheme(int value) {
    _sharedPreferencesService.setAppBarTheme(value);
    _appBarTheme = value;
    notifyListeners();
  }

  void navigateToChatSize() {
    _navigationService.navigateTo(Routes.chatSizeView);
  }

  void navigateToIgnoreList() {
    _navigationService.navigateTo(Routes.ignoreListView);
  }

  void toggleInAppBrowserEnabled(bool value) {
    _sharedPreferencesService.setInAppBrowserEnabled(value);
    _isInAppBrowserEnabled = value;
    notifyListeners();
  }

  void openGitHub() {
    launch(r"https://github.com/Moseco/dgg");
  }

  Future<void> requestDataDeletion() async {
    final response = await _dialogService.showCustomDialog(
      variant: DialogType.confirmation,
      title: 'Request data deletion',
      description:
          'If enabled, this app collects analytics relating to app usage and crash reports. You can request to have all your analytics related data deleted. If you choose to, your unique ID will be copied to your clipboard which you need to submit in the form that will be opened in a browser.',
      mainButtonTitle: 'Open',
      secondaryButtonTitle: 'Cancel',
      barrierDismissible: true,
    );
  }
}
