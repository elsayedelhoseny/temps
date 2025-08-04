import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@immutable
abstract class GlobalStates {}

class GlobalCubitInitial extends GlobalStates {}

class GetReadForFirstTimeValueState extends GlobalStates {}
class ReadForFirstTimeState extends GlobalStates {}

class EndSplashState extends GlobalStates {}

class TimeOutState extends GlobalStates {
  final bool isTimeOut;
  TimeOutState({required this.isTimeOut});
}
class LoadingInitialState extends GlobalStates {}

class InitialWebViewControllersState extends GlobalStates {}

class ControllerCreatedState extends GlobalStates {}

class WebLoadingState extends GlobalStates {}

class InitPageControllerState extends GlobalStates {}

class ChangeCurrentIndexState extends GlobalStates {}

class GettingDrawerMenuState extends GlobalStates {}

class ChosenElementRemovedState extends GlobalStates {}
class GoBackState extends GlobalStates {}
class UpdatedState extends GlobalStates {}
class RefreshState extends GlobalStates {}
class ExitNotificationState extends GlobalStates {}

class LoadingInitState extends GlobalStates {}
class SuccessCheckedForModelUpdatesState extends GlobalStates {}
class SuccessGettingModelState extends GlobalStates {}
class tryingSavedModelState extends GlobalStates {}
class SuccessUsingSavedModelState extends GlobalStates {}
class SuccessAppliedSavedModelState extends GlobalStates {}
class UsingLocalModelState extends GlobalStates {}
class ErrorGettingModelState extends GlobalStates {}
class FixingErrorGettingModelState extends GlobalStates {}

class ApplyingModelState extends GlobalStates {}
class AppliedModelState extends GlobalStates {}
class AppliedPopUpCodeState extends GlobalStates {}
class ErrorApplyingModelState extends GlobalStates {}

class PopUpInitial extends GlobalStates {}

class PopUpJsEvaluating extends GlobalStates {}

class PopUpJsUrlSet extends GlobalStates {}

class SuccessPopUpJsEvaluated extends GlobalStates {}

class WebViewJsEvaluationError extends GlobalStates {
  final String errorMessage;

  WebViewJsEvaluationError(this.errorMessage);
}
class SplashState extends GlobalStates {}

class OnboardingEndState extends GlobalStates {}

class PrivacyPolicyEndState extends GlobalStates {}

class ChangeBottomNavIndexState extends GlobalStates {}


///////////////////////////////////////webView States////////////////////////


class WebViewRefreshState extends GlobalStates {}
class WebViewControllerUpdatedState extends GlobalStates {}
class UserLoginState extends GlobalStates {}
class UserLoginRefreshState extends GlobalStates {}

class WebViewUpdatedStateState extends GlobalStates {}

class WebViewLoadStartStateState extends GlobalStates {}

class WebViewLoadStopStateState extends GlobalStates {}

class WebViewContentSizeChanged extends GlobalStates {
  final InAppWebViewController controller;
  WebViewContentSizeChanged(this.controller);
}

class WebViewZoomChanged extends GlobalStates {
  final InAppWebViewController controller;
  WebViewZoomChanged(this.controller);
}

class WebViewTitleChanged extends GlobalStates {
  final InAppWebViewController controller;
  final String title;
  WebViewTitleChanged(this.controller, this.title);
}

class WebViewProgressChanged extends GlobalStates {
  final int progress;
  WebViewProgressChanged(this.progress);
}

class WebViewErrorOccurred extends GlobalStates {
  final WebResourceError error;
  WebViewErrorOccurred(this.error);
}