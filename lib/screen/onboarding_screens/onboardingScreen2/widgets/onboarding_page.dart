
import 'package:flutter/material.dart';
import '../../../../model/main_app_json.dart';
import '../../../../utils/AppWidget.dart';
import '../../../../utils/responsive.dart';


class OnboardingPage1 extends StatelessWidget {
  final OnboardingScreenSectionComponent onboardingData;
  final bool isPortrait;
  final String images;
  const OnboardingPage1({
    super.key,
    required this.onboardingData,
    required this.isPortrait,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return isPortrait
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 125.h(context)),
              FittedBox(
                child: Text(
                  onboardingData.title,
                  style: TextStyle(

                      fontSize: 29.w(context), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 22.h(context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  onboardingData.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.w(context),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 42.h(context)),
              cachedImage(images,
                  fit: BoxFit.fill,
                  height: 274.63.h(context),
                  width: MediaQuery.of(context).size.width),
            ],
          )
        : Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          cachedImage(images,
                              height: 200.63.h(context),
                              width: MediaQuery.of(context).size.width -
                                  40.w(context)),
                        ],
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
                                  fontSize: 29.w(context),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 22.h(context)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              onboardingData.body,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.w(context),
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
