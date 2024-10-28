import 'package:dgg/app/app.locator.dart';
import 'package:dgg/app/app.router.dart';
import 'package:dgg/datamodels/session_info.dart';
import 'package:dgg/services/dgg_service.dart';
import 'package:dgg/services/shared_preferences_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _sharedPreferencesService = locator<SharedPreferencesService>();
  final _dggService = locator<DggService>();
  final _snackbarService = locator<SnackbarService>();

  bool _isAnalyticsEnabled = true;
  bool get isAnalyticsEnabled => _isAnalyticsEnabled;
  bool get isSignedIn => _dggService.isSignedIn;
  String? _nickname;
  String? get nickname => _nickname;

  void finishOnboarding() {
    _sharedPreferencesService.setOnboarding();
    // Call this here so that changelog is not shown to new users
    _sharedPreferencesService.shouldShowChangelog();
    _navigationService.clearStackAndShow(Routes.chatView);
  }

  Future<void> navigateToAuth() async {
    await _navigationService.navigateTo(Routes.authView);
    if (_dggService.isSignedIn) {
      _nickname = (_dggService.sessionInfo as Available).nick;
    }
    notifyListeners();
  }

  Future<void> openPrivacyPolicy() async {
    try {
      if (!await launchUrl(
        Uri.parse(r'https://dgg-chat-app.web.app/'),
      )) {
        _snackbarService.showSnackbar(
          message: 'Failed to open privacy policy',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (_) {
      _snackbarService.showSnackbar(
        message: 'Failed to open privacy policy',
        duration: const Duration(seconds: 2),
      );
    }
  }
}
