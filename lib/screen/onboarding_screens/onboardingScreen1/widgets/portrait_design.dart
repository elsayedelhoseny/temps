import 'package:flutter/material.dart';
import '../../../../utils/AppWidget.dart';
import '../../../../utils/responsive.dart';


class PortraitDesign extends StatelessWidget {
  const PortraitDesign({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.onTab,
    this.isLastPage = false,
  });

  final String title;
  final String description;
  final String image;
  final VoidCallback onTab;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: 89.h(context)),
          child: cachedImage(image,
              fit: BoxFit.fitHeight,
              height: 274.63.h(context),
              width: MediaQuery.of(context).size.width),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: MediaQuery.of(context).size.height / 2.16,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                children: [
                  SizedBox(height: 100.h(context)),
                  FittedBox(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h(context)),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16.w(context),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
