import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/widgets/home_page/tooltip_homepage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> detailPageTargets({
  required GlobalKey calendarKey,
  required GlobalKey detailTimerKey,
}) {

  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
    keyTarget: calendarKey,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "1/2",
            title: "Fitur kalender.",
            desc: "Klik tombol dropdown untuk melihat kalender lebih lengkap.",
            showPreviousButton: false,
            onPrevious: () {},
            onNext: () {
              controller.next();
            },
          );
        },
      ),
    ],
  ));

  targets.add(TargetFocus(
    keyTarget: detailTimerKey,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "2/2",
            title: "Detail aktivitas.",
            desc: "Ini adalah daftar aktivitas timer yang telah kamu lakukan hari ini.",
            showPreviousButton: true,
            onPrevious: () {
              controller.previous();
            },
            onNext: () {
              controller.next();
            },
          );
        },
      ),
    ],
  ));

  return targets;
}
