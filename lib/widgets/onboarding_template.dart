import 'package:flutter/material.dart';
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
        Image.asset(
          item.image,
          height: size.height * 0.3,
        ),
        FittedBox(
          child: Text(
            item.title,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontFamily: 'Nunito-Bold'),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          item.shortDescription,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: 'Nunito'),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.height * 0.1),
      ],
    );
  }
}
