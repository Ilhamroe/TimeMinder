import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/models/onboarding_items.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/onboarding_template.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int selectedIndex = 0;
  late PageController controller;

  @override
  void initState() {
    controller =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          "assets/images/TimeMinder.svg",
          width: 170,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              pureWhite,
              offOrange
            ], // Sesuaikan dengan warna aksen yang diinginkan
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: OnboardData.onBoardItemList.length,
                controller: controller,
                onPageChanged: (v) {
                  setState(() {
                    selectedIndex = v;
                  });
                },
                itemBuilder: (context, index) {
                  return ContentTemplate(
                      item: OnboardData.onBoardItemList[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, AppRoutes.navbar);
                    },
                    child: Text(
                      "skip",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      OnboardData.onBoardItemList.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        height: 8,
                        width: selectedIndex == index ? 24 : 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? ripeMango
                                : cetaceanBlue,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectedIndex <
                          OnboardData.onBoardItemList.length - 1) {
                        controller.animateToPage(selectedIndex + 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      } else {
                        Navigator.popAndPushNamed(context, AppRoutes.navbar);
                      }
                    },
                    child: Text(
                      selectedIndex != OnboardData.onBoardItemList.length - 1
                          ? ""
                          : "start",
                      style:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}