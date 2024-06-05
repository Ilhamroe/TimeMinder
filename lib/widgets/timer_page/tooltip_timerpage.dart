import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/widgets/home_page/tooltip_homepage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> timerPageTargets({
  required GlobalKey btnSemuaKey,
  required GlobalKey btnTimermuKey,
  required GlobalKey holdToEditKey,
}) {

  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
    keyTarget: btnSemuaKey,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "1/3",
            title: "Semua timer.",
            desc: "Ini adalah daftar semua timer, termasuk yang direkomendasikan dan kustom.",
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
    keyTarget: btnTimermuKey,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "2/3",
            title: "Timer mu",
            desc: "Tekan tombol ini untuk menampilkan semua timer yang telah Anda buat.",
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

  targets.add(TargetFocus(
    keyTarget: holdToEditKey,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "3/3",
            title: "Edit timer.",
            desc: "Tekan lama untuk mengedit, timer yang dapat dihapus hanya yang Anda buat, timer default tidak bisa dihapus.",
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
