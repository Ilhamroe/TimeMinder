import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [skipBtn(context), const SizedBox(width: 20)],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                  itemCount: OnboardData.onBoardItemList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  onPageChanged: (v) {
                    setState(() {
                      selectedIndex = v;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ContentTemplate(
                        item: OnboardData.onBoardItemList[index]);
                  }),
            ),
            Row(
              children: [
                SizedBox(width: size.width * 0.05),
                Row(
                  children: [
                    ...List.generate(
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
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (selectedIndex < OnboardData.onBoardItemList.length - 1) {
                      controller.animateToPage(selectedIndex + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    } else {
                      Navigator.popAndPushNamed(context, AppRoutes.home);
                    }
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: ripeMango,
                    child:
                        selectedIndex != OnboardData.onBoardItemList.length - 1
                            ? const Icon(
                                Icons.arrow_forward_rounded,
                                size: 40,
                                color: Colors.black,
                              )
                            : Text(
                                "Start",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Nunito'
                                    ),
                              ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.15),
          ],
        ),
      ),
    );
  }

  GestureDetector skipBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.popAndPushNamed(context, AppRoutes.home);
      },
      child: Text(
        "SKIP",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
