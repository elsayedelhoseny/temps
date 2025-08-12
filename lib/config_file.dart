//TODO: add reviewerDateEnd for the app
import 'package:olivia/utils/images.dart';

final DateTime reviewerDateEnd = DateTime(2025, 10, 30);

//TODO add your oneSignal APIKey
final String oneSignalApiKey = '46430fba-fc91-4950-84c0-32d89fc34145';

//TODO: add otpMail that related to this store
final String otpMail = "dukanrambo@trujena.com";

//TODO: add your dashboard default local model for the app
final Map<String, dynamic> dashboardLocalAppMainJson = {
  "hashValue": 1750593606,
  "setting": {
    "appColorsSection": {
      "templateStyle": "default",
      "components": [
        {"iconsColor": "#fffcfa", "primaryColor": "#9c6b26"}
      ]
    },
    "splashScreenSection": {
      "templateStyle": "default",
      "components": [
        {"logoImage": "assets/splash.png", "backgroundColor": "#ffffff"}
      ]
    },
    "onboardingScreenSection": {
      "templateStyle": "style2",
      "components": [
        {
          "body":
              "يوفر التطبيق تجربة تسوق آمنة وموثوقة. يتم توفير آليات دفع آمنة تتيح للمستخدمين إتمام عمليات الشراء بثقة وسهولة.",
          "title": "تجربة تسوق مميزة",
          "imageUrl": "assets/onboarding1.png"
        },
        {
          "body":
              "يوفر التطبيق منصة شاملة ومتكاملة لعرض وبيع المنتجات والخدمات عبر الإنترنت",
          "title": "اطلب منتجاتك بسهولة",
          "imageUrl": "assets/onboarding2.png"
        },
        {
          "body":
              "يتميز التطبيق بنظام إدارة الطلبات الفعال الذي يعرض معلومات الشحن وحالة الطلب بشكل محدث،",
          "title": "خدمة الشحن الموثوقة",
          "imageUrl": "assets/onboarding3.png"
        }
      ]
    },
    "navBarSection": {
      "templateStyle": "style1",
      "components": [
        {
          "items": [
            {
              "url": "https://tickntock.com/",
              "title": "الرئيسية",
              "iconImage": ic_home
            },
            {
              "url":
                  "https://tickntock.com/%D8%B9%D9%86%D8%A7%D9%8A%D8%A9-%D8%A8%D8%A7%D9%84%D8%A8%D8%B4%D8%B1%D8%A9/c1871243230",
              "title": "عنايه بالشعر ",
              "iconImage": "assets/comb.png"
            },
            {
              "url":
                  "https://tickntock.com/%D8%B9%D9%86%D8%A7%D9%8A%D8%A9-%D8%A8%D8%A7%D9%84%D8%B4%D8%B9%D8%B1/c187835864",
              "title": "عنايه بالبشره ",
              "iconImage": "assets/face-cream.png"
            },
            {
              "url":
                  "https://tickntock.com/%D8%B3%D8%A7%D8%B9%D8%A7%D8%AA/c920937434",
              "title": "ساعات",
              "iconImage": "assets/watch.png"
            },
          ]
        }
      ]
    },
    "privacyPolicySection": {
      "templateStyle": "default",
      "components": [
        {
          "enabled": true,
          "privacyPolicy":
              "<div><h1>Privacy Policy for tickntock</h1><p><strong>Effective Date:</strong> August 05, 2025</p><h2>1. Introduction</h2><p>Welcome to tickntock ! This Privacy Policy outlines how we collect, use, disclose, and safeguard your personal information when you use our mobile application or interact with our services.</p><h2>2. Information We Collect</h2><p><strong>2.1 Personal Information:</strong><br>When you create an account or make a purchase, we collect personal details like your name, address, email, and payment information.</p><p><strong>2.2 Usage Information:</strong><br>We gather data on your interactions with our app, such as browsing history, searches, and product/service engagement.</p><p><strong>2.3 Device Information:</strong><br>Information about your device, like device type, operating system, and unique identifiers, is collected to enhance your experience.</p><h2>3. How We Use Your Information</h2><p><strong>3.1 Service Provision:</strong><br>Your information helps us deliver personalized services, process transactions, and fulfill orders.</p><p><strong>3.2 Communication:</strong><br>We may use your contact details to send transactional updates and marketing communications based on your preferences.</p><p><strong>3.3 Enhancing Services:</strong><br>Analyzing user data aids in improving app functionality and user experience.</p><h2>4. Information Sharing</h2><p><strong>4.1 Third-Party Providers:</strong><br>We may share data with third-party service providers to assist in delivering services, processing payments, and performing other business functions.</p><p><strong>4.2 Legal Compliance:</strong><br>We may disclose information to comply with legal obligations or respond to law enforcement requests.</p><h2>5. Your Choices</h2><p><strong>5.1 Account Management:</strong><br>You have the option to update or delete your account information within the app's settings.</p><p><strong>5.2 Communication Preferences:</strong><br>Manage your communication preferences by opting in or out of marketing communications.</p><h2>6. Security</h2><p>We implement reasonable security measures to protect your personal information from unauthorized access, disclosure, or alteration.</p><h2>7. Changes to This Privacy Policy</h2><p>We reserve the right to update this Privacy Policy to reflect changes in practices or for legal reasons. We'll notify you of any material changes.</p><h2>8. Contact Us</h2><p>If you have questions or concerns about this Privacy Policy, please reach out to us at <a href=\"mailto:Samrynalryshy505@gmail.com\">Samrynalryshy505@gmail.com</a>.</p></div>"
        }
      ]
    },
    "whatsAppSection": {"templateStyle": "default", "components": []},
    "developersSettings": {
      "templateStyle": "default",
      "components": [
        {
          "classes": [
            ".breadcrumbs",
            ".breadcrumb",
            "h1#page-main-title",
            "h1#page-main-title + *",
            ".offer-bar-preview",
            "section.fixed.sticky_bar",
            ".search-result-top",
            ".mobile-nav-inner.fixed.bottom-0.left-0.right-0.z-50.w-full",
            ".store-footer__inner"
          ]
        }
      ]
    },
    "backButton": {
      "templateStyle": "default",
      "components": [
        {"top": 50, "right": 4, "enabled": true}
      ]
    }
  },
  "popups": ""
};
