import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/models/onboarding_items.dart';

class ContentTemplate extends StatelessWidget {
  const ContentTemplate({
    super.key,
    required this.item,
  });

  final OnBoardItems item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset(
          item.image,
          height: size.height * 0.3,
        ),
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              item.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontFamily: 'Nunito-Bold'),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            item.shortDescription,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, fontFamily: 'Nunito'),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: size.height * 0.1),
      ],
    );
  }
}
