import 'package:flutter/material.dart';
import '../../../../utils/responsive.dart';

class LandscapeIntroWidget extends StatelessWidget {
  const LandscapeIntroWidget({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 20.h(context)),
            height: 200.h(context),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        const Spacer()
      ],
    );
  }
}
