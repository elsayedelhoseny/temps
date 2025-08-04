import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nb_utils/nb_utils.dart';

import '../cubit/Global/cubit.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import '../utils/responsive.dart';

class HtmlReader extends StatelessWidget {
  final String htmlString;

  const HtmlReader({Key? key, required this.htmlString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri("about:blank")),
      initialSettings: InAppWebViewSettings(
        disableHorizontalScroll: true,
        enableViewportScale: true,
        supportZoom: false,
        horizontalScrollBarEnabled: false,
        verticalScrollBarEnabled: false,
      ),
      onWebViewCreated: (controller) {
        controller.loadData(
          data: injectScalingCss(htmlString, context),
          mimeType: "text/html",
          encoding: "utf-8",
          baseUrl: WebUri("about:blank"),
        );
        controller.addJavaScriptHandler(
          handlerName: 'onContinuePressed',
          callback: (args) {
            GlobalCubit.get(context).privacyPolicyGetStartedPressed();
          },
        );
      },
    );
  }
}

String injectScalingCss(String htmlString, BuildContext context) {
  final String bgColor = hexPrimaryColor;
  final String textColor = primaryColor.isDark() ? '#FFFFFF' : '#000000';
  final String dir = containsArabic(htmlString) ? 'rtl' : 'ltr';
  return """
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <style>
          body {
              font-size: 1em;  
              line-height: 1.4;  
            }
          .continue-btn {
            display: inline-block;
            background-color: $bgColor;
            color: $textColor;
            padding: 14px 50px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: bold;
            margin-top: 10px;
            text-align: center;
            cursor: pointer;
          }
        </style>
      </head>
      <body dir="$dir">
        $htmlString

        <div style="text-align:center;">
          <button class="continue-btn" onclick="window.flutter_inappwebview.callHandler('onContinuePressed')">
            ${getLocalizedText(context).translate('lbl_get_continue') ?? 'Continue'}
          </button>
        </div>
      </body>
    </html>
  """;
}

bool containsArabic(String text) {
  final arabicRegex = RegExp(r'[\u0600-\u06FF]');
  return arabicRegex.hasMatch(text);
}

class PrivacyPolicyScreen extends StatelessWidget {
  final String htmlcontent;

  const PrivacyPolicyScreen({
    Key? key,
    required this.htmlcontent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.fs(context)),
              margin: EdgeInsets.symmetric(
                horizontal: 20.w(context),
                vertical: 40.h(context),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: HtmlReader(
                htmlString: htmlcontent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
