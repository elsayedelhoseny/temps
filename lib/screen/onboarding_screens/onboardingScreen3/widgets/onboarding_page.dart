
import 'package:flutter/material.dart';
import '../../../../model/main_app_json.dart';
import '../../../../utils/AppWidget.dart';
import '../../../../utils/responsive.dart';

class OnboardingPage3 extends StatelessWidget {
  final OnboardingScreenSectionComponent onboardingData;
  final bool isPortrait;
  final String images;
  const OnboardingPage3({
    required this.onboardingData,
    required this.isPortrait,
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: isPortrait
          ? buildPortraitContent(context)
          : buildLandscapeContent(context),
    );
  }

  Widget buildPortraitContent(BuildContext context) {
    return Column(
      children: [
        cachedImage(images,
            height: 375.63.h(context),
            width: MediaQuery.of(context).size.width - 40.w(context)),
        SizedBox(height: 42.h(context)),
        FittedBox(
          child: Text(
            onboardingData.title,
            style: TextStyle(
              fontSize: 32.h(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 22.h(context)),
        Text(
          onboardingData.body,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.w(context),
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildLandscapeContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              images,
              height: 200.63.h(context),
              width: MediaQuery.of(context).size.width - 40.w(context),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  onboardingData.title,
                  style: TextStyle(
                    fontSize: 32.h(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 22.h(context)),
              Text(
                onboardingData.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.w(context),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
