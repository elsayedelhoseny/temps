
import 'package:meta/meta.dart';
import 'dart:convert';

class MainAppJson {
  int hashValue;
  Settings settings;
  String popups;

  MainAppJson({
    required this.hashValue,
    required this.settings,
    required this.popups,
  });

  factory MainAppJson.fromJson(Map<String, dynamic> json) => MainAppJson(
    hashValue: json["hashValue"],
    settings: Settings.fromJson(json["setting"]),
    popups: json["popups"],
  );

  Map<String, dynamic> toJson() => {
    "hashValue": hashValue,
    "setting": settings.toJson(),
    "popups": popups,
  };
}

class Settings {
  AppColorsSection appColorsSection;
  SplashScreenSection splashScreenSection;
  NavBarSection navBarSection;
  PrivacyPolicySection privacyPolicySection;
  WhatsAppSection whatsAppSection;
  OnboardingScreenSection onboardingScreenSection;
  DevelopersSettingsSection developersSettingsSection;
  BackButtonSection backButtonSection;

  Settings({
    required this.appColorsSection,
    required this.splashScreenSection,
    required this.navBarSection,
    required this.privacyPolicySection,
    required this.whatsAppSection,
    required this.onboardingScreenSection,
    required this.developersSettingsSection,
    required this.backButtonSection,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    appColorsSection: AppColorsSection.fromJson(json["appColorsSection"]),
    splashScreenSection: SplashScreenSection.fromJson(json["splashScreenSection"]),
    navBarSection: NavBarSection.fromJson(json["navBarSection"]),
    privacyPolicySection: PrivacyPolicySection.fromJson(json["privacyPolicySection"]),
    whatsAppSection: WhatsAppSection.fromJson(json["whatsAppSection"]),
    onboardingScreenSection: OnboardingScreenSection.fromJson(json["onboardingScreenSection"]),
    developersSettingsSection: DevelopersSettingsSection.fromJson(json["developersSettings"]),
    backButtonSection: BackButtonSection.fromJson(json["backButton"]),
  );

  Map<String, dynamic> toJson() => {
    "appColorsSection": appColorsSection.toJson(),
    "splashScreenSection": splashScreenSection.toJson(),
    "navBarSection": navBarSection.toJson(),
    "privacyPolicySection": privacyPolicySection.toJson(),
    "whatsAppSection": whatsAppSection.toJson(),
    "onboardingScreenSection": onboardingScreenSection.toJson(),
    "developersSettings": developersSettingsSection.toJson(),
  };
}

class AppColorsSection {
  String templateStyle;
  List<AppColorsSectionComponent> components;

  AppColorsSection({
    required this.templateStyle,
    required this.components,
  });

  factory AppColorsSection.fromJson(Map<String, dynamic> json) => AppColorsSection(
    templateStyle: json["templateStyle"],
    components: List<AppColorsSectionComponent>.from(json["components"].map((x) => AppColorsSectionComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<dynamic>.from(components.map((x) => x.toJson())),
  };
}

class AppColorsSectionComponent {
  String iconsColor;
  String primaryColor;

  AppColorsSectionComponent({
    required this.iconsColor,
    required this.primaryColor,
  });

  factory AppColorsSectionComponent.fromJson(Map<String, dynamic> json) => AppColorsSectionComponent(
    iconsColor: json["iconsColor"],
    primaryColor: json["primaryColor"],
  );

  Map<String, dynamic> toJson() => {
    "iconsColor": iconsColor,
    "primaryColor": primaryColor,
  };
}

class NavBarSection {
  String templateStyle;
  List<NavBarSectionComponent> components;

  NavBarSection({
    required this.templateStyle,
    required this.components,
  });

  factory NavBarSection.fromJson(Map<String, dynamic> json) => NavBarSection(
    templateStyle: json["templateStyle"],
    components: List<NavBarSectionComponent>.from(json["components"].map((x) => NavBarSectionComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<dynamic>.from(components.map((x) => x.toJson())),
  };
}

class NavBarSectionComponent {
  List<NavBarItem> items;

  NavBarSectionComponent({
    required this.items,
  });

  factory NavBarSectionComponent.fromJson(Map<String, dynamic> json) => NavBarSectionComponent(
    items: List<NavBarItem>.from(json["items"].map((x) => NavBarItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class NavBarItem {
  String url;
  String title;
  String iconImage;

  NavBarItem({
    required this.url,
    required this.title,
    required this.iconImage,
  });

  factory NavBarItem.fromJson(Map<String, dynamic> json) => NavBarItem(
    url: json["url"],
    title: json["title"],
    iconImage: json["iconImage"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "title": title,
    "iconImage": iconImage,
  };
}

class OnboardingScreenSection {
  String templateStyle;
  List<OnboardingScreenSectionComponent> components;

  OnboardingScreenSection({
    required this.templateStyle,
    required this.components,
  });

  factory OnboardingScreenSection.fromJson(Map<String, dynamic> json) => OnboardingScreenSection(
    templateStyle: json["templateStyle"],
    components: List<OnboardingScreenSectionComponent>.from(json["components"].map((x) => OnboardingScreenSectionComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<dynamic>.from(components.map((x) => x.toJson())),
  };
}

class OnboardingScreenSectionComponent {
  String body;
  String title;
  String imageUrl;

  OnboardingScreenSectionComponent({
    required this.body,
    required this.title,
    required this.imageUrl,
  });

  factory OnboardingScreenSectionComponent.fromJson(Map<String, dynamic> json) => OnboardingScreenSectionComponent(
    body: json["body"],
    title: json["title"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "body": body,
    "title": title,
    "imageUrl": imageUrl,
  };
}

class PrivacyPolicySection {
  String templateStyle;
  List<PrivacyPolicySectionComponent> components;

  PrivacyPolicySection({
    required this.templateStyle,
    required this.components,
  });

  factory PrivacyPolicySection.fromJson(Map<String, dynamic> json) => PrivacyPolicySection(
    templateStyle: json["templateStyle"],
    components: List<PrivacyPolicySectionComponent>.from(json["components"].map((x) => PrivacyPolicySectionComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<dynamic>.from(components.map((x) => x.toJson())),
  };
}

class PrivacyPolicySectionComponent {
  String privacyPolicy;
  bool enabled;
  PrivacyPolicySectionComponent({
    required this.privacyPolicy,
    required this.enabled,
  });

  factory PrivacyPolicySectionComponent.fromJson(Map<String, dynamic> json) => PrivacyPolicySectionComponent(
    privacyPolicy: json["privacyPolicy"],
    enabled: json["enabled"],
  );

  Map<String, dynamic> toJson() => {
    "privacyPolicy": privacyPolicy,
    "enabled": enabled,
  };
}

class SplashScreenSection {
  String templateStyle;
  List<SplashScreenSectionComponent> components;

  SplashScreenSection({
    required this.templateStyle,
    required this.components,
  });

  factory SplashScreenSection.fromJson(Map<String, dynamic> json) => SplashScreenSection(
    templateStyle: json["templateStyle"],
    components: List<SplashScreenSectionComponent>.from(json["components"].map((x) => SplashScreenSectionComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<dynamic>.from(components.map((x) => x.toJson())),
  };
}

class SplashScreenSectionComponent {
  String logoImage;
  dynamic gradientColor1;
  dynamic gradientColor2;
  String backgroundColor;

  SplashScreenSectionComponent({
    required this.logoImage,
    required this.gradientColor1,
    required this.gradientColor2,
    required this.backgroundColor,
  });

  factory SplashScreenSectionComponent.fromJson(Map<String, dynamic> json) => SplashScreenSectionComponent(
    logoImage: json["logoImage"],
    gradientColor1: json["gradientColor1"],
    gradientColor2: json["gradientColor2"],
    backgroundColor: json["backgroundColor"],
  );

  Map<String, dynamic> toJson() => {
    "logoImage": logoImage,
    "gradientColor1": gradientColor1,
    "gradientColor2": gradientColor2,
    "backgroundColor": backgroundColor,
  };
}

class WhatsAppSection {
  String templateStyle;
  List<WhatsAppSectionComponent> components;

  WhatsAppSection({
    required this.templateStyle,
    required this.components,
  });

  factory WhatsAppSection.fromJson(Map<String, dynamic> json) => WhatsAppSection(
    templateStyle: json["templateStyle"],
    components: List<WhatsAppSectionComponent>.from(json["components"].map((x) => WhatsAppSectionComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<dynamic>.from(components.map((x) => x.toJson())),
  };
}

class WhatsAppSectionComponent {
  List<WhatsAppIcon> icons;
  String number;
  bool enabled;
  bool is_dynamic;
  int rightPosition;
  int bottomPosition;

  WhatsAppSectionComponent({
    required this.icons,
    required this.number,
    required this.enabled,
    required this.is_dynamic,
    required this.rightPosition,
    required this.bottomPosition,
  });

  factory WhatsAppSectionComponent.fromJson(Map<String, dynamic> json) => WhatsAppSectionComponent(
    icons: List<WhatsAppIcon>.from(json["icons"].map((x) => WhatsAppIcon.fromJson(x))),
    number: json["number"],
    enabled: json["enabled"],
    is_dynamic: json["is_dynamic"],
    rightPosition: json["right"],
    bottomPosition: json["bottom"],
  );

  Map<String, dynamic> toJson() => {
    "icons": List<dynamic>.from(icons.map((x) => x.toJson())),
    "number": number,
    "enabled": enabled,
    "is_dynamic": is_dynamic,
    "right": rightPosition,
    "bottom": bottomPosition,
  };
}

class WhatsAppIcon {
  int id;
  String icon;
  String name;
  bool selected;

  WhatsAppIcon({
    required this.id,
    required this.icon,
    required this.name,
    required this.selected,
  });

  factory WhatsAppIcon.fromJson(Map<String, dynamic> json) => WhatsAppIcon(
    id: json["id"],
    icon: json["icon"],
    name: json["name"],
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "icon": icon,
    "name": name,
    "selected": selected,
  };
}
class DevelopersSettingsSection {
  String templateStyle;
  List<DevelopersSettingsComponent> components;

  DevelopersSettingsSection({
    required this.templateStyle,
    required this.components,
  });

  factory DevelopersSettingsSection.fromJson(Map<String, dynamic> json) => DevelopersSettingsSection(
    templateStyle: json["templateStyle"],
    components: List<DevelopersSettingsComponent>.from(
        json["components"].map((x) => DevelopersSettingsComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<String>.from(components.map((x) => x.toJson())),
  };
}

class DevelopersSettingsComponent {
  List<String> classes;

  DevelopersSettingsComponent({
    required this.classes,
  });

  factory DevelopersSettingsComponent.fromJson(Map<String, dynamic> json) => DevelopersSettingsComponent(
    classes: List<String>.from(json["classes"]),
  );

  Map<String, dynamic> toJson() => {
    "classes": List<dynamic>.from(classes),
  };
}

class BackButtonSection {
  String templateStyle;
  List<BackButtonSectionComponent> components;

  BackButtonSection({
    required this.templateStyle,
    required this.components,
  });

  factory BackButtonSection.fromJson(Map<String, dynamic> json) => BackButtonSection(
    templateStyle: json["templateStyle"],
    components: List<BackButtonSectionComponent>.from(json["components"].map((x) => BackButtonSectionComponent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templateStyle": templateStyle,
    "components": List<dynamic>.from(components.map((x) => x.toJson())),
  };
}

class BackButtonSectionComponent {
  bool enabled;
  int rightPosition;
  int topPosition;

  BackButtonSectionComponent({
    required this.enabled,
    required this.rightPosition,
    required this.topPosition,
  });

  factory BackButtonSectionComponent.fromJson(Map<String, dynamic> json) => BackButtonSectionComponent(
    enabled: json["enabled"],
    rightPosition: json["right"],
    topPosition: json["top"],
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "right": rightPosition,
    "top": topPosition,
  };
}
